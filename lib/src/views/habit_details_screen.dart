import 'package:flutter/material.dart';

import '../models/habit.dart';

class HabitDetailsScreen extends StatefulWidget {
  final Habit habit;

  const HabitDetailsScreen({super.key, required this.habit});

  @override
  State<HabitDetailsScreen> createState() => _HabitDetailsScreenState();
}

class _HabitDetailsScreenState extends State<HabitDetailsScreen> {
  late List<String> pastWeekDates;

  @override
  void initState() {
    super.initState();
    // Generate a list of the past 7 days
    pastWeekDates = generatePastWeekDates();
  }

  List<String> generatePastWeekDates() {
    DateTime currentDate = DateTime.now();
    List<String> pastWeekDates = [];
    for (int i = 0; i < 7; i++) {
      DateTime date = currentDate.subtract(Duration(days: i));
      pastWeekDates.add(date.toLocal().toString().split(' ')[0]);
    }
    return pastWeekDates;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Habit Details'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Habit: ${widget.habit.name}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Streak Length: ${widget.habit.streakLength}',
              style: const TextStyle(fontSize: 16),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Habit completion for the week:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          // Display habit completion status for each day in the week
          Column(
            children: List.generate(pastWeekDates.length, (index) {
              String currentDate = pastWeekDates[index];
              bool isCompleted = widget.habit.isCompleted(currentDate);

              return CheckboxListTile(
                title: Text(currentDate),
                value: isCompleted,
                onChanged: (isChecked) {
                  setState(() {
                    widget.habit.markCompleted(isChecked ?? false);
                    // Update the UI
                    widget.habit.updateStreakLength();
                  });
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}