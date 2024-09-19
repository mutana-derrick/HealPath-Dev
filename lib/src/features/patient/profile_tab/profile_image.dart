import 'package:flutter/material.dart';
import 'package:healpath/src/features/patient/profile_tab/patient_profile_controller.dart';
import 'edit_profile_bottom_sheet.dart';

class ProfileImage extends StatelessWidget {
  final PatientProfileController controller;
  final BuildContext context;

  const ProfileImage({
    required this.controller,
    required this.context,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          CircleAvatar(
            radius: 60,
            backgroundColor: Colors.blue[900],
            child: CircleAvatar(
              radius: 56,
              backgroundColor: Colors.blue[100],
              child: Text(
                controller.nameController.text[0].toUpperCase(),
                style: const TextStyle(fontSize: 40, color: Colors.blue),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: InkWell(
              onTap: () {
                showEditProfileBottomSheet(context, controller);
              },
              child: CircleAvatar(
                radius: 20,
                backgroundColor: Colors.blue,
                child: Icon(Icons.edit, color: Colors.blue[900], size: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
