import 'package:devfest_hackathon_2023/main.dart';
import 'package:flutter/material.dart';
import 'package:devfest_hackathon_2023/src/services/quote_service.dart';
import 'package:devfest_hackathon_2023/src/views/habit_list_screen.dart';
import 'package:devfest_hackathon_2023/src/views/quote_list_screen.dart';
import 'package:devfest_hackathon_2023/src/views/self_examination_list_screen.dart';

import 'meditation_screen.dart';

class Hub extends StatelessWidget {
  const Hub({
    Key? key,
    required this.quoteService,
    required this.primaryColor,
    required this.accentColor,
  }) : super(key: key);

  final QuoteService quoteService;
  final Color primaryColor;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hub', style: TextStyle(color: accentColor)),
        backgroundColor: primaryColor,
      ),
      body: Container(
        color: accentColor,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            HubButton(
              onPressed: () {
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
              },
              label: 'QUOTES',
              icon: Icons.format_quote,
              backgroundColor: primaryColor,
              textColor: accentColor,
              description: 'Explore and discover meaningful quotes.',
            ),
            HubButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => HabitListScreen(primaryColor: primaryColor, accentColor: accentColor)),
                );
              },
              label: 'HABITS',
              icon: Icons.star,
              backgroundColor: primaryColor,
              textColor: accentColor,
              description: 'Track and build healthy habits.',
            ),
            HubButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SelfExaminationListScreen(),
                  ),
                );
              },
              label: 'SELF EXAMINATION',
              icon: Icons.check,
              backgroundColor: primaryColor,
              textColor: accentColor,
              description: 'Reflect and evaluate personal growth.',
            ),
            HubButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MeditationScreen(primaryColor: primaryColor, accentColor: accentColor),
                  ),
                );
              },
              label: 'MEDITATION',
              icon: Icons.spa,
              backgroundColor: primaryColor,
              textColor: accentColor,
              description: 'Practice mindfulness and meditation.',
            ),
          ],
        ),
      ),
    );
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
                      style: TextStyle(
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
