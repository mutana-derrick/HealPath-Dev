import 'package:flutter/material.dart';

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
      length: 3,
      child: Column(
        children: [
          const TabBar(
            tabs: [
              Tab(text: 'Profile'),
              Tab(text: 'Send Notification'),
              Tab(text: 'Sent Notifications'),
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

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
