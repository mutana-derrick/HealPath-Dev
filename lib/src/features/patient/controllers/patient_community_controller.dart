import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:healpath/src/features/patient/models/models.dart';
import 'package:intl/intl.dart'; // Import this for date formatting

class PatientCommunityController extends GetxController {
  var posts = <Post>[].obs;
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

      var postList = postDocs.docs.map((doc) {
        var data = doc.data();
        return Post(
          id: doc.id,
          userName: data['userName'] ?? '',
          userProfilePicture: data['userProfilePicture'] ?? '',
          content: data['content'] ?? '',
          timestamp: data['timestamp'] != null
              ? DateFormat('yyyy-MM-dd').format((data['timestamp'] as Timestamp).toDate())
              : '',
          likes: data['likes'] ?? 0,
          comments: (data['comments'] as List<dynamic>?)
              ?.map((c) => Comment.fromJson(c))
              .toList() ?? [],
        );
      }).toList();

      posts.assignAll(postList);
    } catch (e) {
      print('Error fetching doctor posts: $e');
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
      await postRef.update({
        'comments': FieldValue.arrayUnion([comment.toMap()])
      });
    } catch (e) {
      print('Error adding comment: $e');
    }
  }
}