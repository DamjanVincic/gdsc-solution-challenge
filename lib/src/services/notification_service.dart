import 'dart:async';
import 'dart:core';
import 'dart:developer';
import 'package:Actualizator/src/services/self_examination_service.dart';
import 'package:cron/cron.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;
import '../models/quote.dart';
import 'quote_service.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  final SelfExaminationService selfExaminationService;
  final QuoteService quoteService;
  static const channelId = "1";
  static const channelIdNum = 1;
  static const channelName = 'Actualizer';
  static const channelDescription = 'Shows actualizer notifications';

  List<Quote> notifications = [];
  Timer? notificationTimer;

  NotificationService(
      {required this.quoteService, required this.selfExaminationService}) {
    fetchAndSetNotifications();
  }

  static const AndroidNotificationDetails _androidNotificationDetails =
  AndroidNotificationDetails(
    channelId,
    "randomString",
    channelDescription:
    "This channel is responsible for all the local notifications",
    playSound: true,
    priority: Priority.high,
    importance: Importance.high,
  );

  static const DarwinNotificationDetails _darwinNotificationDetails =
  DarwinNotificationDetails();

  final NotificationDetails notificationDetails = const NotificationDetails(
    android: _androidNotificationDetails,
    iOS: _darwinNotificationDetails,
  );

  Future<void> initializeNotifications() async {
    tzdata.initializeTimeZones();
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings(
        '@mipmap/ic_launcher');

    // Linux-specific settings
    const LinuxInitializationSettings initializationSettingsLinux = LinuxInitializationSettings(
        defaultActionName: 'View quote');

    const InitializationSettings initializationSettings =
    InitializationSettings(
      android: initializationSettingsAndroid,
      linux: initializationSettingsLinux,
    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> showNotification(Quote notificationItem) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      channelId,
      channelName,
      channelDescription: channelDescription,
    );
    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
        notificationItem.title.hashCode,
        notificationItem.category,
        notificationItem.title,
        platformChannelSpecifics);
  }

  Future<void> showExaminationNotification(String goal) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      channelId,
      channelName,
      channelDescription: channelDescription,
    );
    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
        goal.hashCode,
        "Today's Goal",
        goal,
        platformChannelSpecifics);
  }

  Future<void> showRandomNotification() async {
    if (notifications.isNotEmpty) {
      final random = DateTime
          .now()
          .microsecondsSinceEpoch % notifications.length;
      final randomNotification = notifications[random];

      await showNotification(randomNotification);
    }
  }

  Future<void> scheduleNotification() async {
    const int intervalSeconds = 15;

    // Try calling showRandomNotification directly
    showRandomNotification();

    notificationTimer = Timer.periodic(
      const Duration(seconds: intervalSeconds),
          (Timer timer) {
        log("Scheduling notification");
        showRandomNotification();
      },
    );
  }

  void cancelScheduledNotifications() {
    notificationTimer?.cancel();
  }

  Future<void> fetchAndSetNotifications() async {
    // Fetch notifications from Firebase and store them in the list
    notifications = await quoteService.fetchQuotes();
  }

}
