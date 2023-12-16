// notification_service.dart
import 'dart:async';
import 'dart:core';
import 'dart:developer';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tzdata;

import '../models/notification.dart';
import 'firebase_service.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  final FirebaseService firebaseService = FirebaseService();
  static const channelId = "1";
  static const channelIdNum = 1;
  static const channelName = 'Actualizer';
  static const channelDescription = 'Shows actualizer notifications';

  List<NotificationItem> notifications = [];

  NotificationService() {
    fetchAndSetNotifications();
  }

  Future<void> initializeNotifications() async {
    tzdata.initializeTimeZones();
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    // Linux-specific settings
    const LinuxInitializationSettings initializationSettingsLinux =
    LinuxInitializationSettings(defaultActionName: 'View quote');

    const InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, linux: initializationSettingsLinux);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> showNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      channelId,
      channelName,
      channelDescription: channelDescription,
    );
    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      channelIdNum,
      channelName,
      channelDescription,
      platformChannelSpecifics,
    );
  }

  Future<void> showRandomNotification() async {
    if (notifications.isNotEmpty) {
      final random = DateTime.now().microsecondsSinceEpoch % notifications.length;
      final randomNotification = notifications[random];

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
        randomNotification.text.hashCode,
        randomNotification.category,
        randomNotification.text,
        platformChannelSpecifics
      );
    }
  }

  Future<void> scheduleNotification() async {
    const int intervalSeconds = 15;

    Timer.periodic(const Duration(seconds: intervalSeconds), (Timer timer) {
      log("Scheduling notification");
      showRandomNotification();
    });
  }

  Future<void> fetchAndSetNotifications() async {
    // Fetch notifications from Firebase and store them in the list
    notifications = await firebaseService.fetchNotifications();
  }
}