import 'package:devfest_hackathon_2023/src/views/maps_view.dart';
import 'package:devfest_hackathon_2023/src/views/hub.dart';
import 'package:flutter_config/flutter_config.dart';
import 'dart:async';
import 'package:devfest_hackathon_2023/src/services/firebase_service.dart';
import 'package:devfest_hackathon_2023/src/views/habit_list_screen.dart';
import 'package:devfest_hackathon_2023/src/views/notification_list_screen.dart';
import 'package:devfest_hackathon_2023/src/views/self_examination_list.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'src/services/notification_service.dart';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tzdata;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
final NotificationService notificationService = NotificationService();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterConfig.loadEnvVariables();
  await notificationService.initializeNotifications();
  runApp(MaterialApp(home: MyApp(notificationService: notificationService)));
  runApp(MaterialApp(
      home: MyApp(
        notificationService: notificationService,
        firebaseService: firebaseService,
      )));
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
                onPressed: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NotificationListScreen(firebaseService: firebaseService)
                    ),
                  );
                },
                child: const Text('View notification list'),
              ),
              ElevatedButton(
                onPressed: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HabitListScreen()
                    ),
                  );
                },
                child: const Text('View habits'),
              ),
            ],
          ),
        ),
      ),
      body: <Widget>[
        Hub(notificationService: notificationService),
        const MapsView(),
        const Text('Settings'),
      ][_selectedIndex],
    );
  }
}
