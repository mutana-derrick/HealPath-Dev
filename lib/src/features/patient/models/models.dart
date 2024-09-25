class Post {
  final String userName;
  final String userProfilePicture;
  final String content;
  final String timestamp;
  int likes;
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
