import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share/share.dart';
import '../models/examination_result.dart';
import '../utils/self_examination_data_handler.dart';
import 'self_examination_input_screen.dart';

class SelfExaminationListScreen extends StatefulWidget {
  const SelfExaminationListScreen({super.key});

  @override
  State<SelfExaminationListScreen> createState() => _SelfExaminationListScreenState();
}

class _SelfExaminationListScreenState extends State<SelfExaminationListScreen> {
  List<ExaminationResult> items = [];
  final ExaminationDataHandler dataHandler = ExaminationDataHandler();
  bool showLineChart = true; // Track the selected chart type

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    List<ExaminationResult> loadedData = await dataHandler.loadData();
    setState(() {
      items = loadedData;
    });
  }

  Future<void> saveData() async {
    await dataHandler.saveData(items);
  }

  List<FlSpot> generateSpotList() {
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

  Map<int, double> generatePieChartData() {
    Map<int, double> percentagesMap = {};

    for (ExaminationResult result in items) {
      int feeling = result.feeling;
      percentagesMap[feeling] = (percentagesMap[feeling] ?? 0) + 1;
    }

    // Convert the map into PieChart data
    Map<int, double> pieChartData = {};
    percentagesMap.forEach((feeling, count) {
      pieChartData[feeling] = count / items.length * 100;
    });

    return pieChartData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SelfExamination Screen'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Stored Items:'),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.3,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text('F: ${items[index].feeling}'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('G: ${items[index].goals}'),
                          Text('W: ${items[index].work}'),
                          Text('D: ${items[index].date}'),
                        ],
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.share),
                        onPressed: () => _shareItem(items[index]),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
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
                child: const Text('Add New Item'),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Show Line Chart'),
                  Switch(
                    value: showLineChart,
                    onChanged: (value) {
                      setState(() {
                        showLineChart = value;
                      });
                    },
                  ),
                  const Text('Show Pie Chart'),
                ],
              ),
              const SizedBox(height: 20),
              const Text('Feeling Over the Past 7 Days'),
              SizedBox(
                height: 300,
                child: showLineChart ? LineChart(
                  LineChartData(
                    titlesData: FlTitlesData(
                      leftTitles: SideTitles(showTitles: true),
                      bottomTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 22,
                        margin: 10,
                      ),
                    ),
                    borderData: FlBorderData(
                      show: true,
                      border: Border.all(
                        color: const Color(0xff37434d),
                        width: 1,
                      ),
                    ),
                    minX: DateTime.now().subtract(const Duration(days: 7)).millisecondsSinceEpoch.toDouble(),
                    maxX: DateTime.now().millisecondsSinceEpoch.toDouble(),
                    minY: 0,
                    maxY: 10,
                    lineBarsData: [
                      LineChartBarData(
                        spots: generateSpotList(),
                        isCurved: true,
                        colors: [Colors.blue],
                        dotData: FlDotData(show: false),
                        belowBarData: BarAreaData(show: false),
                      ),
                    ],
                  ),
                ) : Stack(
                  children: [
                    PieChart(
                      PieChartData(
                        sections: List<PieChartSectionData>.generate(
                          generatePieChartData().length,
                              (index) {
                            int feeling = generatePieChartData().keys.elementAt(index);
                            double percentage = generatePieChartData()[feeling]!;
                            int count = (percentage * items.length / 100).round();
                            return PieChartSectionData(
                              color: Colors.primaries[index % Colors.primaries.length],
                              value: percentage,
                              radius: percentage / 2,
                              title: '$feeling: $count (${percentage.toStringAsFixed(1)}%)',
                              titleStyle: const TextStyle(fontSize: 10),
                            );
                          },
                        ),
                        sectionsSpace: 0,
                        centerSpaceRadius: 40,
                        centerSpaceColor: Colors.white,
                      ),
                    ),
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: generateLegend(),
                      ),
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

  List<Widget> generateLegend() {
    List<Widget> legendWidgets = [];
    for (int i = 0; i < generatePieChartData().length; i++) {
      int feeling = generatePieChartData().keys.elementAt(i);
      Color color = Colors.primaries[i % Colors.primaries.length];
      legendWidgets.add(
        Row(
          children: [
            Container(
              width: 12,
              height: 12,
              color: color,
            ),
            const SizedBox(width: 4),
            Text('$feeling'),
          ],
        ),
      );
    }
    return legendWidgets;
  }

  Future<void> _shareItem(ExaminationResult item) async {
    // Create a custom message with placeholders for item details
    String defaultShareMessage = "Hey, I want you to know that I am feeling ${item.feeling}/10, my goal for tomorrow is ${item.goals}, and I will achieve ${item.work} with 5% more work every day.\nThank you for caring for me.";

    // Show a dialog to allow the user to edit the message
    TextEditingController messageController =
    TextEditingController(text: defaultShareMessage);
    bool? userConfirmed = await showDialog(
      context: context,
      barrierDismissible: false, // Set to false to prevent dismissal by tapping outside
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
