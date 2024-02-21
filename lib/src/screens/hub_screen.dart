import 'package:Actualizator/src/screens/habit_list_screen.dart';
import 'package:Actualizator/src/screens/quote_list_screen.dart';
import 'package:Actualizator/src/screens/self_examination_list_screen.dart';
import 'package:Actualizator/src/services/quote_service.dart';
import 'package:flutter/material.dart';

import '../services/self_examination_service.dart';
import 'gratitude_journal_screen.dart';
import 'meditation_screen.dart';

class HubScreen extends StatelessWidget {
  const HubScreen({
    Key? key,
    required this.quoteService,
    required this.selfExaminationService,
    required this.primaryColor,
    required this.accentColor,
  }) : super(key: key);

  final SelfExaminationService selfExaminationService;
  final QuoteService quoteService;
  final Color primaryColor;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Padding(
            padding: EdgeInsets.only(top: 35.0),
            child: Center(
                child: Text(
                  'Mental Hub',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 30,
                  ),
                ))),
        backgroundColor: primaryColor,
      ),
      body: Container(
        color: primaryColor,
        child: GridView.count(
          scrollDirection: Axis.horizontal,
          crossAxisCount: 1,
          padding: const EdgeInsets.fromLTRB(20, 150, 20, 300),
          children: [
            HubButton(
              onPressed: () => _navigateToQuoteListScreen(context),
              label: 'QUOTES',
              icon: Icons.format_quote,
              backgroundColor: Colors.purpleAccent.shade100,
              textColor: accentColor,
              description: 'Explore and discover meaningful quotes.',
            ),
            HubButton(
              onPressed: () => _navigateToHabitListScreen(context),
              label: 'HABITS',
              icon: Icons.star,
              backgroundColor: Colors.lightBlueAccent,
              textColor: accentColor,
              description: 'Track and build healthy habits.',
            ),
            HubButton(
              onPressed: () => _navigateToEvaluationScreen(context),
              label: 'SELF EVALUATION',
              icon: Icons.check,
              backgroundColor: Colors.greenAccent,
              textColor: accentColor,
              description: 'Reflect and evaluate personal growth.',
            ),
            HubButton(
              onPressed: () => _navigateToMeditationScreen(context),
              label: 'MEDITATION',
              icon: Icons.spa,
              backgroundColor: Colors.redAccent,
              textColor: accentColor,
              description: 'Practice mindfulness and meditation.',
            ),
            HubButton(
              onPressed: () => _navigateToGratitudeJournalScreen(context),
              label: 'GRATITUDE JOURNAL',
              icon: Icons.book,
              backgroundColor: Colors.yellowAccent,
              textColor: accentColor,
              description: 'Write & read about things you are grateful for.',
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToQuoteListScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QuoteListScreen(
          quoteService: quoteService,
          primaryColor: primaryColor,
          accentColor: accentColor,
        ),
      ),
    );
  }

  void _navigateToHabitListScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => HabitListScreen(
              primaryColor: Colors.lightBlueAccent, accentColor: accentColor)),
    );
  }

  void _navigateToEvaluationScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SelfExaminationListScreen(),
      ),
    );
  }

  void _navigateToMeditationScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MeditationScreen(
            primaryColor: primaryColor, accentColor: accentColor),
      ),
    );
  }

  void _navigateToGratitudeJournalScreen(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const GratitudeJournalScreen()));
  }
}

class HubButton extends StatelessWidget {
  const HubButton({
    Key? key,
    required this.onPressed,
    required this.label,
    required this.icon,
    required this.backgroundColor,
    required this.textColor,
    required this.description,
  }) : super(key: key);

  final VoidCallback onPressed;
  final String label;
  final IconData icon;
  final Color backgroundColor;
  final Color textColor;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      color: backgroundColor,
      child: InkWell(
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(
                icon,
                size: 36.0,
                color: textColor,
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 18.0,
                        color: textColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      description,
                      style: const TextStyle(
                        fontSize: 14.0,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}