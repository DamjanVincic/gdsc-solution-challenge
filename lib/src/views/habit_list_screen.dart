import 'package:flutter/material.dart';
import 'habit_details_screen.dart';
import '../models/habit.dart';
import '../utils/habit_data_handler.dart';

class HabitListScreen extends StatefulWidget {
  const HabitListScreen({super.key});

  @override
  State<HabitListScreen> createState() => _HabitListScreenState();
}

class _HabitListScreenState extends State<HabitListScreen> {
  List<Habit> habits = [];
  final HabitDataHandler dataHandler = HabitDataHandler();
  TextEditingController habitController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    List<Habit> loadedData = await dataHandler.loadData();
    setState(() {
      habits = loadedData;
    });
  }

  Future<void> saveData() async {
    await dataHandler.saveData(habits);
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
                  onSaveCallback: () {
                    saveData();
                    // Update the state of the parent widget
                    setState(() {});
                  },
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
  final VoidCallback onSaveCallback;

  const HabitListItem({Key? key, required this.habit, required this.onSaveCallback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get the current date
    String currentDate = DateTime.now().toLocal().toString().split(' ')[0];

    return ListTile(
      title: Text(habit.name),
      subtitle: Text('Streak Length: ${habit.streakLength}'),
      trailing: Checkbox(
        // Enable the checkbox only if it's not completed for today
        onChanged: habit.isCompleted(currentDate) ? null : (bool? isChecked) {
          // Mark the habit as completed if the checkbox is checked
          if (isChecked != null) {
            habit.markCompleted(isChecked);
            // Save habits to SharedPreferences or update your state management as needed
            onSaveCallback();
            // Update the UI
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(isChecked ? 'Habit marked as completed!' : 'Habit marked as not completed.'),
              ),
            );
          }
        },
        // Set the checkbox state based on whether the habit is completed for today
        value: habit.isCompleted(currentDate),
      ),
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
