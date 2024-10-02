class Post {
  final String id; // Added the id field
  final String userName;
  final String userProfilePicture;
  final String content;
  final String timestamp;
  int likes;
  final List<Comment> comments;

  Post({
    required this.id, // Add id as a required parameter
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

  Map<String, dynamic> toMap() {
    return {
      'content': content,
      'userName': userName,
      'userProfilePicture': userProfilePicture,
      'timestamp': timestamp,
    };
  }

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
    content: json['content'],
    userName: json['userName'],
    userProfilePicture: json['userProfilePicture'],
    timestamp: json['timestamp'],
  );
}
