import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healpath/src/features/patient/models/models.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class CommentsSheet extends StatefulWidget {
  final Post post;

  const CommentsSheet({super.key, required this.post});

  @override
  _CommentsSheetState createState() => _CommentsSheetState();
}

class _CommentsSheetState extends State<CommentsSheet> {
  final TextEditingController _commentController = TextEditingController();

  void _addComment() async {
    if (_commentController.text.isNotEmpty) {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Fetch user's fullName from Firestore
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        final userName = userDoc.data()?['fullName'] ?? 'Anonymous';

        final comment = Comment(
          content: _commentController.text,
          userName: userName,
          userProfilePicture:
              user.photoURL ?? 'https://example.com/default.jpg',
          timestamp: DateFormat('yyyy-MM-dd').format(DateTime.now()),
        );

        // Add comment to Firestore
        await FirebaseFirestore.instance
            .collection('posts')
            .doc(widget.post.id)
            .collection('comments')
            .add({
          'content': comment.content,
          'userName': comment.userName,
          'userProfilePicture': comment.userProfilePicture,
          'timestamp': FieldValue.serverTimestamp(),
        });

        // Update local state
        setState(() {
          widget.post.comments.add(comment);
          _commentController.clear();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // The build method remains unchanged
    return Material(
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            AppBar(
              title: Text('${widget.post.userName}\'s Post'),
              backgroundColor: Colors.blue,
              elevation: 1,
              leading: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(widget.post.content),
                  ),
                  ...widget.post.comments
                      .map((comment) => CommentCard(comment: comment)),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: TextField(
                        controller: _commentController,
                        decoration: InputDecoration(
                          hintText: 'Add a comment...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.send),
                            color: Colors.blue,
                            onPressed: _addComment,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// CommentCard and AuthController classes remain unchanged

class CommentCard extends StatelessWidget {
  final Comment comment;

  const CommentCard({super.key, required this.comment});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(comment.userProfilePicture),
        child: comment.userProfilePicture.isEmpty
            ? Text(comment.userName[0])
            : null,
      ),
      title: Text(comment.userName),
      subtitle: Text(comment.content),
      trailing: Text(comment.timestamp),
    );
  }
}

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Rx<User?> _firebaseUser = Rx<User?>(null);

  User? get currentUser => _firebaseUser.value;

  @override
  void onInit() {
    super.onInit();
    _firebaseUser.bindStream(_auth.authStateChanges());
  }

  // Add other authentication methods as needed
}
