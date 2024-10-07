import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NotificationsList extends StatelessWidget {
  const NotificationsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppBar(
              title: const Text('Notifications'),
              backgroundColor: Colors.blue,
              leading: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
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
                      final bool isRead = (data['readBy'] as List).contains(FirebaseAuth.instance.currentUser!.uid);

                      return ListTile(
                        leading: CircleAvatar(child: Text('${index + 1}')),
                        title: Text(data['title']),
                        subtitle: Text(data['content']),
                        trailing: isRead
                            ? const Icon(Icons.check_circle, color: Colors.green)
                            : TextButton(
                                child: const Text('Mark as Read'),
                                onPressed: () async {
                                  await FirebaseFirestore.instance
                                      .collection('notifications')
                                      .doc(notification.id)
                                      .update({
                                    'readBy': FieldValue.arrayUnion([FirebaseAuth.instance.currentUser!.uid])
                                  });
                                },
                              ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}