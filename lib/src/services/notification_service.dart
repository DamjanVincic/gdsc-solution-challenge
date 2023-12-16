// notification_service.dart
import 'dart:async';
import 'dart:developer';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tzdata;

class NotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  Future<void> initializeNotifications() async {
    tzdata.initializeTimeZones();
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    // Linux-specific settings
    const LinuxInitializationSettings initializationSettingsLinux =
    LinuxInitializationSettings(defaultActionName: 'View quote');

    const InitializationSettings initializationSettings =
    InitializationSettings(
        android: initializationSettingsAndroid,
        linux: initializationSettingsLinux);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> showNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      '1', // Change this to a unique ID
      'Actualizer notification channel',
      channelDescription: 'Shows actualizer notifications',
    );
    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0,
      'Hello, Flutter!',
      'This is your first local notification.',
      platformChannelSpecifics,
    );
  }

  Future<void> showRandomNotification() async {
    const int notificationId = 3;

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'your_channel_id', // replace with your own channel ID
      'your_channel_name', // replace with your own channel name
      channelDescription: 'your_channel_description',
      // replace with your own channel description
      importance: Importance.high,
      priority: Priority.high,
    );

    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      notificationId,
      'Random Notification',
      'This is a random notification message.',
      platformChannelSpecifics,
      payload: 'item x',
    );
  }

  Future<void> scheduleNotification() async {
    const int intervalSeconds = 15;

    Timer.periodic(const Duration(seconds: intervalSeconds), (Timer timer) {
      log("Scheduling notification");
      showRandomNotification();
    });
  }
}