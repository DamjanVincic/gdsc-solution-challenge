import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BarChartWidget extends StatelessWidget {
  final String description;
  final String xAxisTitle;
  final String yAxisTitle;
  final List<String> labels;
  final List<int> data;

  const BarChartWidget({
    Key? key,
    required this.description,
    required this.data,
    required this.labels,
    required this.xAxisTitle,
    required this.yAxisTitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Padding(
      padding: const EdgeInsets.only(left: 16.0, top: 8.0),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
          Text(
              description,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
          ),
            const SizedBox(
              height: 16.0, // Add vertical space between Text and BarChart
            ),
      SizedBox(
        height: 300,
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceAround,
            maxY: data.reduce((value, element) => value > element ? value : element).toDouble() + 5,
            barGroups: List.generate(
              labels.length,
                  (index) => BarChartGroupData(
                x: index,
                barsSpace: 12,
                barRods: [
                  BarChartRodData(
                    y: data[index].toDouble(),
                    colors: [Colors.green, Colors.orange, Colors.red],
                  ),
                ],
              ),
            ),
            titlesData: FlTitlesData(
              topTitles: SideTitles(showTitles: false),
              leftTitles: SideTitles(
                showTitles: false,
                getTextStyles: (BuildContext context, double value) {
                  return const TextStyle(color: Colors.black, fontWeight: FontWeight.bold);
                },
              ),
              bottomTitles: SideTitles(
                showTitles: true,
                getTextStyles: (BuildContext context, double value) {
                  // Ensure the index is within the labels list
                  int index = value.toInt();
                  if (index >= 0 && index < labels.length) {
                    return const TextStyle(color: Colors.black, fontWeight: FontWeight.bold);
                  }
                  return const TextStyle(color: Colors.black, fontWeight: FontWeight.bold);
                },
                getTitles: (double value) {
                  // Ensure the index is within the labels list
                  int index = value.toInt();
                  if (index >= 0 && index < labels.length) {
                    return labels[index];
                  }
                  return '';
                },
              ),
            ),
            borderData: FlBorderData(
              show: true,
              border: Border.all(
                color: const Color(0xff37434d),
                width: 1,
              ),
            ),
          ),
        ),
      )
      ]
    )
    )
    );
  }
}

