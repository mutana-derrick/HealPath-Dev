import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:healpath/src/features/patient/controllers/patient_profile_controller.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

void showEditProfileBottomSheet(BuildContext context) {
  final controller = Get.find<PatientProfileController>();
  
  showCupertinoModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setModalState) {
          return Material(
            child: SafeArea(
              top: false,
              child: SingleChildScrollView(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      color: Colors.blue,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: const Center(
                        child: Text(
                          'Edit Profile',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const Divider(height: 1, color: Colors.white),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          _buildTextField('Name', controller.nameController),
                          _buildTextField('Email', controller.emailController),
                          _buildTextField('Phone Number', controller.emergencyContactController),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              ElevatedButton(
                                onPressed: () async {
                                  bool success = await controller.updateUserData();
                                  if (success) {
                                    Navigator.of(context).pop();
                                    _showSuccessSnackBar(context);
                                  } else {
                                    _showErrorSnackBar(context, controller.errorMessage.value);
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                ),
                                child: const Text('Save Changes', style: TextStyle(color: Colors.white)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );
}

Widget _buildTextField(String label, TextEditingController controller) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
        CupertinoTextField(
          placeholder: 'Enter $label',
          controller: controller,
        ),
      ],
    ),
  );
}

void _showSuccessSnackBar(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          Icon(Icons.check_circle, color: Colors.blue[900]),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Profile updated successfully!',
              style: TextStyle(color: Colors.blue[900]),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.lightBlue[100],
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      duration: const Duration(seconds: 3),
    ),
  );
}

void _showErrorSnackBar(BuildContext context, String errorMessage) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          Icon(Icons.error, color: Colors.red[900]),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Error: $errorMessage',
              style: TextStyle(color: Colors.red[900]),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.red[100],
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      duration: const Duration(seconds: 3),
    ),
  );
}