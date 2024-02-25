import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share/share.dart';
import '../components/bar_chart.dart';
import '../components/pie_chart.dart';
import '../models/examination_result.dart';
import '../repository/self_examination_repository.dart';
import 'self_examination_input_screen.dart';

class SelfExaminationListScreen extends StatefulWidget {
  const SelfExaminationListScreen({super.key});

  @override
  State<SelfExaminationListScreen> createState() =>
      _SelfExaminationListScreenState();
}

class _SelfExaminationListScreenState extends State<SelfExaminationListScreen> {
  List<ExaminationResult> items = [];
  final ExaminationRepository examinationRepository = ExaminationRepository();
  bool showBarChart = true; // Track the selected chart type

  @override
  void initState() {
    super.initState();
    loadData();
  }

  List<String> generatedXLabels() {
    var days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    var index = DateTime.now().subtract(const Duration(days: 5)).weekday;
    List<String> labels = [];
    for (var i = 0; i < 7; i++) {
      labels.add(days[(index + i) % 7]);
    }
    return labels;
  }

  Future<void> loadData() async {
    List<ExaminationResult> loadedData = await examinationRepository.loadData();
    setState(() {
      items = loadedData;
    });
  }

  Future<void> saveData() async {
    await examinationRepository.saveData(items);
  }

  void showChartDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Feeling Over the Past 7 Days'),
            content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Pie Chart'),
                          Switch(
                            value: showBarChart,
                            onChanged: (value) {
                              setState(() {
                                showBarChart = value;
                              });
                            },
                          ),
                          const Text('Bar Chart'),
                        ],
                      ),
                      SizedBox(
                        height: 300,
                        child: showBarChart
                            ? BarChartWidget(
                                description: "Number of Goals Based on Feeling",
                                data: getBarChartData(),
                                labels: const ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'],
                                xAxisTitle: 'Feeling',
                                yAxisTitle: 'Num Examinations',
                              )
                            : PieChartWidget(
                                data: generatePieChartData(),
                                legendTitles: generatePieChartLegendTitles(),
                              ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Self-evaluation'),
        backgroundColor: Colors.greenAccent,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    // Pass the list to the input screen
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SelfExaminationInputScreen(
                          onDataChanged: saveData,
                          existingItems: items,
                        ),
                      ),
                    );

                    // Reload the data after returning from the input screen
                    await loadData();
                    setState(() {});

                    // Save the updated list to shared preferences
                    await saveData();
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 32),
                  ),
                  child: const Text(
                    "Evaluate today's feelings",
                    style: TextStyle(fontSize: 15, color: Colors.black87),
                  ),
                ),
                ElevatedButton(
                  onPressed: showChartDialog,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 32),
                  ),
                  child: const Text(
                    'Show chart',
                    style: TextStyle(fontSize: 15, color: Colors.black87),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                color: Colors.white38,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      const Text(
                        'Past self-evaluations: ',
                        style: TextStyle(color: Colors.white70, fontSize: 24),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.675,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: items.length,
                          itemBuilder: (context, index) {
                            final examinationItem = items[index];
                            return Card(
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              color: Colors.greenAccent,
                              child: ListTile(
                                title: Text(
                                  'Feeling: ${examinationItem.feeling}/10',
                                  style: const TextStyle(color: Colors.black87),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Goal: ${examinationItem.goals}',
                                      style: const TextStyle(color: Colors.black87),
                                    ),
                                    Text(
                                      'Work-related achievement: ${examinationItem.work}',
                                      style: const TextStyle(color: Colors.black87),
                                    ),
                                    Text(
                                      'Date: ${examinationItem.date}',
                                      style: const TextStyle(color: Colors.black87),
                                    ),
                                  ],
                                ),
                                trailing: IconButton(
                                  icon: const Icon(Icons.share, color: Colors.black87),
                                  onPressed: () => shareItem(examinationItem),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      )
    );
  }

  List<int> getBarChartData() {
    List<int> examinations = List<int>.filled(10, 0);
    for(var entry in items) {
      int index = entry.feeling;
      examinations[index] += 1;
    }
    return examinations;
  }

  List<String> generatePieChartLegendTitles() {
    return [
      'Very Sad',
      'Sad',
      'Somewhat Sad',
      'Neutral',
      'Somewhat Happy',
      'Happy',
      'Very Happy',
      'Joyful',
      'Ecstatic',
      'Blissful'
    ];
  }

  List<FlSpot> generateLineChartSpots() {
    List<FlSpot> spotList = [];
    DateTime now = DateTime.now();

    for (int i = 0; i < items.length; i++) {
      DateTime date = items[i].date;
      if (now.difference(date).inDays <= 7) {
        double xValue = date.millisecondsSinceEpoch.toDouble();
        double yValue = items[i].feeling.toDouble();
        spotList.add(FlSpot(xValue, yValue));
      }
    }
    return spotList;
  }

  List<PieChartSectionData> generatePieChartData() {
    Map<int, double> percentagesMap = {};

    for (ExaminationResult result in items) {
      int feeling = result.feeling;
      percentagesMap[feeling] = (percentagesMap[feeling] ?? 0) + 1;
    }

    // Convert the map into PieChart data
    List<PieChartSectionData> pieChartData = [];
    percentagesMap.forEach((feeling, count) {
      pieChartData.add(
        PieChartSectionData(
          color: Colors.primaries[feeling % Colors.primaries.length],
          value: count / items.length * 100,
          title: '$feeling',
          titleStyle: const TextStyle(fontSize: 10),
        ),
      );
    });

    return pieChartData;
  }

  Future<void> shareItem(ExaminationResult item) async {
    // Create a custom message with placeholders for item details
    String defaultShareMessage =
        "Hey, I want you to know that I am feeling ${item.feeling}/10, my goal for tomorrow is ${item.goals}, and I will achieve ${item.work} with 5% more work every day.\nThank you for caring for me.";

    // Show a dialog to allow the user to edit the message
    TextEditingController messageController =
        TextEditingController(text: defaultShareMessage);
    bool? userConfirmed = await showDialog(
      context: context,
      barrierDismissible: false,
      // Set to false to prevent dismissal by tapping outside
      builder: (context) => AlertDialog(
        title: const Text('Customize Share Message'),
        content: TextField(
          controller: messageController,
          maxLines: 3,
          decoration: const InputDecoration(
            hintText: 'Enter your custom message',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );

    // Check if userConfirmed is null and assign false in that case
    userConfirmed ??= false;

    if (userConfirmed == true) {
      // Get the final edited message
      String finalMessage = messageController.text;

      if (kIsWeb) {
        // Use the Clipboard API for web
        await Clipboard.setData(ClipboardData(text: finalMessage));
      } else {
        // Use the Share API for mobile platforms
        try {
          await Share.share(finalMessage);
        } catch (e) {
          // Share is not implemented, fallback to Clipboard
          await Clipboard.setData(ClipboardData(text: finalMessage));
        }
      }
    }
  }
}
