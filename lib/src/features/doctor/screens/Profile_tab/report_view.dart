import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:screenshot/screenshot.dart';
import 'dart:io';
import 'dart:typed_data';

class ReportView extends StatelessWidget {
  final ScreenshotController _hivPrevalenceController = ScreenshotController();
  final ScreenshotController _needleSharingController = ScreenshotController();
  final ScreenshotController _drugPreferenceController = ScreenshotController();
  final ScreenshotController _genderComparisonController =
      ScreenshotController();

  ReportView({super.key});

  @override
  Widget build(BuildContext context) {
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
            controller: _hivPrevalenceController, // Unique controller
            child: _buildHIVPrevalenceChart(),
          ),
          const SizedBox(height: 20),
          Screenshot(
            controller: _needleSharingController, // Unique controller
            child: _buildNeedleSharingChart(),
          ),
          const SizedBox(height: 20),
          Screenshot(
            controller: _drugPreferenceController, // Unique controller
            child: _buildDrugPreferenceChart(),
          ),
          const SizedBox(height: 20),
          Screenshot(
            controller: _genderComparisonController, // Unique controller
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
            _buildSummaryItem('Total PWID enrolled', '307'),
            _buildSummaryItem('HIV Prevalence', '9.5%'),
            _buildSummaryItem('Median Age', '28 years'),
            _buildSummaryItem('Male PWID', '81%'),
            _buildSummaryItem('Female PWID', '19%'),
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
                      value: 9.5,
                      title: 'HIV+\n9.5%',
                      radius: 50,
                      titleStyle: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    PieChartSectionData(
                      color: Colors.green,
                      value: 90.5,
                      title: 'HIV-\n90.5%',
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
                              return const Text('Past 6 months');
                            default:
                              return const Text('');
                          }
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: [
                    BarChartGroupData(
                      x: 0,
                      barRods: [BarChartRodData(toY: 91, color: Colors.blue)],
                    ),
                    BarChartGroupData(
                      x: 1,
                      barRods: [BarChartRodData(toY: 31, color: Colors.blue)],
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

  Widget _buildDrugPreferenceChart() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Drug Preference (Past 6 months)',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sections: [
                    PieChartSectionData(
                      color: Colors.red,
                      value: 70,
                      title: 'Heroin\n70%',
                      radius: 60,
                      titleStyle: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    PieChartSectionData(
                      color: Colors.blue,
                      value: 30,
                      title: 'Canabis\n30%',
                      radius: 60,
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

  Widget _buildGenderComparisonChart() {
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
                              return const Text('Recent IDU');
                            case 1:
                              return const Text('Selling sex');
                            case 2:
                              return const Text('Needle');
                            default:
                              return const Text('');
                          }
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: [
                    BarChartGroupData(
                      x: 0,
                      barRods: [
                        BarChartRodData(toY: 30, color: Colors.blue),
                        BarChartRodData(toY: 70, color: Colors.pink),
                      ],
                    ),
                    BarChartGroupData(
                      x: 1,
                      barRods: [
                        BarChartRodData(toY: 20, color: Colors.blue),
                        BarChartRodData(toY: 80, color: Colors.pink),
                      ],
                    ),
                    BarChartGroupData(
                      x: 2,
                      barRods: [
                        BarChartRodData(toY: 40, color: Colors.blue),
                        BarChartRodData(toY: 60, color: Colors.pink),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLegendItem(Colors.blue, 'Male'),
                const SizedBox(width: 20),
                _buildLegendItem(Colors.pink, 'Female'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          color: color,
        ),
        const SizedBox(width: 4),
        Text(label),
      ],
    );
  }

  Future<void> _saveReport(BuildContext context) async {
    final pdf = pw.Document();

    // Capture widget charts as images, check for null
    final hivPrevalenceImage = await _hivPrevalenceController.capture();
    final needleSharingImage = await _needleSharingController.capture();
    final drugPreferenceImage = await _drugPreferenceController.capture();
    final genderComparisonImage = await _genderComparisonController.capture();

    pdf.addPage(
      pw.MultiPage(
        build: (context) => [
          pw.Header(
            level: 0,
            child: pw.Text('PWID Treatment Report',
                style:
                    pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
          ),
          pw.SizedBox(height: 20),
          _buildPdfSummary(),
          pw.SizedBox(height: 20),
          _buildPdfImageSection('HIV Prevalence', hivPrevalenceImage),
          pw.SizedBox(height: 20),
          _buildPdfImageSection('Needle Sharing Practices', needleSharingImage),
          pw.SizedBox(height: 20),
          _buildPdfImageSection(
              'Drug Preference (Past 6 months)', drugPreferenceImage),
          pw.SizedBox(height: 20),
          _buildPdfImageSection('Gender Comparison', genderComparisonImage),
        ],
      ),
    );

    final output = await getTemporaryDirectory();
    final file = File('${output.path}/pwid_report.pdf');
    await file.writeAsBytes(await pdf.save());

    XFile xfile = XFile(file.path);
    await Share.shareXFiles([xfile], text: 'PWID Treatment Report');
  }
}

pw.Widget _buildPdfSummary() {
  return pw.Container(
    padding: const pw.EdgeInsets.all(10),
    decoration: pw.BoxDecoration(
      border: pw.Border.all(color: PdfColors.black),
    ),
    child: pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text('Summary',
            style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
        pw.SizedBox(height: 10),
        _buildPdfSummaryItem('Total PWID enrolled', '307'),
        _buildPdfSummaryItem('HIV Prevalence', '9.5%'),
        _buildPdfSummaryItem('Median Age', '28 years'),
        _buildPdfSummaryItem('Male PWID', '81%'),
        _buildPdfSummaryItem('Female PWID', '19%'),
      ],
    ),
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

pw.Widget _buildPdfChart(String title) {
  return pw.Container(
    padding: const pw.EdgeInsets.all(10),
    decoration: pw.BoxDecoration(
      border: pw.Border.all(color: PdfColors.black),
    ),
    child: pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(title,
            style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
        pw.SizedBox(height: 10),
        pw.Text('Chart placeholder - actual chart data would be included here'),
      ],
    ),
  );
}

pw.Widget _buildPdfImageSection(String title, Uint8List? image) {
  return pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: [
      pw.Text(title,
          style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
      pw.SizedBox(height: 10),
      if (image != null)
        pw.Image(pw.MemoryImage(image), height: 200)
      else
        pw.Text('Chart could not be rendered.'),
    ],
  );
}
