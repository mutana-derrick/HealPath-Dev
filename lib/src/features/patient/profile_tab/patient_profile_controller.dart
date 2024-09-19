import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PatientProfileController extends GetxController {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final emergencyContactController = TextEditingController();  // Updated
  final usernameController = TextEditingController();          // Updated

  @override
  void onInit() {
    super.onInit();
    nameController.text = 'John Doe';
    emailController.text = 'john.doe@example.com';
    emergencyContactController.text = '+1 (555) 123-4567';    // Updated
    usernameController.text = 'johndoe';                      // Updated
  }
}
