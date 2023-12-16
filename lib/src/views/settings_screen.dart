import 'package:devfest_hackathon_2023/src/services/notification_service.dart';
import 'package:flutter/material.dart';
import '../services/firebase_service.dart';

class SettingsScreen extends StatefulWidget {
  final NotificationService notificationService;
  final FirebaseService firebaseService;

  SettingsScreen({
    required this.notificationService,
    required this.firebaseService,
  });

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController detailsController = TextEditingController();

  bool isNotificationScheduled = false;

  @override
  void initState() {
    super.initState();
    isNotificationScheduled = false; // Set the initial state
  }

  void sendToFirebase() {
    final String category = categoryController.text;
    final String title = titleController.text;
    final String details = detailsController.text;

    widget.firebaseService.uploadNotification(category, title, details);
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
          ElevatedButton(
            onPressed: sendToFirebase,
            child: const Text('Send to Firebase'),
          )
        ],
      ),
    );
  }
}
