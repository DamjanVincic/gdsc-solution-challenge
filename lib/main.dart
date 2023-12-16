import 'package:devfest_hackathon_2023/src/models/marker.dart';
import 'package:devfest_hackathon_2023/src/services/marker_service.dart';
import 'package:devfest_hackathon_2023/src/views/maps_view.dart';
import 'package:devfest_hackathon_2023/src/views/hub.dart';
import 'package:devfest_hackathon_2023/src/views/settings_screen.dart';
import 'package:flutter_config/flutter_config.dart';
import 'dart:async';
import 'package:devfest_hackathon_2023/src/services/firebase_service.dart';

import 'src/services/notification_service.dart';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tzdata;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
final FirebaseService firebaseService = FirebaseService();
final MarkerService markerService = MarkerService();
final NotificationService notificationService = NotificationService(firebaseService: firebaseService);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //await FlutterConfig.loadEnvVariables();
  await notificationService.initializeNotifications();
  runApp(MaterialApp(
      home: MyApp(
        notificationService: notificationService,
        firebaseService: firebaseService,
        markerService: markerService,
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

class MyApp extends StatefulWidget {
  final NotificationService notificationService;
  final FirebaseService firebaseService;
  final MarkerService markerService;

  MyApp({super.key, required this.notificationService, required this.firebaseService, required this.markerService});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: <Widget>[
          Hub(firebaseService: widget.firebaseService),
          MapsView(markerService: widget.markerService),
          SettingsScreen(notificationService: widget.notificationService, firebaseService: widget.firebaseService)
        ][_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.map),
              label: 'Map',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
        ),
      ),
    );
  }
}
