import 'comment.dart';

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
