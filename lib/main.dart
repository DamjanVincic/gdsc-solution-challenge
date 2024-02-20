import 'dart:async';
import 'package:Actualizator/src/services/map_marker_service.dart';
import 'package:Actualizator/src/screens/map_screen.dart';
import 'package:Actualizator/src/screens/hub_screen.dart';
import 'package:Actualizator/src/screens/settings_screen.dart';
import 'package:Actualizator/src/services/quote_service.dart';
import 'package:Actualizator/src/services/self_examination_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'src/services/notification_service.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
final QuoteService quoteService = QuoteService();
final MapMarkerService mapMarkerService = MapMarkerService();
final SelfExaminationService selfExaminationService = SelfExaminationService();
final NotificationService notificationService = NotificationService(quoteService: quoteService, selfExaminationService: selfExaminationService);
const Color primaryColor = Colors.white70;
const Color accentColor = Colors.black87;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterConfig.loadEnvVariables();
  await initializeNotifications();
  runApp(const MyApp());
}

Future<void> initializeNotifications() async {
  tzdata.initializeTimeZones();
  const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
  const LinuxInitializationSettings initializationSettingsLinux = LinuxInitializationSettings(defaultActionName: 'View quote');
  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    linux: initializationSettingsLinux,
  );
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          HubScreen(quoteService: quoteService, selfExaminationService: selfExaminationService, primaryColor: primaryColor, accentColor: accentColor),
          MapScreen(mapMarkerService: mapMarkerService),
          SettingsScreen(notificationService: notificationService, quoteService: quoteService, mapMarkerService: mapMarkerService)
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Mental hub',
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
    );
  }
}
