import 'dart:async';
import 'package:devfest_hackathon_2023/src/services/firebase_service.dart';
import 'package:devfest_hackathon_2023/src/views/habit_screen.dart';

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
  final TextEditingController titleController = TextEditingController();
  final TextEditingController detailsController = TextEditingController();

  MyApp({required this.notificationService, required this.firebaseService, Key? key}) : super(key: key);

  void sendToFirebase() {
    final String category = categoryController.text;
    final String title = titleController.text;
    final String details = detailsController.text;

    firebaseService.uploadNotification(category, title, details);
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
                controller: detailsController,
                decoration: const InputDecoration(labelText: 'Category'),
              ),
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Text'),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: sendToFirebase,
                child: const Text('Send to Firebase'),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: firebaseService.fetchNotifications,
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
