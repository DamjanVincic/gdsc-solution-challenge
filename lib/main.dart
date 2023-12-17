import 'dart:async';
import 'package:Actualizator/src/services/map_marker_service.dart';
import 'package:Actualizator/src/views/maps_view.dart';
import 'package:Actualizator/src/views/hub.dart';
import 'package:Actualizator/src/views/settings_screen.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:Actualizator/src/services/quote_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'src/services/notification_service.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
final QuoteService quoteService = QuoteService();
final MapMarkerService mapMarkerService = MapMarkerService();
final NotificationService notificationService = NotificationService(quoteService: quoteService);
const Color primaryColor = Colors.white70;
const Color accentColor = Colors.black87;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //await FlutterConfig.loadEnvVariables();
  await notificationService.initializeNotifications();
  runApp(
    MaterialApp(
      home: MyApp(
        notificationService: notificationService,
        quoteService: quoteService,
        mapMarkerService: mapMarkerService,
      ),
    ),
  );
}

Future<void> initializeNotifications() async {
  tzdata.initializeTimeZones();
  const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');

  // Linux-specific settings
  const LinuxInitializationSettings initializationSettingsLinux = LinuxInitializationSettings(defaultActionName: 'View quote');

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    linux: initializationSettingsLinux,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
}

class MyApp extends StatefulWidget {
  final NotificationService notificationService;
  final QuoteService quoteService;
  final MapMarkerService mapMarkerService;

  const MyApp({
    super.key,
    required this.notificationService,
    required this.quoteService,
    required this.mapMarkerService,
  });

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
          Hub(quoteService: widget.quoteService, primaryColor: primaryColor, accentColor: accentColor),
          MapsView(mapMarkerService: widget.mapMarkerService),
          SettingsScreen(
            notificationService: widget.notificationService,
            quoteService: widget.quoteService,
            mapMarkerService: widget.mapMarkerService,
          )
        ][_selectedIndex],
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
      ),
    );
  }
}
