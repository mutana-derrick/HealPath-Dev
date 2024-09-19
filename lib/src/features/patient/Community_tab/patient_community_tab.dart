import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healpath/src/features/patient/Community_tab/patient_community_controller.dart';
import 'package:healpath/src/features/patient/Community_tab/widgets/comments_sheets.dart';
import 'package:healpath/src/features/patient/Community_tab/models.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'widgets/post_card.dart';
import 'widgets/search_bar_with_notifications.dart';
import 'widgets/notifications_list.dart';

class PatientCommunityTab extends StatelessWidget {
  const PatientCommunityTab({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PatientCommunityController>(
      init: PatientCommunityController(),
      builder: (controller) {
        return Scaffold(
          body: Column(
            children: [
              SearchBarWithNotifications(
                onNotificationTap: () => _showNotifications(context),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildTabButton('Posts', true),
                    _buildTabButton('News', false),
                    _buildTabButton('Trending', false),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: controller.posts.length,
                  itemBuilder: (context, index) {
                    return PostCard(
                      post: controller.posts[index],
                      onTap: () =>
                          _showComments(context, controller.posts[index]),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTabButton(String title, bool isActive) {
    return TextButton(
      onPressed: () {},
      child: Text(
        title,
        style: TextStyle(
          color: isActive ? Colors.blue : Colors.grey,
          fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  void _showComments(BuildContext context, Post post) {
    showCupertinoModalBottomSheet(
      context: context,
      builder: (context) => CommentsSheet(post: post),
    );
  }

  void _showNotifications(BuildContext context) {
    showCupertinoModalBottomSheet(
      context: context,
      expand: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const NotificationsList(),
    );
  }
}
