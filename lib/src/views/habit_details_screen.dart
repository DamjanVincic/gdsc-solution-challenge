import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/habit.dart';

class HabitDetailsScreen extends StatefulWidget {
  final Habit habit;
  final Color primaryColor;
  final Color accentColor;

  const HabitDetailsScreen({
    Key? key,
    required this.habit,
    required this.primaryColor,
    required this.accentColor,
  }) : super(key: key);

  @override
  State<HabitDetailsScreen> createState() => _HabitDetailsScreenState();
}

class _HabitDetailsScreenState extends State<HabitDetailsScreen> {
  late List<String> pastWeekDates;

  @override
  void initState() {
    super.initState();
    // Generate a list of the past 7 days starting from the 7th day ago
    pastWeekDates = generatePastWeekDates();
  }

  List<String> generatePastWeekDates() {
    DateTime currentDate = DateTime.now();
    DateTime startDate = currentDate.subtract(const Duration(days: 6));

    List<String> pastWeekDates = [];
    for (int i = 0; i < 7; i++) {
      DateTime date = startDate.add(Duration(days: i));
      pastWeekDates.add(date.toLocal().toString().split(' ')[0]);
    }
    return pastWeekDates;
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = widget.primaryColor;
    final accentColor = widget.accentColor;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Habit Details'),
      ),
      body: Container(
        color: accentColor,
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Habit: ${widget.habit.name}',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                Padding(

                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "You are on a ${widget.habit.streakLength} day streak!",
                    style: const TextStyle(fontSize: 24, color: Colors.white),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    "This week's progress:",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                // Display habit completion status for each day in the week using a graph
                Container(
                  color: Colors.white,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    height: 300,
                    child: LineChart(
                      LineChartData(
                        gridData: FlGridData(show: false),
                        titlesData: FlTitlesData(show: false),
                        borderData: FlBorderData(show: false),
                        lineBarsData: [
                          LineChartBarData(
                            spots: List.generate(pastWeekDates.length, (index) {
                              String currentDate = pastWeekDates[index];
                              bool isCompleted =
                              widget.habit.isCompleted(currentDate);

                              return FlSpot(
                                  index.toDouble(), isCompleted ? 1.0 : 0.0);
                            }),
                            isCurved: true,
                            belowBarData: BarAreaData(show: false),
                            colors: [
                              Colors.green
                            ], // Set graph color to accentColor
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // Display a table with habit completion status for each day in the week
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: DataTable(
                    columns: [
                      DataColumn(
                        label: Text(
                          'Date',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Completed',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                    rows: List.generate(pastWeekDates.length, (index) {
                      String currentDate = pastWeekDates[index];
                      bool isCompleted =
                      widget.habit.isCompleted(currentDate);

                      return DataRow(cells: [
                        DataCell(
                          Text(
                            currentDate,
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        DataCell(
                          isCompleted
                              ? Icon(Icons.check, color: Colors.green)
                              : Icon(Icons.close, color: Colors.red),
                        ),
                      ]);
                    }),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
