// lib/tabs/patient_profile_tab.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PatientProfileTab extends StatelessWidget {
  const PatientProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PatientProfileController>(
      init: PatientProfileController(),
      builder: (controller) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(controller.profileImageUrl),
                ),
              ),
              const SizedBox(height: 20),
              _buildTextField('Name', controller.nameController),
              _buildTextField('Email', controller.emailController),
              _buildTextField('Phone', controller.phoneController),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: controller.updateProfile,
                  child: const Text('Update Profile'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}

class PatientProfileController extends GetxController {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  String profileImageUrl = 'https://example.com/default-profile-image.jpg';

  @override
  void onInit() {
    super.onInit();
    // In a real app, you'd fetch this data from your backend
    nameController.text = 'John Doe';
    emailController.text = 'john.doe@example.com';
    phoneController.text = '+1234567890';
  }

  void updateProfile() {
    // In a real app, you'd send this data to your backend
    Get.snackbar('Success', 'Profile updated successfully');
  }
}