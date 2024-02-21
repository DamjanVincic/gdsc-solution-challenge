import 'dart:async';
import 'dart:core';
import 'package:Actualizator/src/repository/settings_repository.dart';
import 'package:Actualizator/src/services/self_examination_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import '../models/quote.dart';
import 'quote_service.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  final SelfExaminationService selfExaminationService;
  final QuoteService quoteService;
  final SettingsRepository settingsRepository;
  static const channelId = "1";
  static const channelIdNum = 1;
  static const channelName = 'Actualizer';
  static const channelDescription = 'Shows actualizer notifications';
  static const gratitudeNotificationTitle = 'Gratitude journal';
  static const gratitudeNotificationSubtitle = 'What are you grateful for today?';

  List<Quote> quotes = [];
  Timer? quoteNotificationTimer;

  Timer? gratitudeNotificationTimer;
  
  NotificationService({required this.settingsRepository, required this.quoteService, required this.selfExaminationService}) {
    _setQuotes();
    //fetchAndSetNotifications();
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

  Future<void> scheduleQuoteNotification() async {
    DateTime? scheduledTime = await settingsRepository.getQuoteDateTime();
    scheduledTime ??= DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 10, 0, 0);

    // Calculate the delay until the scheduled time
    DateTime now = DateTime.now();
    Duration delay = scheduledTime.difference(now);

    // If the scheduled time is in the past, adjust it to the next day
    if (delay.isNegative) {
      scheduledTime = scheduledTime.add(const Duration(days: 1));
      delay = scheduledTime.difference(now);
    }

    // Convert the delay to seconds
    int delaySeconds = delay.inSeconds;

    // Call showRandomQuoteNotification directly to prove that it works
    _showRandomQuoteNotification();

    // Set up periodic timer with delaySeconds interval
    Timer.periodic(Duration(seconds: delaySeconds), (Timer timer) {
      print("Scheduling random quote notification");
      _showRandomQuoteNotification();
    });
  }

  void cancelQuoteNotifications() {
    quoteNotificationTimer?.cancel();
  }

  Future<void> scheduleGratitudeNotification() async {
    DateTime? scheduledTime = await settingsRepository.getDiaryDateTime();
    scheduledTime ??= DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 10, 0, 0);

    // Calculate the delay until the scheduled time
    DateTime now = DateTime.now();
    Duration delay = scheduledTime.difference(now);

    // If the scheduled time is in the past, adjust it to the next day
    if (delay.isNegative) {
      scheduledTime = scheduledTime.add(const Duration(days: 1));
      delay = scheduledTime.difference(now);
    }

    // Convert the delay to seconds
    int delaySeconds = delay.inSeconds;

    // Call showGratitudeNotification directly to prove that it works
    _showGratitudeNotification();

    // Set up periodic timer with delaySeconds interval
    Timer.periodic(Duration(seconds: delaySeconds), (Timer timer) {
      print("Scheduling gratitude notification");
      _showGratitudeNotification();
    });
  }

  void cancelGratitudeNotifications() {
    gratitudeNotificationTimer?.cancel();
  }

  Future<void> _showNotification(String title, String subtitle) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      channelId,
      channelName,
      channelDescription: channelDescription,
    );
    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
        title.hashCode,
        title,
        subtitle,
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

  Future<void> _showRandomQuoteNotification() async {
    if (quotes.isNotEmpty) {
      final random = DateTime.now().microsecondsSinceEpoch % quotes.length;
      final randomQuote = quotes[random];
      
      await _showNotification(randomQuote.category, randomQuote.title);
    }
  }

  Future<void> _showGratitudeNotification() async {
    await _showNotification(gratitudeNotificationTitle, gratitudeNotificationSubtitle);
  }

  // Fetch notifications from Firebase and store them in the list
  Future<void> _setQuotes() async {
    quotes = await quoteService.fetchQuotes();
  }

}
