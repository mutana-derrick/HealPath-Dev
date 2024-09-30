import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'comment.dart';

class Post {
  final String id;
  final String userName;
  final String userProfilePicture;
  final String content;
  final String timestamp; // Now formatted as date string
  final int likes;
  final List<Comment> comments;

  Post({
    required this.id,
    required this.userName,
    required this.userProfilePicture,
    required this.content,
    required this.timestamp,
    required this.likes,
    required this.comments,
  });

  factory Post.fromFirestore(DocumentSnapshot doc) {
    var data = doc.data() as Map<String, dynamic>;

    // Format timestamp to display only the date
    String formattedTimestamp = '';
    if (data['timestamp'] != null && data['timestamp'] is Timestamp) {
      formattedTimestamp = DateFormat('yyyy-MM-dd')
          .format((data['timestamp'] as Timestamp).toDate());
    }

    // Process comments
    var commentsData = data['comments'] as List<dynamic>? ?? [];
    List<Comment> commentList = commentsData.map((commentData) {
      return Comment(
        userProfilePicture: commentData['userProfilePicture'] ?? '',
        userName: commentData['userName'] ?? '',
        content: commentData['content'] ?? '',
        timestamp: commentData['timestamp'] ?? '',
      );
    }).toList();

    return Post(
      id: doc.id,
      userName: data['userName'] ?? '',
      userProfilePicture: data['userProfilePicture'] ?? '',
      content: data['content'] ?? '',
      timestamp: formattedTimestamp, // Use formatted date
      likes: data['likes'] ?? 0,
      comments: commentList,
    );
  }

  get commentCount => null;
}
