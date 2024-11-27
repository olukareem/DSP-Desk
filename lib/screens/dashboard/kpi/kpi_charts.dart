import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class KPIsWidget extends StatelessWidget {
  const KPIsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        _buildChartCard('On-Time Performance', LineChart(_sampleLineData())),
        _buildChartCard('Driver Productivity', BarChart(_sampleBarData())),
      ],
    );
  }

  Widget _buildChartCard(String title, Widget chart) {
    return Card(
      elevation: 3,
      margin: EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            SizedBox(height: 200, child: chart),
          ],
        ),
      ),
    );
  }

  LineChartData _sampleLineData() {
    return LineChartData(
      gridData: FlGridData(show: false),
      titlesData: FlTitlesData(show: true),
      borderData: FlBorderData(show: true),
      lineBarsData: [
        LineChartBarData(
          spots: [FlSpot(0, 3), FlSpot(1, 2), FlSpot(2, 5), FlSpot(3, 3.5)],
          isCurved: true,
          color: Colors.blue,
          barWidth: 3,
        ),
      ],
    );
  }

  BarChartData _sampleBarData() {
    return BarChartData(
      titlesData: FlTitlesData(show: true),
      borderData: FlBorderData(show: true),
      barGroups: [
        BarChartGroupData(
          x: 0,
          barRods: [
            BarChartRodData(
              fromY: 0, // Default start from 0
              toY: 8, // The height of the bar
              color: Colors.blue,
            ),
          ],
        ),
        BarChartGroupData(
          x: 1,
          barRods: [
            BarChartRodData(
              fromY: 0, // Default start from 0
              toY: 10, // The height of the bar
              color: Colors.blue,
            ),
          ],
        ),
      ],
    );
  }
}
