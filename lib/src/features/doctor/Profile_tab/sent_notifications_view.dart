import 'package:flutter/material.dart';

class SentNotificationsView extends StatelessWidget {
  final List<Map<String, String>> sentNotifications = [
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
}