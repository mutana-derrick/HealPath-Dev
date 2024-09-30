import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

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

  factory Comment.fromFirestore(DocumentSnapshot doc) {
    var data = doc.data() as Map<String, dynamic>;

    // Format the timestamp to display the date
    String formattedTimestamp = '';
    if (data['timestamp'] != null && data['timestamp'] is Timestamp) {
      formattedTimestamp = DateFormat('yyyy-MM-dd')
          .format((data['timestamp'] as Timestamp).toDate());
    }

    return Comment(
      userProfilePicture: data['userProfilePicture'] ?? '',
      userName: data['userName'] ?? '',
      content: data['content'] ?? '',
      timestamp: formattedTimestamp, // Use formatted date
    );
  }
}
