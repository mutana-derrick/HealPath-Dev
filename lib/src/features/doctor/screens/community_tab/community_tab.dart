import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:healpath/src/features/doctor/screens/community_tab/widgets/comments_sheets.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'widgets/post_card.dart';
import '../../models/post.dart';

class CommunityTab extends StatelessWidget {
  const CommunityTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: _buildNewPostField(context),
        ),
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('posts')
                .orderBy('timestamp', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              final posts = snapshot.data!.docs
                  .map((doc) => Post.fromFirestore(doc))
                  .toList();

              return ListView.builder(
                itemCount: posts.length,
                itemBuilder: (context, index) {
                  return PostCard(
                    post: posts[index],
                    onTap: () => _showComments(context, posts[index]),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildNewPostField(BuildContext context) {
    final TextEditingController _postController = TextEditingController();

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
        controller: _postController,
        decoration: InputDecoration(
          hintText: 'Create a new post...',
          suffixIcon: IconButton(
            icon: const Icon(Icons.send),
            onPressed: () async {
              if (_postController.text.isNotEmpty) {
                final user = FirebaseAuth.instance.currentUser;
                if (user != null) {
                  await FirebaseFirestore.instance.collection('posts').add({
                    'content': _postController.text,
                    'userName': user.displayName ?? 'Anonymous',
                    'userProfilePicture':
                        user.photoURL ?? 'https://example.com/default.jpg',
                    'timestamp': FieldValue.serverTimestamp(),
                    'likes': 0,
                  });
                  _postController.clear();
                }
              }
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
