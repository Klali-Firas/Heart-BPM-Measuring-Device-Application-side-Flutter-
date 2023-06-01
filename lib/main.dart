// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import './widgets/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'user_data.dart';
import 'about.dart';
import 'widgets/Notification.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await NotificationService().initNotification();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ESP32_IOT',
      initialRoute: '/',
      routes: {
        '/': (context) => const MyHomePage(title: 'Flutter Demo Home Page'),
        '/second': (context) => const UserData(),
        '/third': (context) => const About(),
      },
      theme: ThemeData(
        textTheme: const TextTheme(
          bodyMedium: TextStyle(fontWeight: FontWeight.w700),
          bodySmall: TextStyle(fontWeight: FontWeight.w700),
        ),
        fontFamily: "Product Sans",
        primarySwatch: Colors.pink,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void uselogin() {
    login(_emailController.text.trim(), _passwordController.text.trim());
  }

  void usesignup() {
    signup(_emailController.text.trim(), _passwordController.text.trim());
  }

  bool visib = false;
  void changevisib() {
    setState(() {
      visib = !visib;
    });
  }

  bool log_or_create = true;
  void log_to_sign() {
    setState(() {
      log_or_create = !log_or_create;
    });
  }

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        Navigator.pushNamed(context, '/second');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("ESP32_IOT"),
      ),
      body: Column(children: [
        const SizedBox(
          height: 30,
        ),
        Image.asset(
          "assests/icons/heart_icon.png",
          width: 75,
        ),
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics()),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 60),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.email_outlined),
                      border: OutlineInputBorder(),
                      labelText: 'Email',
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: TextFormField(
                    maxLength: 8,
                    controller: _passwordController,
                    obscureText: !visib,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: GestureDetector(
                        onTap: changevisib,
                        child: Icon(
                            !visib ? Icons.visibility : Icons.visibility_off),
                      ),
                      helperText: "No more than 8 characters!",
                      border: const OutlineInputBorder(),
                      labelText: 'Password',
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          fixedSize: const Size(340, 50)),
                      onPressed: log_or_create ? uselogin : usesignup,
                      child: Text(
                        log_or_create ? 'LOGIN' : "CREATE ACCOUNT",
                        style: const TextStyle(fontSize: 19),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(log_or_create
                        ? "Don't have account? "
                        : "Already have an account? "),
                    GestureDetector(
                      onTap: log_to_sign,
                      child: Text(
                        log_or_create ? "create a new account" : "Login",
                        style: const TextStyle(color: Colors.pink),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                )
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
