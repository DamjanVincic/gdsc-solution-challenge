import 'dart:async';
import 'dart:core';
import 'dart:developer';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import '../models/quote.dart';
import 'quote_service.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  final QuoteService quoteService;
  static const channelId = "1";
  static const channelIdNum = 1;
  static const channelName = 'Actualizer';
  static const channelDescription = 'Shows actualizer notifications';
  static const gratitudeNotificationTitle = 'Gratitude journal';
  static const gratitudeNotificationSubtitle = 'What are you grateful for today?';

  List<Quote> quotes = [];
  Timer? quoteNotificationTimer;

  Timer? gratitudeNotificationTimer;
  
  NotificationService({required this.quoteService}) {
    _setQuotes();
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

  Future<void> scheduleQuoteNotification() async {
    const int intervalSeconds = 15;

    // Try calling showRandomNotification directly
    _showRandomQuoteNotification();

    quoteNotificationTimer = Timer.periodic(
      const Duration(seconds: intervalSeconds),
          (Timer timer) {
        log("Scheduling quote notification");
        _showRandomQuoteNotification();
      },
    );
  }

  void cancelQuoteNotifications() {
    quoteNotificationTimer?.cancel();
  }

  Future<void> scheduleGratitudeNotification() async {
    const int intervalSeconds = 15;

    // Try calling showRandomNotification directly
    _showGratitudeNotification();

    gratitudeNotificationTimer = Timer.periodic(
      const Duration(seconds: intervalSeconds),
          (Timer timer) {
        log("Scheduling gratitude notification");
        _showGratitudeNotification();
      },
    );
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
