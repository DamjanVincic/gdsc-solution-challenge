import 'package:devfest_hackathon_2023/src/services/quote_service.dart';
import 'package:devfest_hackathon_2023/src/services/notification_service.dart';
import 'package:devfest_hackathon_2023/src/views/habit_list_screen.dart';
import 'package:devfest_hackathon_2023/src/views/quote_list_screen.dart';
import 'package:devfest_hackathon_2023/src/views/self_examination_list_screen.dart';
import 'package:flutter/material.dart';

import 'meditation_screen.dart';

class Hub extends StatelessWidget {
  Hub({Key? key, required this.quoteService, required this.primaryColor, required this.accentColor}) : super(key: key);

  final QuoteService quoteService;
  final Color primaryColor;
  final Color accentColor;

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
                      builder: (context) => QuoteListScreen(
                          quoteService: quoteService,
                      primaryColor: primaryColor,
                      accentColor: accentColor,)),
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
