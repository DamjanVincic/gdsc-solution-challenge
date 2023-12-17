import 'package:devfest_hackathon_2023/src/services/quote_service.dart';
import 'package:devfest_hackathon_2023/src/services/notification_service.dart';
import 'package:devfest_hackathon_2023/src/views/habit_list_screen.dart';
import 'package:devfest_hackathon_2023/src/views/notification_list_screen.dart';
import 'package:devfest_hackathon_2023/src/views/self_examination_list_screen.dart';
import 'package:flutter/material.dart';

import 'meditation_screen.dart';

class Hub extends StatelessWidget {
  Hub({super.key, required this.quoteService});

  final QuoteService quoteService;

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
                          quoteService: quoteService)),
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
            ElevatedButton(
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const MeditationScreen()),
                );
              },
              child: const Text('MEDITATION')
            ),
          ],
        ),
      ),
    );
  }
}
