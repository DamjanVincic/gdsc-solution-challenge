import 'package:flutter/material.dart';
import 'habit_details_screen.dart';
import '../models/habit.dart';
import '../repository/habit_repository.dart';

class HabitListScreen extends StatefulWidget {
  final Color primaryColor;
  final Color accentColor;

  const HabitListScreen({
    Key? key,
    required this.primaryColor,
    required this.accentColor,
  }) : super(key: key);

  @override
  State<HabitListScreen> createState() => _HabitListScreenState();
}

class _HabitListScreenState extends State<HabitListScreen> {
  List<Habit> habits = [];
  final HabitRepository habitRepository = HabitRepository();
  TextEditingController habitController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    List<Habit> loadedData = await habitRepository.loadData();
    setState(() {
      habits = loadedData;
    });
  }

  Future<void> saveData() async {
    await habitRepository.saveData(habits);
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = widget.primaryColor;
    final Color accentColor = widget.accentColor;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent,

        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Text("Habits"),
        ),

      ),
      body: Container(
          color: Colors.white38,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),

                const SizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
                    itemCount: habits.length,
                    itemBuilder: (context, index) {
                      return HabitCard(
                        habit: habits[index],
                        onSaveCallback: () {
                          saveData();
                          setState(() {});
                        },
                        primaryColor: primaryColor,
                        accentColor: accentColor,
                      );
                    },
                  ),
                ),
              ],
            ),
          )),
      bottomNavigationBar: BottomAppBar(
        //hasNotch: true,
        color: Colors.lightBlue,
        child: new Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,

        ),
      ),
      floatingActionButton: FloatingActionButton.large(

        onPressed: () {
          _showCreateHabitDialog(context);
        },
        backgroundColor: Colors.lightBlue,
        child: const Icon(Icons.add),


      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Future<void> _showCreateHabitDialog(BuildContext context) async {
    TextEditingController habitController = TextEditingController();

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Create Habit"),
          content: TextField(
            controller: habitController,
            decoration: const InputDecoration(
              labelText: 'Enter Habit Name',
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                // Create a new habit and add it to the list
                if (habitController.text.isNotEmpty) {
                  Habit newHabit = Habit(name: habitController.text);
                  habits.add(newHabit);
                  habitController.clear();
                  saveData();
                  setState(() {}); // Update the UI
                }
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text("Confirm"),
            ),
          ],
        );
      },
    );
  }
}

class HabitCard extends StatelessWidget {
  final Habit habit;
  final VoidCallback onSaveCallback;
  final Color primaryColor;
  final Color accentColor;

  const HabitCard({
    Key? key,
    required this.habit,
    required this.onSaveCallback,
    required this.primaryColor,
    required this.accentColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get the current date
    String currentDate = DateTime.now().toLocal().toString().split(' ')[0];

    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      color: Colors.lightBlueAccent,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HabitDetailsScreen(
                  habit: habit,
                  primaryColor: primaryColor,
                  accentColor: accentColor),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(
                Icons.star,
                size: 36.0,
                color: habit.isCompleted(currentDate)
                    ? Colors.amber
                    : Colors.black, // Set the icon color
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      habit.name,
                      style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: accentColor),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      'Streak Length: ${habit.streakLength}',
                      style: TextStyle(fontSize: 14.0, color: accentColor),
                    ),
                    Checkbox(
                      onChanged: habit.isCompleted(currentDate)
                          ? null
                          : (bool? isChecked) {
                              if (isChecked != null) {
                                habit.markCompleted(isChecked);
                                onSaveCallback();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(isChecked
                                        ? 'Habit marked as completed!'
                                        : 'Habit marked as not completed.'),
                                  ),
                                );
                              }
                            },
                      value: habit.isCompleted(currentDate),
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
