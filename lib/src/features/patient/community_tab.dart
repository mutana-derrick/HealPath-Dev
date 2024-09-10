// lib/tabs/patient_community_tab.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PatientCommunityTab extends StatelessWidget {
  const PatientCommunityTab({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PatientCommunityController>(
      init: PatientCommunityController(),
      builder: (controller) {
        return ListView.builder(
          itemCount: controller.posts.length,
          itemBuilder: (context, index) {
            final post = controller.posts[index];
            return Card(
              margin: EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    leading: CircleAvatar(child: Text(post.author[0])),
                    title: Text(post.title),
                    subtitle: Text('by ${post.author}'),
                  ),
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(post.content),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text('Comments: ${post.comments.length}'),
                  ),
                  ...post.comments.map((comment) => ListTile(
                        title: Text(comment.content),
                        subtitle: Text('by ${comment.author}'),
                      )),
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Add a comment...',
                        suffixIcon: IconButton(
                          icon: Icon(Icons.send),
                          onPressed: () => controller.addComment(index),
                        ),
                      ),
                      controller: controller.commentControllers[index],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class PatientCommunityController extends GetxController {
  List<Post> posts = [
    Post(
      title: 'Welcome to our community',
      content: 'This is a safe space for all patients...',
      author: 'Dr. Smith',
      comments: [],
    ),
    // Add more posts...
  ];

  List<TextEditingController> commentControllers = [];

  @override
  void onInit() {
    super.onInit();
    commentControllers =
        List.generate(posts.length, (_) => TextEditingController());
  }

  void addComment(int postIndex) {
    final content = commentControllers[postIndex].text;
    if (content.isNotEmpty) {
      posts[postIndex]
          .comments
          .add(Comment(content: content, author: 'Patient'));
      commentControllers[postIndex].clear();
      update();
    }
  }
}

class Post {
  final String title;
  final String content;
  final String author;
  final List<Comment> comments;

  Post(
      {required this.title,
      required this.content,
      required this.author,
      required this.comments});
}

class Comment {
  final String content;
  final String author;

  Comment({required this.content, required this.author});
}
