import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healpath/src/features/doctor/models/message_bubble.dart';
import 'package:healpath/src/features/patient/controllers/chat_controller.dart';
import 'package:healpath/src/features/patient/models/models.dart';

class DoctorChatScreen extends StatelessWidget {
  final String patientId;
  final String patientName;
  final String doctorId;
  final chatController = Get.put(ChatController());
  final TextEditingController messageController = TextEditingController();

  DoctorChatScreen({
    required this.patientId,
    required this.patientName,
    required this.doctorId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat with $patientName'),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<ChatMessage>>(
              stream: chatController.getMessages(doctorId, patientId),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final messages = snapshot.data!;
                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final isMe = message.senderId == doctorId;

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
                        senderId: doctorId,
                        receiverId: patientId,
                        message: messageController.text.trim(),
                        timestamp: DateTime.now(),
                        senderRole: 'doctor',
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
  }
}
