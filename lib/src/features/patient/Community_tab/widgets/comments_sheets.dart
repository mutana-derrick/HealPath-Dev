import 'package:flutter/material.dart';
import 'package:healpath/src/features/patient/community_tab/models.dart';

class CommentsSheet extends StatefulWidget {
  final Post post;

  const CommentsSheet({super.key, required this.post});

  @override
  _CommentsSheetState createState() => _CommentsSheetState();
}

class _CommentsSheetState extends State<CommentsSheet> {
  final TextEditingController _commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
            Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width *
                          0.9, // 80% of screen width
                      child: TextField(
                        controller: _commentController,
                        decoration: InputDecoration(
                          hintText: 'Add a comment...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.send),
                            color: Colors.blue,
                            onPressed: () {
                              if (_commentController.text.isNotEmpty) {
                                setState(() {
                                  widget.post.comments.add(Comment(
                                    content: _commentController.text,
                                    userName:
                                        'Current User', // Replace with actual user name
                                    userProfilePicture:
                                        'https://example.com/user.jpg', // Replace with actual user profile picture
                                    timestamp: 'Just now',
                                  ));
                                  _commentController.clear();
                                });
                              }
                            },
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
            ),
          ],
        ),
      ),
    );
  }
}

class CommentCard extends StatelessWidget {
  final Comment comment;

  const CommentCard({super.key, required this.comment});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        child: Text(comment.userName[0]),
      ),
      title: Text(comment.userName),
      subtitle: Text(comment.content),
      trailing: Text(comment.timestamp),
    );
  }
}
