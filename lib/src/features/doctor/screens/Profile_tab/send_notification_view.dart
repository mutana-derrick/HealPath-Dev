import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SendNotificationView extends StatefulWidget {
  const SendNotificationView({super.key});

  @override
  _SendNotificationViewState createState() => _SendNotificationViewState();
}

class _SendNotificationViewState extends State<SendNotificationView> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  Future<void> _sendNotification() async {
    final String title = _titleController.text;
    final String content = _contentController.text;

    if (title.isEmpty || content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    try {
      // Get all patient FCM tokens
      QuerySnapshot patientSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('role', isEqualTo: 'patient')
          .get();

      List<String> patientTokens = patientSnapshot.docs
          .map((doc) => doc['fcmToken'] as String?)
          .where((token) => token != null && token.isNotEmpty)
          .cast<String>()
          .toList();

      // Prepare notification data
      Map<String, dynamic> notificationData = {
        'title': title,
        'body': content,
        'tokens': patientTokens,
        'data': {
          'click_action': 'FLUTTER_NOTIFICATION_CLICK',
          'status': 'done',
        },
      };

      // TODO: Send this data to your backend service
      // For example, you might use an HTTP POST request:
      // await http.post(Uri.parse('YOUR_BACKEND_URL'), body: jsonEncode(notificationData));

      // For now, we'll just print the data
      print('Notification data to be sent to backend: $notificationData');

      // Save notification to Firestore
      await FirebaseFirestore.instance.collection('notifications').add({
        'title': title,
        'content': content,
        'sentAt': FieldValue.serverTimestamp(),
        'readBy': [],
      });

      // Clear the text fields after the notification is sent
      _titleController.clear();
      _contentController.clear();

      _showSuccessSnackBar(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error preparing notification: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Notification Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _contentController,
              decoration: const InputDecoration(
                labelText: 'Notification Content',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _sendNotification,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              child: const Text('Send Notification'),
            ),
          ],
        ),
      ),
    );
  }

  void _showSuccessSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.blue[900]),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Notification sent',
                style: TextStyle(color: Colors.blue[900]),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.lightBlue[100],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        animation: CurvedAnimation(
          parent: AnimationController(
            vsync: ScaffoldMessenger.of(context),
            duration: const Duration(milliseconds: 500),
          )..forward(),
          curve: Curves.easeOutCubic,
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
