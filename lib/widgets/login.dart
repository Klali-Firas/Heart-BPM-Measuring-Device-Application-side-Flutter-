import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

void _showToast(String msg) {
  Fluttertoast.showToast(
    msg: msg,
    toastLength: Toast.LENGTH_SHORT,
  );
}

Future<void> login(String email, String pass) async {
  try {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: pass,
    );
    _showToast('logged in successfully');
  } on FirebaseAuthException catch (e) {
    if (e.code == 'wrong-password') {
      _showToast('Invalid password provided');
    } else if (e.code == 'user-not-found') {
      _showToast('No user found for that email');
    } else {
      print(e);
    }
  } catch (e) {
    print(e);
  }
}

Future<void> signup(String email, String pass) async {
  try {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: pass,
    );
  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      _showToast('The password provided is too weak.');
    } else if (e.code == 'email-already-in-use') {
      _showToast('The account already exists for that email.');
    }
  } catch (e) {
    print(e);
  }
}

bool isloggedin() {
  final user = FirebaseAuth.instance.currentUser;
  return user != null;
}

Future<void> signout() async {
  await FirebaseAuth.instance.signOut();
}
