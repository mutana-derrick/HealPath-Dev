import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healpath/src/features/doctor/community_tab/widgets/comments_sheets.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'community_tab_controller.dart';
import './widgets/post_card.dart';
import 'models/post.dart';


class CommunityTab extends StatelessWidget {
  const CommunityTab({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CommunityTabController>(
      init: CommunityTabController(),
      builder: (controller) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: _buildNewPostField(),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: controller.posts.length,
                itemBuilder: (context, index) {
                  return PostCard(
                    post: controller.posts[index],
                    onTap: () => _showComments(context, controller.posts[index]),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildNewPostField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Create a new post...',
          suffixIcon: IconButton(
            icon: const Icon(Icons.send),
            onPressed: () {
              // TODO: Implement post creation logic
            },
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.all(16),
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
}