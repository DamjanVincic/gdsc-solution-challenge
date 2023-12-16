import 'package:flutter/material.dart';
import '../services/notification_service.dart';
import '../services/quote_service.dart';
import '../services/map_marker_service.dart'; // Import your map marker service

class SettingsScreen extends StatefulWidget {
  final NotificationService notificationService;
  final QuoteService quoteService;
  final MapMarkerService mapMarkerService; // Add your map marker service

  SettingsScreen({
    required this.notificationService,
    required this.quoteService,
    required this.mapMarkerService,
  });

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController detailsController = TextEditingController();
  final TextEditingController mapMarkerLatitudeController = TextEditingController();
  final TextEditingController mapMarkerLongitudeController = TextEditingController();
  final TextEditingController mapMarkerTitleController = TextEditingController();
  final TextEditingController mapMarkerSnippetController = TextEditingController();

  bool isNotificationScheduled = false;

  @override
  void initState() {
    super.initState();
    isNotificationScheduled = false; // Set the initial state
  }

  void uploadQuote() {
    final String category = categoryController.text;
    final String title = titleController.text;
    final String details = detailsController.text;

    widget.quoteService.uploadQuote(category, title, details);
  }

  void uploadMapMarker() {
    double latitude = double.parse(mapMarkerLatitudeController.text);
    double longitude = double.parse(mapMarkerLongitudeController.text);
    String title = mapMarkerTitleController.text;
    String snippet = mapMarkerSnippetController.text;

    widget.mapMarkerService.uploadMapMarker(latitude, longitude, title, snippet);
  }

  void toggleNotification() {
    setState(() {
      if (isNotificationScheduled) {
        print("Cancelling");
        // Cancel the scheduled notifications
        widget.notificationService.cancelScheduledNotifications();
      } else {
        // Schedule periodic notifications
        widget.notificationService.scheduleNotification();
      }
      isNotificationScheduled = !isNotificationScheduled; // Toggle the state
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          Text(
            isNotificationScheduled
                ? 'Receiving Notifications: On'
                : 'Receiving Notifications: Off',
            style: TextStyle(fontSize: 16),
          ),
          Switch(
            value: isNotificationScheduled,
            onChanged: (value) {
              setState(() {
                isNotificationScheduled = value;
                if (isNotificationScheduled) {
                  widget.notificationService.scheduleNotification();
                } else {
                  widget.notificationService.cancelScheduledNotifications();
                }
              });
            },
            activeTrackColor: Colors.lightGreenAccent,
            activeColor: Colors.green,
            inactiveTrackColor: Colors.red,
            inactiveThumbColor: Colors.redAccent,
            materialTapTargetSize: MaterialTapTargetSize.padded,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: categoryController,
            decoration: const InputDecoration(labelText: 'Category'),
          ),
          TextField(
            controller: titleController,
            decoration: const InputDecoration(labelText: 'Title'),
          ),
          TextField(
            controller: detailsController,
            decoration: const InputDecoration(labelText: 'Details'),
          ),
          const SizedBox(height: 16.0),
          TextField(
            controller: mapMarkerLatitudeController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Map Marker Latitude'),
          ),
          TextField(
            controller: mapMarkerLongitudeController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Map Marker Longitude'),
          ),
          TextField(
            controller: mapMarkerTitleController,
            decoration: const InputDecoration(labelText: 'Map Marker Title'),
          ),
          TextField(
            controller: mapMarkerSnippetController,
            decoration: const InputDecoration(labelText: 'Map Marker Snippet'),
          ),
          const SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: uploadQuote,
            child: const Text('Send to Firebase'),
          ),
          ElevatedButton(
            onPressed: uploadMapMarker,
            child: const Text('Upload Map Marker'),
          ),
        ],
      ),
    );
  }
}
