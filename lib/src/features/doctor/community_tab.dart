import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

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
                child: Container(
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
                ),
              ),

              /** Post List  */
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
          );
        });
  }

  void _showComments(BuildContext context, Post post) {
    showCupertinoModalBottomSheet(
      context: context,
      builder: (context) => CommentsSheet(post: post),
    );
  }
}

class PostCard extends StatefulWidget {
  final Post post;
  final VoidCallback onTap;

  const PostCard({super.key, required this.post, required this.onTap});

  @override
  _PostCardState createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  late int likeCount;

  @override
  void initState() {
    super.initState();
    likeCount = widget.post.likes; // Initialize with the current like count
  }

  void _incrementLikes() {
    setState(() {
      likeCount++; // Increment like count
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
                        NetworkImage(widget.post.userProfilePicture),
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
                        onPressed:
                            _incrementLikes, // Increment like count on press
                      ),
                      const SizedBox(width: 4),
                      Text('$likeCount'), // Display the updated like count
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

class CommentCard extends StatelessWidget {
  final Comment comment;

  const CommentCard({super.key, required this.comment});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(comment.userProfilePicture),
            radius: 16,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(comment.userName,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(comment.content),
                const SizedBox(height: 4),
                Text(comment.timestamp,
                    style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

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
              flexibleSpace: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3), // Shadow color
                      spreadRadius: 3, // How much the shadow spreads
                      blurRadius: 10, // Softness of the shadow
                      offset:
                          const Offset(0, 4), // X and Y offset of the shadow
                    ),
                  ],
                ),
              ),
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
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }
}

class CommunityTabController extends GetxController {
  List<Post> posts = [
    Post(
      userName: 'Dr. Mohamed Benar',
      userProfilePicture:
          'https://www.flaticon.com/free-icon/medical-assistance_4526826?related_id=4526826',
      content:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam vitae nibh id mauris condimentum volutis et sed enim.',
      timestamp: 'March 15 · 14:30',
      likes: 15,
      comments: [
        Comment(
          content:
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam vitae nibh id mauris condi mentum volutis et sed enim.',
          userName: 'Salahuddin',
          userProfilePicture: 'https://example.com/salahuddin.jpg',
          timestamp: '2h',
        ),
        Comment(
          content:
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam vitae nibh id.',
          userName: 'Aman Richman',
          userProfilePicture: 'https://example.com/aman.jpg',
          timestamp: '1h',
        ),
      ],
    ),

    Post(
      userName: 'Dr. Mohamed Benar',
      userProfilePicture:
          'https://www.flaticon.com/free-icon/medical-assistance_4526826?related_id=4526826',
      content:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam vitae nibh id mauris condimentum volutis et sed enim.',
      timestamp: 'March 15 · 14:30',
      likes: 15,
      comments: [
        Comment(
          content:
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam vitae nibh id mauris condi mentum volutis et sed enim.',
          userName: 'Salahuddin',
          userProfilePicture: 'https://example.com/salahuddin.jpg',
          timestamp: '2h',
        ),
        Comment(
          content:
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam vitae nibh id.',
          userName: 'Aman Richman',
          userProfilePicture: 'https://example.com/aman.jpg',
          timestamp: '1h',
        ),
      ],
    ),

    Post(
      userName: 'Dr. Mohamed Benar',
      userProfilePicture:
          'https://www.flaticon.com/free-icon/medical-assistance_4526826?related_id=4526826',
      content:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam vitae nibh id mauris condimentum volutis et sed enim.',
      timestamp: 'March 15 · 14:30',
      likes: 15,
      comments: [
        Comment(
          content:
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam vitae nibh id mauris condi mentum volutis et sed enim.',
          userName: 'Salahuddin',
          userProfilePicture: 'https://example.com/salahuddin.jpg',
          timestamp: '2h',
        ),
        Comment(
          content:
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam vitae nibh id.',
          userName: 'Aman Richman',
          userProfilePicture: 'https://example.com/aman.jpg',
          timestamp: '1h',
        ),
      ],
    ),
    // Add more posts as needed...
  ];

  // Additional methods and logic for the controller...
}

class Post {
  final String userName;
  final String userProfilePicture;
  final String content;
  final String timestamp;
  final int likes;
  final List<Comment> comments;

  Post({
    required this.userName,
    required this.userProfilePicture,
    required this.content,
    required this.timestamp,
    required this.likes,
    required this.comments,
  });
}

class Comment {
  final String content;
  final String userName;
  final String userProfilePicture;
  final String timestamp;

  Comment({
    required this.content,
    required this.userName,
    required this.userProfilePicture,
    required this.timestamp,
  });
}
