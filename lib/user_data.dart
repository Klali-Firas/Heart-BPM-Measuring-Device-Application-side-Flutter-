import 'dart:ffi';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import './widgets/login.dart';
import 'widgets/chart.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'widgets/Notification.dart';

class UserData extends StatefulWidget {
  const UserData({super.key});

  @override
  State<UserData> createState() => _UserData();
}

class _UserData extends State<UserData> {
  final ref = FirebaseDatabase.instance
      .ref()
      .child("UserData")
      .child("cap2")
      .child("readings");

  final List<FlSpot> spots = [const FlSpot(0, 70)];
  String bpm = "";
  double avg = 0;
  late double max = 0;
  late double min = 0;
  late Stream<DateTime> dateTimeStream;
  late Timer timer;
  int dangerlow = 0;
  int dangerhigh = 0;

  void checkDangerLow() {
    if (dangerlow < 2) {
      dangerlow++;
    } else {
      NotificationService().showNotification(
          body: "Your heart rate is at dangerous rate!",
          title: "Your heart rate is very low!",
          channelName: "Low",
          channelID: "low");
      dangerlow = 0;
    }
  }

  void checkDangerhigh() {
    if (dangerhigh < 2) {
      dangerhigh++;
    } else {
      NotificationService().showNotification(
          body: "Your heart rate is at dangerous rate!",
          title: "Your heart rate is very high!",
          channelName: "High",
          channelID: "high");
      dangerhigh = 0;
    }
  }

  @override
  void initState() {
    super.initState();

    dateTimeStream = Stream<DateTime>.periodic(
        const Duration(seconds: 1), (_) => DateTime.now());
    timer = Timer.periodic(const Duration(seconds: 1), (_) => setState(() {}));
    ref.onValue.listen((event) {
      var data = event.snapshot.value;
      if (data != null && data is Map) {
        setState(() {
          avg = 0;
          max = spots[spots.length <= 12 ? 0 : (spots.length - 12).toInt()].y;
          min = spots[spots.length <= 12 ? 0 : (spots.length - 12).toInt()].y;

          bpm = (data["BPM"].toString());
          if (double.parse(bpm) > 150 || double.parse(bpm) < 50) {
            bpm = spots[spots.length - 1].y.toString();
          }
          if (double.parse(bpm) < 60) {
            checkDangerLow();
          } else {
            dangerlow = 0;
          }
          if (double.parse(bpm) > 120) {
            checkDangerhigh();
          } else {
            dangerhigh = 0;
          }
          spots.add(FlSpot(spots.length.toDouble(), double.parse(bpm)));

          for (int i = spots.length <= 12 ? 0 : (spots.length - 12).toInt();
              i < spots.length;
              i++) {
            avg += spots[i].y;
            max = max > spots[i].y ? max : spots[i].y;
            min = min < spots[i].y ? min : spots[i].y;
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/third');
              },
              icon: Image.asset(
                "assests/icons/info_icon.png",
                width: 20,
                color: Colors.white,
              ),
            ),
          ],
          leading: GestureDetector(
            child: const Icon(Icons.arrow_back_ios_new),
            onTap: () {
              Navigator.pop(context);
              signout();
            },
          ),
          centerTitle: true,
          title: const Text("ESP32_IOT"),
        ),
        body: WillPopScope(
          onWillPop: () async {
            Navigator.pop(context);
            signout();
            return true;
          },
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(children: [
                StreamBuilder<DateTime>(
                    stream: dateTimeStream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final dateTime = snapshot.data!;
                        final dateFormat = DateFormat('MMMM d, yyyy');
                        final formattedDate = dateFormat.format(dateTime);
                        final formattedTime = DateFormat.Hm().format(dateTime);
                        return Text(
                          "$formattedDate  $formattedTime",
                          style: const TextStyle(
                              color: Color.fromARGB(255, 23, 23, 23),
                              fontSize: 15),
                        );
                      } else {
                        return const CircularProgressIndicator();
                      }
                    }),
                const SizedBox(
                  height: 20,
                ),
                Expanded(
                    child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Chart(
                          spots: spots,
                          max: max,
                          min: min,
                        ))),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    card("BPM", bpm),
                    card(
                        "AVG",
                        (avg ~/ (spots.length <= 12 ? spots.length : 12))
                            .toString()),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    card("MIN", min.toInt().toString()),
                    card("MAX", max.toInt().toString()),
                  ],
                ),
              ]),
            ),
          ),
        ));
  }
}

Widget card(String lead, String trail) {
  return Card(
    shape: const RoundedRectangleBorder(
        side: BorderSide(color: Colors.pink),
        borderRadius: BorderRadius.all(Radius.circular(15))),
    color: const Color.fromARGB(255, 255, 251, 251),
    shadowColor: Colors.grey,
    elevation: 1.5,
    child: SizedBox(
        height: 100,
        width: 150,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              lead,
              style: const TextStyle(fontSize: 19),
            ),
            Text(trail,
                style: const TextStyle(color: Colors.pink, fontSize: 19)),
          ],
        )),

    /**/
  );
}
