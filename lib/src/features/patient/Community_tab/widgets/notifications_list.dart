import 'package:flutter/material.dart';

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
              child: ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: CircleAvatar(child: Text('${index + 1}')),
                    title: Text('Notification ${index + 1}'),
                    subtitle:
                        const Text('This is a sample notification message.'),
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
