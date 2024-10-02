import 'package:flutter/material.dart';
import 'package:healpath/src/features/patient/controllers/patient_community_controller.dart';
import 'package:healpath/src/features/patient/models/models.dart';
import 'package:get/get.dart';

class PostCard extends StatefulWidget {
  final Post post;
  final VoidCallback onTap;

  const PostCard({super.key, required this.post, required this.onTap});

  @override
  _PostCardState createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isLiked = false;
  late int likeCount;

  @override
  void initState() {
    super.initState();
    likeCount = widget.post.likes;
    // Check if the user has liked the post (implement your own logic for user like tracking)
    // isLiked = checkIfUserLikedPost();
  }

  void _toggleLike() {
    setState(() {
      isLiked = !isLiked;
      likeCount = isLiked ? likeCount + 1 : likeCount - 1;
    });

    // Update Firestore
    Get.find<PatientCommunityController>().toggleLike(widget.post.id, isLiked);
  }

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
              Row(
                children: [
                  CircleAvatar(
                      backgroundImage:
                          NetworkImage(widget.post.userProfilePicture)),
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
              ),
              const SizedBox(height: 8),
              Text(widget.post.content),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.thumb_up,
                          color: isLiked ? Colors.blue : Colors.grey,
                          size: 16,
                        ),
                        onPressed: _toggleLike,
                      ),
                      const SizedBox(width: 4),
                      Text('$likeCount'),
                    ],
                  ),
                  Text('${widget.post.comments.length} Comments'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

