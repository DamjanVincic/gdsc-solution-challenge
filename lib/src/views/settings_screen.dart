import 'package:flutter/material.dart';
import '../services/notification_service.dart';
import '../services/quote_service.dart';
import '../services/map_marker_service.dart'; // Import your map marker service

class SettingsScreen extends StatefulWidget {
  final NotificationService notificationService;
  final QuoteService quoteService;
  final MapMarkerService mapMarkerService; // Add your map marker service

  const SettingsScreen({
    super.key,
    required this.notificationService,
    required this.quoteService,
    required this.mapMarkerService,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isNotificationScheduled = false;

  Future<void> _showQuoteDialog(BuildContext context) async {
    TextEditingController categoryController = TextEditingController();
    TextEditingController titleController = TextEditingController();
    TextEditingController detailsController = TextEditingController();

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Upload a new quote"),
          content: Column(
            children: [
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
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                // Perform actions for uploading the quote
                widget.quoteService.uploadQuote(categoryController.text, titleController.text, detailsController.text);
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text("Upload"),
            ),
          ],
        );
      },
    );
  }


  Future<void> _showMapMarkerDialog(BuildContext context) async {
    TextEditingController mapMarkerLatitudeController = TextEditingController();
    TextEditingController mapMarkerLongitudeController = TextEditingController();
    TextEditingController mapMarkerTitleController = TextEditingController();
    TextEditingController mapMarkerSnippetController = TextEditingController();

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Upload a new map marker"),
          content: Column(
            children: [
              TextField(
                controller: mapMarkerLatitudeController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Latitude'),
              ),
              TextField(
                controller: mapMarkerLongitudeController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Longitude'),
              ),
              TextField(
                controller: mapMarkerTitleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: mapMarkerSnippetController,
                decoration: const InputDecoration(labelText: 'Snippet'),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                // Perform actions for uploading the map marker
                double latitude = double.parse(mapMarkerLatitudeController.text);
                double longitude = double.parse(mapMarkerLongitudeController.text);
                widget.mapMarkerService.uploadMapMarker(latitude, longitude, mapMarkerTitleController.text, mapMarkerSnippetController.text);
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text("Upload"),
            ),
          ],
        );
      },
    );
  }


  @override
  void initState() {
    super.initState();
    isNotificationScheduled = false; // Set the initial state
  }

  void toggleNotification() {
    setState(() {
      if (isNotificationScheduled) {
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
        title: const Text('Settings'),
        backgroundColor: Colors.white70,
      ),
      body: Container(
        color: Colors.white38,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 16),
              Text(
                isNotificationScheduled
                    ? 'Receiving Notifications: On'
                    : 'Receiving Notifications: Off',
                style: const TextStyle(fontSize: 16, color: Colors.black87),
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
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: ElevatedButton(
                  onPressed: () => _showQuoteDialog(context),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white70, // Button background colorAccent
                    onPrimary: Colors.black87, // Text colorPrimary
                  ),
                  child: const Text('Create Quote'),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: ElevatedButton(
                  onPressed: () => _showMapMarkerDialog(context),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white70, // Button background colorAccent
                    onPrimary: Colors.black87, // Text colorPrimary
                  ),
                  child: const Text('Create Map Marker'),
                ),
              ),
              Expanded(
                child: Container(), // Empty container to fill remaining space
              ),
            ],
          ),
        ),
      ),
    );
  }
}