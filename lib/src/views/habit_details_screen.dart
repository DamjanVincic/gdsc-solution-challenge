import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/habit.dart';

class HabitDetailsScreen extends StatefulWidget {
  final Habit habit;

  const HabitDetailsScreen({super.key, required this.habit});

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Habit Details'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Habit: ${widget.habit.name}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Streak Length: ${widget.habit.streakLength}',
              style: const TextStyle(fontSize: 16),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Habit completion for the week:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          // Display habit completion status for each day in the week using a graph
          Expanded(
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: false),
                titlesData: FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: List.generate(pastWeekDates.length, (index) {
                      String currentDate = pastWeekDates[index];
                      bool isCompleted = widget.habit.isCompleted(currentDate);

                      return FlSpot(index.toDouble(), isCompleted ? 1.0 : 0.0);
                    }),
                    isCurved: true,
                    belowBarData: BarAreaData(show: false),
                    colors: [Colors.blue],
                  ),
                ],
              ),
            ),
          ),
          // Display a table with habit completion status for each day in the week
          DataTable(
            columns: const [
              DataColumn(label: Text('Date')),
              DataColumn(label: Text('Completed')),
            ],
            rows: List.generate(pastWeekDates.length, (index) {
              String currentDate = pastWeekDates[index];
              bool isCompleted = widget.habit.isCompleted(currentDate);

              return DataRow(cells: [
                DataCell(Text(currentDate)),
                DataCell(Text(isCompleted ? 'Yes' : 'No')),
              ]);
            }),
          ),
        ],
      ),
    );
  }
}
