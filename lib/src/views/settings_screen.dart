import 'package:devfest_hackathon_2023/main.dart';
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
          title: Text("Create Quote"),
          content: Column(
            children: [
              SizedBox(height: 16),
              TextField(
                controller: categoryController,
                decoration: InputDecoration(labelText: 'Category'),
              ),
              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: detailsController,
                decoration: InputDecoration(labelText: 'Details'),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                // Perform actions for uploading the quote
                widget.quoteService.uploadQuote(categoryController.text, titleController.text, detailsController.text);
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text("Send to Firebase"),
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
          title: Text("Create Map Marker"),
          content: Column(
            children: [
              TextField(
                controller: mapMarkerLatitudeController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Map Marker Latitude'),
              ),
              TextField(
                controller: mapMarkerLongitudeController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Map Marker Longitude'),
              ),
              TextField(
                controller: mapMarkerTitleController,
                decoration: InputDecoration(labelText: 'Map Marker Title'),
              ),
              TextField(
                controller: mapMarkerSnippetController,
                decoration: InputDecoration(labelText: 'Map Marker Snippet'),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                // Perform actions for uploading the map marker
                double latitude = double.parse(mapMarkerLatitudeController.text);
                double longitude = double.parse(mapMarkerLongitudeController.text);
                widget.mapMarkerService.uploadMapMarker(latitude, longitude, mapMarkerTitleController.text, mapMarkerSnippetController.text);
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text("Upload Map Marker"),
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
        backgroundColor: Colors.white,
      ),
      body: Container(
        color: Colors.black87,
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
                style: const TextStyle(fontSize: 16, color: Colors.white),
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
                  child: const Text('Create Quote'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white, // Button background colorAccent
                    onPrimary: Colors.black87, // Text colorPrimary
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: ElevatedButton(
                  onPressed: () => _showMapMarkerDialog(context),
                  child: const Text('Create Map Marker'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white, // Button background colorAccent
                    onPrimary: Colors.black87, // Text colorPrimary
                  ),
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