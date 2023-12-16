import 'package:devfest_hackathon_2023/src/services/firebase_service.dart';
import 'package:devfest_hackathon_2023/src/services/notification_service.dart';
import 'package:devfest_hackathon_2023/src/views/habit_list_screen.dart';
import 'package:devfest_hackathon_2023/src/views/notification_list_screen.dart';
import 'package:devfest_hackathon_2023/src/views/self_examination_list_screen.dart';
import 'package:flutter/material.dart';

class Hub extends StatelessWidget {
  Hub({super.key, required this.notificationService});

  final NotificationService notificationService;
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController detailsController = TextEditingController();

  final FirebaseService firebaseService = FirebaseService();

  void sendToFirebase() {
    final String category = categoryController.text;
    final String title = titleController.text;
    final String details = detailsController.text;

    firebaseService.uploadNotification(category, title, details);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      builder: (context) => NotificationListScreen(
                          firebaseService: firebaseService)),
                );
              },
              child: const Text('View notification list'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const HabitListScreen()),
                );
              },
              child: const Text('View habits'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SelfExaminationListScreen()),
                );
              },
              child: const Text('View habits'),
            ),
          ],
        ),
      ),
    );
  }
}
