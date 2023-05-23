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

  notificationDetails() {
    return const NotificationDetails(
        android: AndroidNotificationDetails(
      'channelId',
      'Dead?',
      importance: Importance.max,
      priority: Priority.high,
    ));
  }

  Future showNotification(
      {int id = 0, String? title, String? body, String? payload}) async {
    return notificationsPlugin.show(
        id, title, body, await notificationDetails());
  }
}
