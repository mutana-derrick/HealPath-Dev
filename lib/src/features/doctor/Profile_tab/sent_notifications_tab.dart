import 'package:flutter/material.dart';

class SentNotificationsTab extends StatelessWidget {
  final List<Map<String, String>> sentNotifications;

  const SentNotificationsTab({Key? key, required this.sentNotifications})
      : super(key: key);

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
