import 'package:flutter/material.dart';

import '../models/examination_result.dart';

class SelfExaminationInputScreen extends StatefulWidget {
  final VoidCallback onDataChanged; // Define the callback
  final List<ExaminationResult> existingItems; // Accept the existing items

  const SelfExaminationInputScreen({
    super.key,
    required this.onDataChanged,
    required this.existingItems,
  });

  @override
  State<SelfExaminationInputScreen> createState() => _SelfExaminationInputScreenState();
}

class _SelfExaminationInputScreenState extends State<SelfExaminationInputScreen> {
  double feelingValue = 5.0; // Initial value for the feeling slider
  TextEditingController goalsController = TextEditingController();
  TextEditingController workController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // You may use the existingItems to pre-fill the form if needed
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Evaluate your day'),
      ),
      body: Container(
        width: double.infinity, // Fill the entire width
        color: Colors.black87, // Set background color
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0), // Add left and right padding
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'How are you feeling (1 - worst, 10 - best)?',
                    style: TextStyle(color: Colors.white70, fontSize: 18), // Set text color and size
                  ),
                  Text(
                    '${feelingValue.toInt()}',
                    style: const TextStyle(color: Colors.white70), // Set text color
                  ),
                ],
              ),
              Slider(
                value: feelingValue,
                min: 1,
                max: 10,
                divisions: 9,
                onChanged: (value) {
                  setState(() {
                    feelingValue = value;
                  });
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(10, (index) {
                  return Text(
                    '${index + 1}',
                    style: const TextStyle(color: Colors.white70),
                  );
                }),
              ),
              TextField(
                controller: goalsController,
                style: const TextStyle(color: Colors.white70), // Set text color
                decoration: const InputDecoration(
                  labelText: 'Goals for the following day',
                  labelStyle: TextStyle(color: Colors.white70), // Set label color
                ),
              ),
              TextField(
                controller: workController,
                style: const TextStyle(color: Colors.white70), // Set text color
                decoration: const InputDecoration(
                  labelText: 'What will you achieve with 5% more work every day?',
                  labelStyle: TextStyle(color: Colors.white70), // Set label color
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (validateInputs()) {
                    await saveData();
                    // Notify the list screen that data is saved
                    widget.onDataChanged();
                    Navigator.pop(context); // Return to the previous screen
                  }
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.white70, // Button background color
                  onPrimary: Colors.black87, // Text color
                  minimumSize: const Size(double.infinity, 50), // Set button size
                ),
                child: const Text('Save and Continue', style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> saveData() async {
    // Save data to the existingItems list
    widget.existingItems.add(
      ExaminationResult(
        feeling: feelingValue.toInt(),
        goals: goalsController.text,
        work: workController.text,
        date: DateTime.now(),
      ),
    );
    // You may also save the list to SharedPreferences if needed
  }

  bool validateInputs() {
    return goalsController.text.isNotEmpty && workController.text.isNotEmpty;
  }
}
