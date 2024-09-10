// lib/tabs/overview_tab.dart
import 'package:flutter/material.dart';

class OverviewTab extends StatelessWidget {
  const OverviewTab({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          const TabBar(
            tabs: [
              Tab(text: 'Patient Stats'),
              Tab(text: 'Treatment Progress'),
              Tab(text: 'Recent Activity'),
            ],
            labelColor: Colors.blue,
            unselectedLabelColor: Colors.grey,
          ),
          Expanded(
            child: TabBarView(
              children: [
                _buildPatientStats(),
                _buildTreatmentProgress(),
                _buildRecentActivity(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPatientStats() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStatCard('Total Patients', '120', Icons.people, Colors.blue),
          const SizedBox(height: 16),
          _buildStatCard('New Patients (This Month)', '15', Icons.person_add,
              Colors.green),
          const SizedBox(height: 16),
          _buildStatCard(
              'Active Treatment Plans', '95', Icons.healing, Colors.orange),
        ],
      ),
    );
  }

  Widget _buildTreatmentProgress() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildProgressCard('Completed Treatments', 0.7),
          const SizedBox(height: 16),
          _buildProgressCard('Ongoing Treatments', 0.3),
          const SizedBox(height: 16),
          _buildProgressCard('Patient Satisfaction', 0.85),
        ],
      ),
    );
  }

  Widget _buildRecentActivity() {
    return ListView(
      children: [
        _buildActivityItem(
            'John Doe completed a therapy session', '2 hours ago'),
        _buildActivityItem(
            'New patient file created for Jane Smith', '4 hours ago'),
        _buildActivityItem(
            'Treatment plan updated for Mike Johnson', 'Yesterday'),
        _buildActivityItem(
            'Follow-up appointment scheduled with Emily Brown', '2 days ago'),
      ],
    );
  }

  Widget _buildStatCard(
      String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(icon, size: 48, color: color),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
                Text(value,
                    style: TextStyle(
                        fontSize: 24,
                        color: color,
                        fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressCard(String title, double progress) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: progress,
              minHeight: 10,
              backgroundColor: Colors.grey[300],
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
            const SizedBox(height: 8),
            Text('${(progress * 100).toInt()}%',
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityItem(String activity, String time) {
    return ListTile(
      leading: const CircleAvatar(
        backgroundColor: Colors.blue,
        child: Icon(Icons.notifications, color: Colors.white),
      ),
      title: Text(activity),
      subtitle: Text(time),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
    );
  }
}
