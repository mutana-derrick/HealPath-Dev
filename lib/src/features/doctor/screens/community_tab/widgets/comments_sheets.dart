import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../models/post.dart';
import '../../../models/comment.dart';
import 'comment_card.dart';

class CommentsSheet extends StatelessWidget {
  final Post post;

  const CommentsSheet({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            _buildAppBar(context),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('posts')
                    .doc(post.id)
                    .collection('comments')
                    .orderBy('timestamp', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final comments = snapshot.data!.docs
                      .map((doc) => Comment.fromFirestore(doc))
                      .toList();

                  return ListView(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(post.content),
                      ),
                      ...comments
                          .map((comment) => CommentCard(comment: comment))
                          .toList(),
                    ],
                  );
                },
              ),
            ),
            _buildCommentInput(context),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text('${post.userName}\'s Post'),
      backgroundColor: Colors.blue,
      elevation: 1,
      flexibleSpace: Container(),
      leading: IconButton(
        icon: const Icon(Icons.close),
        onPressed: () => Navigator.of(context).pop(),
      ),
    );
  }

  Widget _buildCommentInput(BuildContext context) {
    final TextEditingController _commentController = TextEditingController();

    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: TextField(
                controller: _commentController,
                decoration: InputDecoration(
                  hintText: 'Add a comment...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.send),
                    color: Colors.blue,
                    onPressed: () => _addComment(context, _commentController),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(
                      color: Colors.blue,
                      width: 2.0,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _addComment(
      BuildContext context, TextEditingController controller) async {
    if (controller.text.isNotEmpty) {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Fetch user's fullName from Firestore
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        final userName = userDoc.data()?['fullName'] ?? 'Anonymous';

        await FirebaseFirestore.instance
            .collection('posts')
            .doc(post.id)
            .collection('comments')
            .add({
          'content': controller.text,
          'userName': userName,
          'userProfilePicture':
              user.photoURL ?? 'https://example.com/default.jpg',
          'timestamp': FieldValue.serverTimestamp(),
        });
        controller.clear();
      }
    }
  }
}
