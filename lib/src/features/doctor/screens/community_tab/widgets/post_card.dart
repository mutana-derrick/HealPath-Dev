import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../models/post.dart';

class PostCard extends StatefulWidget {
  final Post post;
  final VoidCallback onTap;

  const PostCard({super.key, required this.post, required this.onTap});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 16),
      child: InkWell(
        onTap: widget.onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildUserInfo(),
              const SizedBox(height: 8),
              Text(widget.post.content),
              const SizedBox(height: 8),
              _buildInteractionRow(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserInfo() {
    return Row(
      children: [
        CircleAvatar(
          backgroundImage: NetworkImage(widget.post.userProfilePicture),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.post.userName,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(widget.post.timestamp,
                style: const TextStyle(color: Colors.grey)),
          ],
        ),
      ],
    );
  }

  Widget _buildInteractionRow() {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.post.id)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const CircularProgressIndicator();
        }

        final updatedPost = Post.fromFirestore(snapshot.data!);

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                IconButton(
                  icon:
                      const Icon(Icons.thumb_up, color: Colors.blue, size: 16),
                  onPressed: () => _incrementLikes(updatedPost),
                ),
                const SizedBox(width: 4),
                Text('${updatedPost.likes}'),
              ],
            ),
            Text('${updatedPost.comments.length} Comments'),
          ],
        );
      },
    );
  }

  void _incrementLikes(Post post) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final postRef =
          FirebaseFirestore.instance.collection('posts').doc(post.id);
      final likedByRef = postRef.collection('likedBy').doc(user.uid);

      final likedByDoc = await likedByRef.get();

      if (likedByDoc.exists) {
        // User has already liked the post, so unlike it
        await postRef.update({'likes': FieldValue.increment(-1)});
        await likedByRef.delete();
      } else {
        // User hasn't liked the post, so like it
        await postRef.update({'likes': FieldValue.increment(1)});
        await likedByRef.set({'timestamp': FieldValue.serverTimestamp()});
      }
    }
  }
}
