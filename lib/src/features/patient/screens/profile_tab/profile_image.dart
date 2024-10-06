import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healpath/src/features/patient/controllers/patient_profile_controller.dart';
import 'edit_profile_bottom_sheet.dart';

class ProfileImage extends GetWidget<PatientProfileController> {
  const ProfileImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }
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
                  controller.nameController.text.isNotEmpty
                      ? controller.nameController.text[0].toUpperCase()
                      : '',
                  style: const TextStyle(fontSize: 40, color: Colors.blue),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: InkWell(
                onTap: () {
                  showEditProfileBottomSheet(context);
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
    });
  }
}