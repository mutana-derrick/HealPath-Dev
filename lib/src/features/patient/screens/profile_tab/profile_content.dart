import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healpath/src/features/patient/controllers/patient_profile_controller.dart';

class ProfileContent extends GetWidget<PatientProfileController> {
  const ProfileContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }
      return SingleChildScrollView(
        padding: const EdgeInsets.only(top: 100, left: 20, right: 20),
        child: Column(
          children: [
            _buildInfoField('Full Name', controller.nameController.text),
            _buildInfoField('Email', controller.emailController.text),
            _buildInfoField(
                'Phone Number', controller.emergencyContactController.text),
            const SizedBox(height: 20),
          ],
        ),
      );
    });
  }

  Widget _buildInfoField(String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black54,
            ),
          ),
          Text(
            value,
            style: const TextStyle(color: Colors.black87),
          ),
        ],
      ),
    );
  }
}
