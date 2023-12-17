import 'dart:async';
import 'package:flutter/material.dart';
import '../models/meditation_data.dart';
import '../utils/meditation_data_handler.dart';
import 'package:fl_chart/fl_chart.dart';

class MeditationScreen extends StatefulWidget {
  const MeditationScreen({Key? key}) : super(key: key);

  @override
  State<MeditationScreen> createState() => _MeditationScreenState();
}

class _MeditationScreenState extends State<MeditationScreen> {
  List<MeditationData> meditationData = [];
  final MeditationDataHandler dataHandler = MeditationDataHandler();
  int meditationDuration = 5;
  bool isTimerRunning = false;
  Timer? _timer;
  int secondsLeft = 5 * 60;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    List<MeditationData> loadedData = await dataHandler.loadData();
    setState(() {
      DateTime currentDate = DateTime.now();

      // Filter data for the past 7 days
      meditationData = loadedData.where((data) {
        DateTime dataDate = DateTime.parse(data.date);
        return currentDate.difference(dataDate).inDays <= 6;
      }).toList();
    });
  }

  Future<void> saveData() async {
    await dataHandler.saveData(meditationData);
  }

  void startStopTimer() {
    if (isTimerRunning) {
      // Stop the timer
      _timer?.cancel();

      int actualDuration = meditationDuration * 60 - secondsLeft;
      MeditationData newMeditationData = MeditationData(
        durationInSeconds: actualDuration,
        date: DateTime.now().toString(),
      );

      // Add the new data to the list
      meditationData.add(newMeditationData);

      // Save data when the timer stops
      saveData();

      setState(() {
        isTimerRunning = false;
        secondsLeft = 0; // Reset remaining seconds to 0
      });
    } else {
      // Start the timer
      setState(() {
        isTimerRunning = true;
        secondsLeft = meditationDuration * 60 - 1; // Set the initial value correctly
      });

      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (secondsLeft <= 0) {
          // Timer finished
          timer.cancel();

          // Create a new instance of MeditationData with the actual meditation duration
          MeditationData newMeditationData = MeditationData(
            durationInSeconds: meditationDuration * 60, // Store duration in seconds
            date: DateTime.now().toString(), // Use the current date and time
          );

          // Add the new data to the list
          meditationData.add(newMeditationData);

          // Save data when the timer finishes
          saveData();

          setState(() {
            isTimerRunning = false;
            secondsLeft = 0; // Reset remaining seconds to 0
          });
        } else {
          setState(() {
            secondsLeft--;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meditation Timer'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Total Meditated Time: ${_formatTotalMeditationTime()}',
              style: const TextStyle(fontSize: 20),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: () {
                    setState(() {
                      if (meditationDuration > 1) {
                        meditationDuration--;
                        // Update the displayed time when duration changes
                        secondsLeft = meditationDuration * 60;
                      }
                    });
                  },
                ),
                SizedBox(
                  width: 50,
                  child: TextFormField(
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      int newValue = int.tryParse(value) ?? 0;
                      setState(() {
                        // Ensure the duration is not negative
                        meditationDuration = newValue >= 0 ? newValue : 0;
                        // Update the displayed time when duration changes
                        secondsLeft = meditationDuration * 60;
                      });
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    controller: TextEditingController(text: meditationDuration.toString()),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    setState(() {
                      meditationDuration++;
                      // Update the displayed time when duration changes
                      secondsLeft = meditationDuration * 60;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              'Time Remaining: ${secondsLeft ~/ 60}m ${secondsLeft % 60}s',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: startStopTimer,
              child: Text(isTimerRunning ? 'Stop' : 'Start'),
            ),
            const SizedBox(height: 20),
            const Text(
              'Meditation Data for the Last 7 Days',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: generateLegend(),
                ),
                SizedBox(
                  width: 300,
                  height: 300,
                  child: PieChart(
                    PieChartData(
                      sections: _generatePieChartData(),
                      sectionsSpace: 0,
                      centerSpaceRadius: 40,
                      startDegreeOffset: -90,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel(); // Dispose of the timer to prevent memory leaks
    super.dispose();
  }

  List<PieChartSectionData> _generatePieChartData() {
    Map<int, double> durationCountMap = {};

    for (var entry in meditationData) {
      int duration = entry.durationInSeconds ~/ 60; // Convert seconds to minutes
      durationCountMap[duration] = (durationCountMap[duration] ?? 0) + 1;
    }

    List<PieChartSectionData> sections = [];
    int colorIndex = 0;
    List<Color> colors = [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.yellow,
      Colors.orange,
      Colors.purple,
      Colors.teal,
    ];

    durationCountMap.forEach((duration, count) {
      sections.add(
        PieChartSectionData(
          color: colors[colorIndex++ % colors.length],
          value: count.toDouble(),
          title: '$count sessions\n${duration}m', // Display count and duration in minutes
          radius: 60,
          titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      );
    });

    return sections;
  }


  List<Widget> generateLegend() {
    List<Widget> legendWidgets = [];
    int colorIndex = 0;
    List<Color> colors = [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.yellow,
      Colors.orange,
      Colors.purple,
      Colors.teal,
    ];

    Map<int, double> durationCountMap = {};

    for (var entry in meditationData) {
      int duration = entry.durationInSeconds ~/ 60; // Convert seconds to minutes
      durationCountMap[duration] = (durationCountMap[duration] ?? 0) + 1;
    }

    durationCountMap.forEach((duration, count) {
      legendWidgets.add(
          Row(
            children: [
              Container(
                width: 12,
                height: 12,
                color: colors[colorIndex % colors.length],
              ),
              const SizedBox(width: 4),
              Text('$duration min'),
              const SizedBox(width: 16), // Adjust spacing as needed
            ],
          )
      );
    });

    return legendWidgets;
  }

  int _calculateTotalMeditationTime() {
    int totalSeconds = 0;
    for (var entry in meditationData) {
      totalSeconds += entry.durationInSeconds;
    }
    return totalSeconds;
  }

  String _formatTotalMeditationTime() {
    int totalSeconds = _calculateTotalMeditationTime();
    int hours = totalSeconds ~/ 3600;
    int minutes = (totalSeconds % 3600) ~/ 60;
    int seconds = totalSeconds % 60;

    return '$hours:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}
