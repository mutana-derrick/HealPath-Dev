import 'package:flutter/material.dart';

class SearchBarWithNotifications extends StatelessWidget {
  final VoidCallback onNotificationTap;

  const SearchBarWithNotifications({Key? key, required this.onNotificationTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: const BoxDecoration(color: Colors.blue),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search Posts and Comments',
                hintStyle: TextStyle(color: Colors.blue.shade900),
                prefixIcon: Icon(Icons.search, color: Colors.blue.shade900),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide:
                      BorderSide(color: Colors.blue.shade900, width: 2.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide:
                      BorderSide(color: Colors.blue.shade900, width: 1.0),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 8),
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: Icon(Icons.notifications, color: Colors.blue.shade900),
            onPressed: onNotificationTap,
          ),
        ],
      ),
    );
  }
}
