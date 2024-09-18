import 'package:flutter/material.dart';
import 'profile_view.dart';
import 'send_notification_view.dart';
import 'sent_notifications_view.dart';
import 'report_view.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  _ProfileTabState createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
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
                ProfileView(),
                SendNotificationView(),
                SentNotificationsView(),
                ReportView(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
