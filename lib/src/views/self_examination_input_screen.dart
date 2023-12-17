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
        title: const Text('Input Screen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('How are you feeling?'),
                Text('${feelingValue.toInt()}'),
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
            TextField(
              controller: goalsController,
              decoration: const InputDecoration(labelText: 'Goals for the following day'),
            ),
            TextField(
              controller: workController,
              decoration: const InputDecoration(
                labelText: 'What will you achieve with 5% more work every day?',
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
              child: const Text('Save and Continue'),
            ),
          ],
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
        date: DateTime.now()
      ),
    );
    // You may also save the list to SharedPreferences if needed
  }

  bool validateInputs() {
    return goalsController.text.isNotEmpty && workController.text.isNotEmpty;
  }
}
