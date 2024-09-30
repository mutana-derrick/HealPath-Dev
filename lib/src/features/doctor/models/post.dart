import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'comment.dart'; // Import the Comment model

class Post {
  final String id;
  final String userName;
  final String userProfilePicture;
  final String content;
  final String timestamp; // Now it will store a formatted string version of timestamp
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

  // Factory method to create a Post from Firestore data
  factory Post.fromFirestore(DocumentSnapshot doc) {
    var data = doc.data() as Map<String, dynamic>;

    // Convert Firestore's Timestamp to a formatted string
    String formattedTimestamp = '';
    if (data['timestamp'] != null && data['timestamp'] is Timestamp) {
      formattedTimestamp = (data['timestamp'] as Timestamp).toDate().toIso8601String();
    }

    // Handle comments which are stored as a List of Maps in Firestore
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
      timestamp: formattedTimestamp, // Use the formatted timestamp
      likes: data['likes'] ?? 0,
      comments: commentList,
    );
  }
}
