import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  final String userProfilePicture;
  final String userName;
  final String content;
  final String timestamp;

  Comment({
    required this.userProfilePicture,
    required this.userName,
    required this.content,
    required this.timestamp,
  });

  // Factory method to create a Comment from Firestore data
  factory Comment.fromFirestore(DocumentSnapshot doc) {
    var data = doc.data() as Map<String, dynamic>; // Cast the data to Map<String, dynamic>

    return Comment(
      userProfilePicture: data['userProfilePicture'] ?? '',
      userName: data['userName'] ?? '',
      content: data['content'] ?? '',
      timestamp: data['timestamp'] ?? '',
    );
  }
}

