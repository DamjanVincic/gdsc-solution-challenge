import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/habit.dart';
import 'habit_details_screen.dart';

class HabitListScreen extends StatefulWidget {
  const HabitListScreen({super.key});

  @override
  State<HabitListScreen> createState() => _HabitListScreenState();
}

class _HabitListScreenState extends State<HabitListScreen> {
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
    return Material(
      child: Column(
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
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class HabitListItem extends StatelessWidget {
  final Habit habit;

  const HabitListItem({Key? key, required this.habit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(habit.name),
      subtitle: Text('Streak Length: ${habit.streakLength}'),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HabitDetailsScreen(habit: habit),
          ),
        );
      },
    );
  }
}
