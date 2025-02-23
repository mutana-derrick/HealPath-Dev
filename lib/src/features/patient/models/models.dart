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

class ChatMessage {
  final String senderId;
  final String receiverId;
  final String message;
  final DateTime timestamp;
  final String senderRole; // 'doctor' or 'patient'

  ChatMessage({
    required this.senderId,
    required this.receiverId,
    required this.message,
    required this.timestamp,
    required this.senderRole,
  });

  Map<String, dynamic> toJson() {
    return {
      'senderId': senderId,
      'receiverId': receiverId,
      'message': message,
      'timestamp': timestamp.toIso8601String(),
      'senderRole': senderRole,
    };
  }

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      senderId: json['senderId'],
      receiverId: json['receiverId'],
      message: json['message'],
      timestamp: DateTime.parse(json['timestamp']),
      senderRole: json['senderRole'],
    );
  }
}