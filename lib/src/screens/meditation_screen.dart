import 'dart:async';
import 'package:Actualizator/src/components/bar_chart.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/meditation_data.dart';
import '../repository/meditation_repository.dart';
import '../components/line_chart.dart';
import '../components/pie_chart.dart';

class MeditationScreen extends StatefulWidget {
  final Color primaryColor;
  final Color accentColor;

  const MeditationScreen({
    Key? key,
    required this.primaryColor,
    required this.accentColor,
  }) : super(key: key);

  @override
  State<MeditationScreen> createState() => _MeditationScreenState();
}

class _MeditationScreenState extends State<MeditationScreen> {
  List<MeditationData> meditationData = [];
  final MeditationRepository meditationRepository = MeditationRepository();
  int meditationDuration = 5;
  bool isTimerRunning = false;
  Timer? _timer;
  int secondsLeft = 5 * 60;
  bool showBarChart = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    List<MeditationData> loadedData = await meditationRepository.loadData();
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
    await meditationRepository.saveData(meditationData);
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
    final Color accentColor = widget.accentColor;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meditation'),
        backgroundColor: Colors.redAccent,
      ),
      body: Container(
        color: Colors.white38,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Total Meditated Time: ${formatTotalMeditationTime()}',
                style: const TextStyle(fontSize: 20, color: Colors.black87), // Set text color
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove),
                    color: Colors.black87, // Set icon color
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
                      style: const TextStyle(color: Colors.black87), // Set text color
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
                        hintStyle: TextStyle(color: Colors.black87), // Set hint text color
                      ),
                      controller: TextEditingController(text: meditationDuration.toString()),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    color: Colors.black87, // Set icon color
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
                style: const TextStyle(fontSize: 20, color: Colors.black87),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: startStopTimer,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white38, // Set button background color
                ),
                child: Text(
                  isTimerRunning ? 'Stop' : 'Start',
                  style: TextStyle(color: accentColor),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Meditation Data for the Last 7 Days',
                style: TextStyle(fontSize: 20, color: Colors.black87),
              ),
              const SizedBox(height: 20),
              // Button to toggle between line chart and pie chart
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    showBarChart = !showBarChart;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white38,
                ),
                child: Text(
                  showBarChart ? 'Show Pie Chart' : 'Show Bar Chart',
                  style: TextStyle(color: accentColor),
                ),
              ),
              const SizedBox(height: 20),
              // Conditionally display line chart or pie chart
              showBarChart
                  ? SizedBox(
                height: 300,
                child: BarChartWidget(
                  description: "Seconds Meditating per Day",
                  data: getBarChartData(),
                  labels: const ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
                  xAxisTitle: 'Days',
                  yAxisTitle: 'Duration(seconds)',
                )
              )
                  :Column(
                children: [
                  SizedBox(
                    width: 300,
                    height: 300,
                    child: PieChartWidget(
                        data: generatePieChartData(),
                        legendTitles: generatePieChartLegendTitles()
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel(); // Dispose of the timer to prevent memory leaks
    super.dispose();
  }

  List<String> generatePieChartLegendTitles() {
    Set<String> legendTitles = {};

    for (var entry in meditationData) {
      int duration = entry.durationInSeconds ~/ 60; // Convert seconds to minutes
      legendTitles.add(duration.toString());
    }

    return legendTitles.toList();
  }

  List<PieChartSectionData> generatePieChartData() {
    Map<int, int> durationCountMap = {};

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

    int numberOfSessions = meditationData.length;

    durationCountMap.forEach((duration, count) {
      sections.add(
        PieChartSectionData(
          color: colors[colorIndex++ % colors.length],
          value: count * 100 / numberOfSessions,
          title: '$count sessions\n${duration}m', // Display count and duration in minutes
          radius: 60,
          titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
      );
    });

    return sections;
  }


  List<int> getBarChartData() {
    List<int> durations = List<int>.filled(7, 0);
    for (var entry in meditationData) {
      int day = (DateTime.parse(entry.date).weekday - 1) % 7;
      durations[day] += entry.durationInSeconds;
    }
    return durations;
  }

  int calculateTotalMeditationTime() {
    int totalSeconds = 0;
    for (var entry in meditationData) {
      totalSeconds += entry.durationInSeconds;
    }
    return totalSeconds;
  }

  String formatTotalMeditationTime() {
    int totalSeconds = calculateTotalMeditationTime();
    int hours = totalSeconds ~/ 3600;
    int minutes = (totalSeconds % 3600) ~/ 60;
    int seconds = totalSeconds % 60;

    return '$hours:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}
