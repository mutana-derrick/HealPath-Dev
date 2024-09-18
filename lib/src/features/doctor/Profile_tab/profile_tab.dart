import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
// import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io';

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  _ProfileTabState createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  // Static doctor data
  Map<String, String> doctorInfo = {
    'name': 'Dr. John Smith',
    'email': 'john.smith@example.com',
    'specialization': 'Addiction Specialist',
    'license': 'ABC123456',
  };

  // Static list of sent notifications
  List<Map<String, String>> sentNotifications = [
    {
      'title': 'Reminder: Group Session',
      'status': 'Approved',
      'date': '2023-05-15'
    },
    {'title': 'New Article Posted', 'status': 'Pending', 'date': '2023-05-14'},
    {'title': 'Schedule Change', 'status': 'Approved', 'date': '2023-05-13'},
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Column(
        children: [
          const TabBar(
            tabs: [
              Tab(text: 'Profile'),
              Tab(text: 'Send Notification'),
              Tab(text: 'Sent Notifications'),
              Tab(text: 'Report'),
            ],
            labelColor: Colors.blue,
            unselectedLabelColor: Colors.grey,
          ),
          Expanded(
            child: TabBarView(
              children: [
                _buildProfileView(),
                _buildSendNotificationView(),
                _buildSentNotificationsView(),
                _buildReportView(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile section with an edit icon over the avatar
          Center(
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.blue[900],
                  child: CircleAvatar(
                    radius: 56,
                    backgroundColor: Colors.blue[100],
                    child: Text(
                      doctorInfo['name']![
                          0], // Display the initial of the doctor's name
                      style: const TextStyle(fontSize: 40, color: Colors.white),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: InkWell(
                    onTap: () {
                      _showEditProfileDialog();
                    },
                    child: const CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.blue,
                      child: Icon(Icons.edit, size: 15, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _buildInfoField('Name', doctorInfo['name']!),
          _buildInfoField('Email', doctorInfo['email']!),
          _buildInfoField('Specialization', doctorInfo['specialization']!),
          _buildInfoField('License Number', doctorInfo['license']!),
        ],
      ),
    );
  }

  Widget _buildInfoField(String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black54,
            ),
          ),
          Text(
            value,
            style: const TextStyle(color: Colors.black87),
          ),
        ],
      ),
    );
  }

  Widget _buildSendNotificationView() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const TextField(
            decoration: InputDecoration(
              labelText: 'Notification Title',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          const TextField(
            decoration: InputDecoration(
              labelText: 'Notification Content',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Notification sent for approval')),
              );
            },
            child: const Text('Send Notification'),
          ),
        ],
      ),
    );
  }

  Widget _buildSentNotificationsView() {
    return ListView.builder(
      itemCount: sentNotifications.length,
      itemBuilder: (context, index) {
        final notification = sentNotifications[index];
        return Column(
          children: [
            ListTile(
              title: Text(notification['title']!),
              subtitle: Text('Date: ${notification['date']}'),
              trailing: Chip(
                label: Text(notification['status']!),
                backgroundColor: notification['status'] == 'Approved'
                    ? Colors.green
                    : Colors.orange,
              ),
            ),
            if (index < sentNotifications.length - 1)
              const Divider(color: Colors.grey),
          ],
        );
      },
    );
  }

  void _showEditProfileDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Profile'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: doctorInfo.keys.map((key) {
                return TextField(
                  decoration: InputDecoration(labelText: key.capitalize()),
                  controller: TextEditingController(text: doctorInfo[key]),
                  onChanged: (value) {
                    doctorInfo[key] = value;
                  },
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {}); // Rebuild to reflect changes
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}

Widget _buildReportView() {
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
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            ElevatedButton.icon(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all<Color>(
                    Colors.blue), // Set background color directly
                foregroundColor: WidgetStateProperty.all<Color>(
                    Colors.white), // Set text color directly
              ),
              onPressed: _saveReport,
              icon: const Icon(Icons.save),
              label: const Text('Save Report'),
            ),
          ],
        ),
        const SizedBox(height: 20),
        _buildSummaryCard(),
        const SizedBox(height: 20),
        _buildHIVPrevalenceChart(),
        const SizedBox(height: 20),
        _buildNeedleSharingChart(),
        const SizedBox(height: 20),
        _buildDrugPreferenceChart(),
        const SizedBox(height: 20),
        _buildGenderComparisonChart(),
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
                    value: 99,
                    title: 'Heroin\n99%',
                    radius: 50,
                    titleStyle: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  PieChartSectionData(
                    color: Colors.blue,
                    value: 10,
                    title: 'Cocaine\n10%',
                    radius: 50,
                    titleStyle: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  PieChartSectionData(
                    color: Colors.green,
                    value: 4,
                    title: 'Meth\n4%',
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
                            return const Text('Needle sharing');
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

Future<void> _saveReport() async {
  final pdf = pw.Document();

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
        _buildPdfChart('HIV Prevalence'),
        pw.SizedBox(height: 20),
        _buildPdfChart('Needle Sharing Practices'),
        pw.SizedBox(height: 20),
        _buildPdfChart('Drug Preference (Past 6 months)'),
        pw.SizedBox(height: 20),
        _buildPdfChart('Gender Comparison'),
      ],
    ),
  );

  final output = await getTemporaryDirectory();
  final file = File('${output.path}/pwid_report.pdf');
  await file.writeAsBytes(await pdf.save());

  // Correct method to use in share_plus 10.0.2
  XFile xfile = XFile(file.path);
  await Share.shareXFiles([xfile], text: 'PWID Treatment Report');
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

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
