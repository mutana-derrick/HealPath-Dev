// patient_chat_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:healpath/src/features/doctor/models/message_bubble.dart';
import 'package:healpath/src/features/patient/controllers/chat_controller.dart';
import 'package:healpath/src/features/patient/models/models.dart';

class PatientChatScreen extends StatelessWidget {
  final chatController = Get.put(ChatController());
  final TextEditingController messageController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String patientId;

  PatientChatScreen({Key? key})
      : patientId = FirebaseAuth.instance.currentUser?.uid ?? '',
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      // Query to get the doctor's document
      future: _firestore
          .collection('users')
          .where('role', isEqualTo: 'doctor')
          .limit(1)
          .get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError ||
            !snapshot.hasData ||
            snapshot.data!.docs.isEmpty) {
          return const Scaffold(
            body: Center(child: Text('Unable to connect with doctor')),
          );
        }

        final doctorDoc = snapshot.data!.docs.first;
        final doctorData = doctorDoc.data() as Map<String, dynamic>;
        final doctorId = doctorDoc.id;
        final doctorName = doctorData['fullName'] ?? 'Doctor';

        return Scaffold(
          appBar: AppBar(
            title: Text('Chat with Dr. $doctorName'),
            backgroundColor: Colors.blue,
            automaticallyImplyLeading: false,
          ),
          body: Column(
            children: [
              Expanded(
                child: StreamBuilder<List<ChatMessage>>(
                  stream: chatController.getMessages(patientId, doctorId),
                  builder: (context, chatSnapshot) {
                    if (chatSnapshot.hasError) {
                      return Center(
                          child: Text('Error: ${chatSnapshot.error}'));
                    }

                    if (!chatSnapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final messages = chatSnapshot.data!;

                    if (messages.isEmpty) {
                      return const Center(
                        child: Text(
                          'No messages yet. Start a conversation!',
                          style: TextStyle(color: Colors.grey),
                        ),
                      );
                    }

                    return ListView.builder(
                      reverse: true,
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final message = messages[index];
                        final isMe = message.senderId == patientId;

                        return MessageBubble(
                          message: message.message,
                          isMe: isMe,
                          timestamp: message.timestamp,
                        );
                      },
                    );
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      offset: const Offset(0, -2),
                      blurRadius: 4,
                      color: Colors.black.withOpacity(0.1),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: messageController,
                        decoration: const InputDecoration(
                          hintText: 'Type your message...',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.send, color: Colors.blue),
                      onPressed: () {
                        if (messageController.text.trim().isNotEmpty) {
                          final message = ChatMessage(
                            senderId: patientId,
                            receiverId: doctorId,
                            message: messageController.text.trim(),
                            timestamp: DateTime.now(),
                            senderRole: 'patient',
                          );
                          chatController.sendMessage(message);
                          messageController.clear();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
