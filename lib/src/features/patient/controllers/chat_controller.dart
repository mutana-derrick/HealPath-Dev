import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:healpath/src/features/patient/models/models.dart';

class ChatController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final RxList<ChatMessage> messages = <ChatMessage>[].obs;
  
  Stream<List<ChatMessage>> getMessages(String currentUserId, String otherUserId) {
    return _firestore
        .collection('chats')
        .doc(getChatRoomId(currentUserId, otherUserId))
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => ChatMessage.fromJson(doc.data()))
          .toList();
    });
  }

  Future<void> sendMessage(ChatMessage message) async {
    final chatRoomId = getChatRoomId(message.senderId, message.receiverId);
    
    await _firestore
        .collection('chats')
        .doc(chatRoomId)
        .collection('messages')
        .add(message.toJson());

    // Update last message in chat room
    await _firestore.collection('chats').doc(chatRoomId).set({
      'lastMessage': message.message,
      'lastMessageTime': message.timestamp.toIso8601String(),
      'participants': [message.senderId, message.receiverId],
    });
  }

  String getChatRoomId(String userId1, String userId2) {
    return userId1.compareTo(userId2) > 0
        ? '${userId1}_${userId2}'
        : '${userId2}_${userId1}';
  }
}