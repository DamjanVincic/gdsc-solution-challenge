import 'dart:async';
import 'dart:developer';


import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tzdata;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeNotifications();
  runApp(MyApp());
}

Future<void> initializeNotifications() async {
  tzdata.initializeTimeZones();
  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('@mipmap/ic_launcher');

  // Linux-specific settings
  const LinuxInitializationSettings initializationSettingsLinux =
  LinuxInitializationSettings(defaultActionName: 'View quote');

  const InitializationSettings initializationSettings =
  InitializationSettings(android: initializationSettingsAndroid, linux: initializationSettingsLinux);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
    //final Random random = Random();
    //final int notificationId = random.nextInt(100);
    final int notificationId = 3;

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'your_channel_id', // replace with your own channel ID
      'your_channel_name', // replace with your own channel name
      channelDescription: 'your_channel_description', // replace with your own channel description
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
    const int intervalSeconds = 5;

    Timer.periodic(const Duration(seconds: intervalSeconds), (Timer timer) {
      log("Scheduling notification");
      showRandomNotification();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Local Notifications')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: showNotification,
                child: const Text('Show Notification'),
              ),
              const SizedBox(height: 16), // Add some spacing
              ElevatedButton(
                onPressed: scheduleNotification,
                child: const Text('Schedule Notification'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
