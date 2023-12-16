import 'dart:async';
import 'package:devfest_hackathon_2023/src/services/firebase_service.dart';
import 'package:devfest_hackathon_2023/src/views/habit_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'src/services/notification_service.dart';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tzdata;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

Future<void> main() async {
  // SharedPreferences prefs = await SharedPreferences.getInstance();
  // await prefs.clear();

  WidgetsFlutterBinding.ensureInitialized();
  final FirebaseService firebaseService = FirebaseService();
  //await firebaseService.initialize();
  final NotificationService notificationService = NotificationService();
  await notificationService.initializeNotifications();
  runApp(MaterialApp(home: MyApp(notificationService: notificationService, firebaseService: firebaseService)));
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
  final NotificationService notificationService;

  final FirebaseService firebaseService;
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController textController = TextEditingController();

  MyApp({required this.notificationService, required this.firebaseService, Key? key}) : super(key: key);

  void sendToFirebase() {
    final String category = categoryController.text;
    final String text = textController.text;

    firebaseService.pushNotification(category, text);
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
                onPressed: notificationService.showNotification,
                child: const Text('Show Notification'),
              ),
              const SizedBox(height: 16), // Add some spacing
              ElevatedButton(
                onPressed: notificationService.scheduleNotification,
                child: const Text('Schedule Notification'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: categoryController,
                decoration: const InputDecoration(labelText: 'Category'),
              ),
              TextField(
                controller: textController,
                decoration: const InputDecoration(labelText: 'Text'),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: sendToFirebase,
                child: const Text('Send to Firebase'),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: firebaseService.getNotifications,
                child: const Text('Get Items by Category'),
              ),
              ElevatedButton(
                onPressed: () {
                  // Navigate to the HabitScreen
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HabitScreen()),
                  );
                },
                child: Text('View Habit Screen'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
