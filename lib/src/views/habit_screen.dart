import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/habit.dart';

class HabitScreen extends StatefulWidget {
  const HabitScreen({super.key});

  @override
  _HabitScreenState createState() => _HabitScreenState();
}

class _HabitScreenState extends State<HabitScreen> {
  List<Habit> habits = [];
  TextEditingController habitController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadHabits();
  }

  void loadHabits() async {
    log("loading");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? habitList = prefs.getStringList('habits');

    if (habitList != null) {
      setState(() {
        habits = habitList.map((json) => Habit.fromJson(json)).toList();
      });
    }
  }

  void saveHabits() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> habitList = habits.map((habit) => habit.toJson()).toList();
    prefs.setStringList('habits', habitList);
  }

  @override
  Widget build(BuildContext context) {
    return Material(child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Create Habit form
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: habitController,
                decoration: const InputDecoration(labelText: 'Enter Habit Name'),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Create a new habit and add it to the list
                if (habitController.text.isNotEmpty) {
                  Habit newHabit = Habit(name: habitController.text);
                  habits.add(newHabit);
                  habitController.clear();
                  setState(() {}); // Update the UI
                }
              },
              child: const Text('Create Habit'),
            ),
          ],
        ),
        const SizedBox(height: 20),
        // Display list of habits
        Expanded(
          child: ListView.builder(
            itemCount: habits.length,
            itemBuilder: (context, index) {
              return HabitListItem(
                habit: habits[index],
                onCheckboxChanged: (isChecked) {
                  setState(() {
                    habits[index].markCompleted(isChecked);
                    saveHabits();
                  });
                },
              );
            },
          ),
        ),
      ],
    ));
  }
}

class HabitListItem extends StatelessWidget {
  final Habit habit;
  final Function(bool) onCheckboxChanged;

  const HabitListItem({super.key, required this.habit, required this.onCheckboxChanged});

  @override
  Widget build(BuildContext context) {
    String currentDate = DateTime.now().toLocal().toString().split(' ')[0];
    bool isCompleted = habit.isCompleted(currentDate);

    return ListTile(
      title: Text(habit.name),
      subtitle: Text('Streak Length: ${habit.streakLength}'),
      trailing: Checkbox(
        value: isCompleted,
        onChanged: (isChecked) {
          onCheckboxChanged(isChecked ?? false);
        },
      ),
    );
  }
}
