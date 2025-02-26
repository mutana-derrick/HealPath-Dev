import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:healpath/src/features/patient/models/models.dart';
import 'package:intl/intl.dart';

class PatientCommunityController extends GetxController {
  var posts = <Post>[].obs;
  var filteredPosts = <Post>[].obs;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
    fetchDoctorPosts();
  }

  void fetchDoctorPosts() async {
    try {
      var postDocs = await firestore
          .collection('posts')
          .orderBy('timestamp', descending: true)
          .get();

      var postList = await Future.wait(postDocs.docs.map((doc) async {
        var data = doc.data();

        var commentDocs = await firestore
            .collection('posts')
            .doc(doc.id)
            .collection('comments')
            .orderBy('timestamp', descending: true)
            .get();

        var commentList = commentDocs.docs.map((commentDoc) {
          var commentData = commentDoc.data();
          return Comment(
            content: commentData['content'] ?? '',
            userName: commentData['userName'] ?? 'Anonymous',
            userProfilePicture: commentData['userProfilePicture'] ?? '',
            timestamp: commentData['timestamp'] != null
                ? DateFormat('yyyy-MM-dd')
                    .format((commentData['timestamp'] as Timestamp).toDate())
                : '',
          );
        }).toList();

        return Post(
          id: doc.id,
          userName: data['userName'] ?? '',
          userProfilePicture: data['userProfilePicture'] ?? '',
          content: data['content'] ?? '',
          timestamp: data['timestamp'] != null
              ? DateFormat('yyyy-MM-dd')
                  .format((data['timestamp'] as Timestamp).toDate())
              : '',
          likes: data['likes'] ?? 0,
          comments: commentList,
        );
      }).toList());

      posts.assignAll(postList);
      filteredPosts.assignAll(postList);
    } catch (e) {
      print('Error fetching doctor posts: $e');
    }
  }

  void searchPosts(String query) {
    if (query.isEmpty) {
      filteredPosts.assignAll(posts);
    } else {
      filteredPosts.assignAll(posts.where((post) =>
          post.content.toLowerCase().contains(query.toLowerCase()) ||
          post.userName.toLowerCase().contains(query.toLowerCase()) ||
          post.comments.any((comment) =>
              comment.content.toLowerCase().contains(query.toLowerCase()))));
    }
  }

  void toggleLike(String postId, bool isLiked) async {
    try {
      var postRef = firestore.collection('posts').doc(postId);
      await postRef.update({'likes': FieldValue.increment(isLiked ? 1 : -1)});
    } catch (e) {
      print('Error toggling like: $e');
    }
  }

  Future<void> addComment(String postId, Comment comment) async {
    try {
      var postRef = firestore.collection('posts').doc(postId);
      await postRef.collection('comments').add({
        'content': comment.content,
        'userName': comment.userName,
        'userProfilePicture': comment.userProfilePicture,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error adding comment: $e');
    }
  }
}