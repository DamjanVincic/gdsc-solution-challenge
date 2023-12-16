import 'package:devfest_hackathon_2023/src/services/firebase_service.dart';
import 'package:devfest_hackathon_2023/src/services/notification_service.dart';
import 'package:devfest_hackathon_2023/src/views/habit_list_screen.dart';
import 'package:devfest_hackathon_2023/src/views/notification_list_screen.dart';
import 'package:devfest_hackathon_2023/src/views/self_examination_list_screen.dart';
import 'package:flutter/material.dart';

class Hub extends StatelessWidget {
  Hub({super.key, required this.firebaseService});

  final FirebaseService firebaseService;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => NotificationListScreen(
                          firebaseService: firebaseService)),
                );
              },
              child: const Text('QUOTES'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const HabitListScreen()),
                );
              },
              child: const Text('HABITS'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SelfExaminationListScreen()),
                );
              },
              child: const Text('SELF EXAMINATION'),
            ),
          ],
        ),
      ),
    );
  }
}
