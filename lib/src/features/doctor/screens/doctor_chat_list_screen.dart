import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:healpath/src/features/doctor/screens/doctor_chat_screen.dart';

class DoctorChatListScreen extends StatelessWidget {
  final String doctorId;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  DoctorChatListScreen({required this.doctorId, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Patient Messages'),
        backgroundColor: Colors.blue,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('chats')
            .where('participants', arrayContains: doctorId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final chatRooms = snapshot.data!.docs;

          if (chatRooms.isEmpty) {
            return const Center(
              child: Text(
                'No messages yet',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          return ListView.builder(
            itemCount: chatRooms.length,
            itemBuilder: (context, index) {
              final chatRoom = chatRooms[index].data() as Map<String, dynamic>;
              final participants = chatRoom['participants'] as List<dynamic>;
              final patientId = participants.firstWhere((id) => id != doctorId);

              return FutureBuilder<DocumentSnapshot>(
                future: _firestore.collection('users').doc(patientId).get(),
                builder: (context, patientSnapshot) {
                  if (!patientSnapshot.hasData) {
                    return const ListTile(
                      title: Text('Loading...'),
                    );
                  }

                  final patientData = patientSnapshot.data!.data() as Map<String, dynamic>;
                  final patientName = patientData['fullName'] ?? 'Unknown Patient';

                  return ListTile(
                    leading: const CircleAvatar(
                      child: Icon(Icons.person),
                    ),
                    title: Text(patientName),
                    subtitle: Text(chatRoom['lastMessage'] ?? 'No messages yet'),
                    trailing: Text(
                      _formatDateTime(DateTime.parse(chatRoom['lastMessageTime'] ?? DateTime.now().toIso8601String())),
                    ),
                    onTap: () {
                      Get.to(() => DoctorChatScreen(
                            patientId: patientId,
                            patientName: patientName,
                            doctorId: doctorId,
                          ));
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    if (dateTime.day == now.day && dateTime.month == now.month && dateTime.year == now.year) {
      return '${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
    }
    return '${dateTime.day}/${dateTime.month}';
  }
}