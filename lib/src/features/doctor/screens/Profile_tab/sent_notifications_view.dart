import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SentNotificationsView extends StatelessWidget {
  const SentNotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('notifications')
          .orderBy('sentAt', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final notifications = snapshot.data!.docs;

        return ListView.builder(
          itemCount: notifications.length,
          itemBuilder: (context, index) {
            final notification = notifications[index];
            final data = notification.data() as Map<String, dynamic>;

            return ExpansionTile(
              title: Text(data['title']),
              subtitle: Text(
                  'Sent: ${(data['sentAt'] as Timestamp).toDate().toString()}'),
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Content: ${data['content']}'),
                      const SizedBox(height: 8),
                      Text(
                          'Read by: ${(data['readBy'] as List).length} patients'),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        child: const Text('View Readers'),
                        onPressed: () {
                          _showReadersDialog(context, data['readBy'] as List);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showReadersDialog(BuildContext context, List readBy) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Patients who read this notification'),
          content: SizedBox(
            width: double.maxFinite,
            child: readBy.isEmpty
                ? const Text('No patients have read this notification yet.')
                : FutureBuilder<QuerySnapshot>(
                    future: FirebaseFirestore.instance
                        .collection('users')
                        .where(FieldPath.documentId, whereIn: readBy)
                        .get(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      }
                      final patients = snapshot.data!.docs;
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: patients.length,
                        itemBuilder: (context, index) {
                          final patient =
                              patients[index].data() as Map<String, dynamic>;
                          return ListTile(
                            title: Text(patient['fullName']),
                            subtitle: Text(patient['email']),
                          );
                        },
                      );
                    },
                  ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
