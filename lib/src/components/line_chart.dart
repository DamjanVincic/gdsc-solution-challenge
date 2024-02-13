import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class LineChartWidget extends StatelessWidget {
  final List<FlSpot> spots;
  final List<String> labels;
  final String xAxisTitle; // Add xAxisTitle
  final String yAxisTitle; // Add yAxisTitle
  final String yAxisUnit; // Add yAxisUnit

  const LineChartWidget({super.key,
    required this.spots,
    required this.labels,
    required this.xAxisTitle,
    required this.yAxisTitle,
    required this.yAxisUnit,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: LineChart(
        LineChartData(
          titlesData: FlTitlesData(
            leftTitles: SideTitles(
              showTitles: true,
              reservedSize: 22,
              margin: 10,
              getTitles: (value) {
                return '${value.toInt()} $yAxisUnit'; // Use yAxisUnit
              },
            ),
            bottomTitles: SideTitles(
              showTitles: true,
              reservedSize: 22,
              margin: 10,
              getTitles: (value) {
                if (value.toInt() >= 0 && value.toInt() < labels.length) {
                  return labels[value.toInt()];
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
          minY: 0,
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              colors: [Colors.blue],
              dotData: FlDotData(show: false),
              belowBarData: BarAreaData(show: false),
            ),
          ],
        ),
      ),
    );
  }
}