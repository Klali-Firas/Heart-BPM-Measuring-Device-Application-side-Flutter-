import 'package:flutter/material.dart';

class About extends StatelessWidget {
  const About({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("About"),
      ),
      body: WillPopScope(
        onWillPop: () async {
          Navigator.pop(context);
          return true;
        },
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: const [
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                      "The IoT BPM Monitoring Project is an innovative endeavor aimed at measuring an individual's heart rate or beats per minute (BPM) using IoT technology. The project's primary objective is to provide users with a convenient and accessible means of monitoring their heart rate in real-time. By leveraging IoT technologies, the project enables individuals to track their cardiovascular health, exercise intensity, and make informed decisions about their well-being.\n\nThe hardware components employed in the project are the ESP32 microcontroller and a pulse sensor. The ESP32, equipped with built-in Wi-Fi capabilities, acts as the central component of the system, facilitating seamless communication between the pulse sensor and the Android app. The pulse sensor, carefully placed on the fingertip or earlobe, detects subtle changes in blood volume and converts them into measurable electrical signals.\n\nTo seamlessly integrate the hardware components and provide real-time BPM readings, the project utilizes various software technologies. The Arduino platform is used to program the ESP32 microcontroller, allowing the analog signal from the pulse sensor to be read and processed accurately to extract the BPM value. The Flutter framework, known for its versatility and cross-platform compatibility, is employed to develop an intuitive Android app. The app provides a user-friendly interface for displaying live BPM readings to users in real-time. Additionally, the project utilizes Firebase Realtime Database as the backend solution, ensuring a reliable connection between the ESP32 and the Android app. Firebase facilitates instant data synchronization, ensuring that the BPM data is updated and accessible to users without any delay.\n\nThe project was developed by a team of skilled developers including Firas Klali, Salsabil Beaujenfa, Roua Fatnassi, and Yassine Saadaoui. Each team member contributed their expertise in hardware, programming, and app development to bring the project to fruition. Through their collaboration and innovation, they successfully created a solution that accurately measures BPM and provides users with vital information for prioritizing their cardiovascular health.")
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
