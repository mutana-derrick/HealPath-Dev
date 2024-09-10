// lib/tabs/patient_progress_tab.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';

class PatientProgressTab extends StatelessWidget {
  const PatientProgressTab({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PatientProgressController>(
      init: PatientProgressController(),
      builder: (controller) {
        return Column(
          children: [
            Expanded(
              child: LineChart(
                LineChartData(
                  gridData: const FlGridData(show: false),
                  titlesData: const FlTitlesData(show: false),
                  borderData: FlBorderData(show: true),
                  minX: 0,
                  maxX: 7,
                  minY: 0,
                  maxY: 10,
                  lineBarsData: [
                    LineChartBarData(
                      spots: controller.progressData,
                      isCurved: true,
                      color: Colors.blue,
                      barWidth: 3,
                      dotData: const FlDotData(show: false),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: controller.addProgressEntry,
                child: const Text('Log Today\'s Progress'),
              ),
            ),
          ],
        );
      },
    );
  }
}

class PatientProgressController extends GetxController {
  List<FlSpot> progressData = const [
    FlSpot(0, 5),
    FlSpot(1, 6),
    FlSpot(2, 4),
    FlSpot(3, 7),
    FlSpot(4, 6),
    FlSpot(5, 8),
    FlSpot(6, 7),
  ];

  void addProgressEntry() {
    // In a real app, you'd probably show a dialog to input the progress value
    double newValue =
        (progressData.last.y + 1) % 10; // Simple increment for demo
    progressData.add(FlSpot(progressData.length.toDouble(), newValue));
    if (progressData.length > 7) {
      progressData.removeAt(0);
    }
    update();
  }
}
