import 'dart:async';
import 'dart:core';
import 'dart:developer';
import 'package:Actualizator/src/services/self_examination_service.dart';
import 'package:cron/cron.dart';
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

  NotificationService({required this.quoteService, required this.selfExaminationService}) {
    fetchAndSetNotifications();
  }

  Future<void> initializeNotifications() async {
    tzdata.initializeTimeZones();
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');

    // Linux-specific settings
    const LinuxInitializationSettings initializationSettingsLinux = LinuxInitializationSettings(defaultActionName: 'View quote');

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

  Future<void> showRandomNotification() async {
    if (notifications.isNotEmpty) {
      final random = DateTime.now().microsecondsSinceEpoch % notifications.length;
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

  // Future<void> showTodayExaminations() async {
  //   List<String> examinations = await selfExaminationService.getTodayExaminations();
  //   if (examinations.isEmpty) {
  //     return;
  //   }
  //   final cron = Cron();
  //   cron.schedule(Schedule.parse("35 18 * * *"), () async => {
  //     for (String goal in examinations) {
  //       showExamination(goal)
  //   }
  //   });
  // }
  //
  // Future<void> showExamination(String goal) async {
  //   const AndroidNotificationDetails androidPlatformChannelSpecifics =
  //   AndroidNotificationDetails(
  //     channelId,
  //     channelName,
  //     channelDescription: channelDescription,
  //   );
  //   const NotificationDetails platformChannelSpecifics =
  //   NotificationDetails(android: androidPlatformChannelSpecifics);
  //
  //   await flutterLocalNotificationsPlugin.show(
  //       goal.hashCode,
  //       "Today's Goal",
  //       goal,
  //       platformChannelSpecifics);
  // }

  Future<void> showDailyGoals() async {
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      channelId,
      channelName,
      channelDescription: channelDescription,
    );
    NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);

    for (String goal in await selfExaminationService.getTodayExaminations()) {
      await flutterLocalNotificationsPlugin.zonedSchedule(
        goal.hashCode,
        'Daily Goals',
        goal,
        _nextInstanceOfSixThirtyFivePM(),
        platformChannelSpecifics,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    }
  }

  tz.TZDateTime _nextInstanceOfSixThirtyFivePM() {
    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      18,
      49,
    );
    if (now.isAfter(scheduledDate)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

}
