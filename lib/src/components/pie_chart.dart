import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class PieChartWidget extends StatelessWidget {
  final List<PieChartSectionData> data;
  final List<String> legendTitles; // Add legendTitles

  const PieChartWidget({super.key, required this.data, required this.legendTitles}); // Accept legendTitles

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PieChart(
          PieChartData(
            sections: data,
            sectionsSpace: 0,
            centerSpaceRadius: 40,
            centerSpaceColor: Colors.white70,
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
    );
  }

  List<Widget> generateLegend() {
    List<Widget> legendWidgets = [];
    int colorIndex = 0;

    for (var section in data) {
      legendWidgets.add(
        Row(
          children: [
            Container(
              width: 12,
              height: 12,
              color: section.color,
            ),
            const SizedBox(width: 4),
            Text(
              '${legendTitles[colorIndex]}: ${section.value.toStringAsFixed(1)}%',
              style: const TextStyle(color: Colors.black87),
            ),
            const SizedBox(width: 16), // Adjust spacing as needed
          ],
        ),
      );
      colorIndex++;
    }

    return legendWidgets;
  }
}