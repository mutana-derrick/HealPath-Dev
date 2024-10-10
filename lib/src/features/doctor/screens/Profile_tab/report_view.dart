import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:screenshot/screenshot.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReportView extends StatefulWidget {
  const ReportView({super.key});

  @override
  _ReportViewState createState() => _ReportViewState();
}

class _ReportViewState extends State<ReportView> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final ScreenshotController _hivPrevalenceController = ScreenshotController();
  final ScreenshotController _needleSharingController = ScreenshotController();
  final ScreenshotController _drugPreferenceController = ScreenshotController();
  final ScreenshotController _genderComparisonController =
      ScreenshotController();

  Map<String, dynamic> reportData = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchReportData();
  }

  Future<void> _fetchReportData() async {
    try {
      QuerySnapshot patientsSnapshot =
          await _firestore.collection('patients').get();

      int totalPWID = patientsSnapshot.size;
      int hivPositive = 0;
      int maleCount = 0;
      int femaleCount = 0;
      List<int> ages = [];
      Map<String, int> drugPreference = {};
      int needleSharingLifetime = 0;
      int needleSharingRecent = 0;

      for (var patientDoc in patientsSnapshot.docs) {
        var patientData = patientDoc.data() as Map<String, dynamic>;

        // HIV Status
        if (patientData['hivStatus'] == 'Positive') hivPositive++;

        // Gender
        if (patientData['gender'] == 'Male') {
          maleCount++;
        } else if (patientData['gender'] == 'Female') {
          femaleCount++;
        }

        // Age
        int age = int.tryParse(patientData['age'] ?? '') ?? 0;
        if (age > 0) ages.add(age);

        // Drug Preference
        String drug = patientData['drugOfChoice'] ?? 'Unknown';
        drugPreference[drug] = (drugPreference[drug] ?? 0) + 1;

        // Needle Sharing
        String needleSharing = patientData['needleSharingHistory'] ?? '';
        if (needleSharing == 'In the past' || needleSharing == 'Currently') {
          needleSharingLifetime++;
        }
        if (needleSharing == 'Currently') {
          needleSharingRecent++;
        }
      }

      setState(() {
        reportData = {
          'totalPWID': totalPWID,
          'hivPrevalence': totalPWID > 0
              ? (hivPositive / totalPWID * 100).toStringAsFixed(1)
              : '0.0',
          'medianAge': ages.isNotEmpty
              ? (ages.reduce((a, b) => a + b) / ages.length).round().toString()
              : 'N/A',
          'malePWID': totalPWID > 0
              ? (maleCount / totalPWID * 100).toStringAsFixed(1)
              : '0.0',
          'femalePWID': totalPWID > 0
              ? (femaleCount / totalPWID * 100).toStringAsFixed(1)
              : '0.0',
          'drugPreference': drugPreference,
          'needleSharingLifetime': totalPWID > 0
              ? (needleSharingLifetime / totalPWID * 100).toStringAsFixed(1)
              : '0.0',
          'needleSharingRecent': totalPWID > 0
              ? (needleSharingRecent / totalPWID * 100).toStringAsFixed(1)
              : '0.0',
        };
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching report data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Treatment Report',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              ElevatedButton.icon(
                onPressed: () => _saveReport(context),
                icon: const Icon(Icons.save),
                label: const Text('Save'),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildSummaryCard(),
          const SizedBox(height: 20),
          Screenshot(
            controller: _hivPrevalenceController,
            child: _buildHIVPrevalenceChart(),
          ),
          const SizedBox(height: 20),
          Screenshot(
            controller: _needleSharingController,
            child: _buildNeedleSharingChart(),
          ),
          const SizedBox(height: 20),
          Screenshot(
            controller: _drugPreferenceController,
            child: _buildDrugPreferenceChart(),
          ),
          const SizedBox(height: 20),
          Screenshot(
            controller: _genderComparisonController,
            child: _buildGenderComparisonChart(),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Summary',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            _buildSummaryItem('Total PWID enrolled',
                reportData['totalPWID']?.toString() ?? 'N/A'),
            _buildSummaryItem(
                'HIV Prevalence', '${reportData['hivPrevalence'] ?? 'N/A'}%'),
            _buildSummaryItem(
                'Median Age', '${reportData['medianAge'] ?? 'N/A'} years'),
            _buildSummaryItem(
                'Male PWID', '${reportData['malePWID'] ?? 'N/A'}%'),
            _buildSummaryItem(
                'Female PWID', '${reportData['femalePWID'] ?? 'N/A'}%'),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildHIVPrevalenceChart() {
    double hivPositive =
        double.tryParse(reportData['hivPrevalence'] ?? '0') ?? 0;
    double hivNegative = 100 - hivPositive;

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('HIV Prevalence',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sections: [
                    PieChartSectionData(
                      color: Colors.red,
                      value: hivPositive,
                      title: 'HIV+\n$hivPositive%',
                      radius: 50,
                      titleStyle: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    PieChartSectionData(
                      color: Colors.green,
                      value: hivNegative,
                      title: 'HIV-\n$hivNegative%',
                      radius: 50,
                      titleStyle: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNeedleSharingChart() {
    double lifetimeSharing =
        double.tryParse(reportData['needleSharingLifetime'] ?? '0') ?? 0;
    double recentSharing =
        double.tryParse(reportData['needleSharingRecent'] ?? '0') ?? 0;

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Needle Sharing Practices',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 100,
                  barTouchData: BarTouchData(enabled: false),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          switch (value.toInt()) {
                            case 0:
                              return const Text('Lifetime');
                            case 1:
                              return const Text('Recent');
                            default:
                              return const Text('');
                          }
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true, interval: 20),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: [
                    BarChartGroupData(x: 0, barRods: [
                      BarChartRodData(
                          toY: lifetimeSharing, color: Colors.blue, width: 20),
                    ]),
                    BarChartGroupData(x: 1, barRods: [
                      BarChartRodData(
                          toY: recentSharing, color: Colors.blue, width: 20),
                    ]),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrugPreferenceChart() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Drug Preference',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 100,
                  barTouchData: BarTouchData(enabled: false),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final drugKeys =
                              reportData['drugPreference']?.keys.toList() ?? [];
                          if (value.toInt() < drugKeys.length) {
                            return Text(drugKeys[value.toInt()]);
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true, interval: 20),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: List.generate(
                    reportData['drugPreference']?.keys.length ?? 0,
                    (index) {
                      String drug =
                          reportData['drugPreference']?.keys.elementAt(index) ??
                              'Unknown';
                      int count = reportData['drugPreference']?[drug] ?? 0;
                      double percentage =
                          (count / reportData['totalPWID'] * 100).toDouble();
                      return BarChartGroupData(x: index, barRods: [
                        BarChartRodData(
                            toY: percentage, color: Colors.orange, width: 20),
                      ]);
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGenderComparisonChart() {
    double malePWID = double.tryParse(reportData['malePWID'] ?? '0') ?? 0;
    double femalePWID = double.tryParse(reportData['femalePWID'] ?? '0') ?? 0;

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Gender Comparison',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sections: [
                    PieChartSectionData(
                      color: Colors.blue,
                      value: malePWID,
                      title: 'Male\n$malePWID%',
                      radius: 50,
                      titleStyle: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    PieChartSectionData(
                      color: Colors.pink,
                      value: femalePWID,
                      title: 'Female\n$femalePWID%',
                      radius: 50,
                      titleStyle: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveReport(BuildContext context) async {
    try {
      Directory? tempDir = await getTemporaryDirectory();
      String tempPath = tempDir.path;

      // Generate charts as images
      final hivPrevalenceImage = await _hivPrevalenceController.capture();
      final needleSharingImage = await _needleSharingController.capture();
      final drugPreferenceImage = await _drugPreferenceController.capture();
      final genderComparisonImage = await _genderComparisonController.capture();

      // Create PDF
      final pdf = pw.Document();
      pdf.addPage(
        pw.MultiPage(
          build: (pw.Context context) => [
            pw.Text('Treatment Report',
                style:
                    pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 20),
            pw.Text('Summary',
                style:
                    pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
            _buildPdfSummaryItem('Total PWID enrolled',
                reportData['totalPWID']?.toString() ?? 'N/A'),
            _buildPdfSummaryItem(
                'HIV Prevalence', '${reportData['hivPrevalence'] ?? 'N/A'}%'),
            _buildPdfSummaryItem(
                'Median Age', '${reportData['medianAge'] ?? 'N/A'} years'),
            _buildPdfSummaryItem(
                'Male PWID', '${reportData['malePWID'] ?? 'N/A'}%'),
            _buildPdfSummaryItem(
                'Female PWID', '${reportData['femalePWID'] ?? 'N/A'}%'),
            pw.SizedBox(height: 20),
            if (hivPrevalenceImage != null)
              pw.Image(pw.MemoryImage(hivPrevalenceImage), height: 200),
            pw.SizedBox(height: 20),
            if (needleSharingImage != null)
              pw.Image(pw.MemoryImage(needleSharingImage), height: 200),
            pw.SizedBox(height: 20),
            if (drugPreferenceImage != null)
              pw.Image(pw.MemoryImage(drugPreferenceImage), height: 200),
            pw.SizedBox(height: 20),
            if (genderComparisonImage != null)
              pw.Image(pw.MemoryImage(genderComparisonImage), height: 200),
          ],
        ),
      );

      // Save the PDF file
      final pdfFile = File('$tempPath/treatment_report.pdf');
      await pdfFile.writeAsBytes(await pdf.save());

      // Share the PDF file
      await Share.shareXFiles([XFile(pdfFile.path)],
          text: 'Here is the treatment report.');
    } catch (e) {
      print('Error saving report: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving report: $e')),
      );
    }
  }

  Future<Uint8List?> _captureCard(Widget card) async {
    final controller = ScreenshotController();
    return await controller.captureFromWidget(
      card,
      delay: const Duration(milliseconds: 10),
    );
  }

  pw.Widget _buildPdfSummaryItem(String label, String value) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(label),
        pw.Text(value, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
      ],
    );
  }
}
