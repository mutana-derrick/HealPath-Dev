import 'package:flutter/material.dart';
import 'package:healpath/src/features/patient/Community_tab/models.dart';

class PostCard extends StatefulWidget {
  final Post post;
  final VoidCallback onTap;

  const PostCard({Key? key, required this.post, required this.onTap})
      : super(key: key);

  @override
  _PostCardState createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  late int likeCount;

  @override
  void initState() {
    super.initState();
    likeCount = widget.post.likes;
  }

  void _incrementLikes() {
    setState(() {
      likeCount++;
    });
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
                        icon: const Icon(Icons.thumb_up,
                            color: Colors.blue, size: 16),
                        onPressed: _incrementLikes,
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
