import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initNotification() async {
    /*notificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestPermission();*/
    AndroidInitializationSettings initializationSettingsAndroid =
        const AndroidInitializationSettings('@mipmap/launcher_icon');
    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: null,
    );
    await notificationsPlugin.initialize(
      initializationSettings,
    );
    /*onDidReceiveBackgroundNotificationResponse:
            (NotificationResponse notificationResponse) async {})*/
  }

  notificationDetails(String channelName, String channelID) {
    return NotificationDetails(
        android: AndroidNotificationDetails(
      channelID,
      channelName,
      importance: Importance.max,
      priority: Priority.high,
    ));
  }

  Future showNotification(
      {int id = 0,
      String? title,
      String? body,
      String? payload,
      required String channelName,
      required String channelID}) async {
    return notificationsPlugin.show(
        id, title, body, await notificationDetails(channelName, channelID));
  }
}
