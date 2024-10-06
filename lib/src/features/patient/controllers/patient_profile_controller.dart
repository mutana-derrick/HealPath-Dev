import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PatientProfileController extends GetxController {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final emergencyContactController = TextEditingController();
  final usernameController = TextEditingController();

  final RxBool isLoading = true.obs;
  final RxBool hasError = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      isLoading.value = true;
      hasError.value = false;
      errorMessage.value = '';

      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final userData = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (userData.exists) {
          nameController.text = userData['fullName'] ?? '';
          emailController.text = userData['email'] ?? '';
          emergencyContactController.text = userData['phoneNumber'] ?? '';
          usernameController.text = userData['fullName']?.split(' ')[0] ?? '';
        } else {
          throw Exception('User data not found');
        }
      } else {
        throw Exception('User not authenticated');
      }
    } catch (e) {
      hasError.value = true;
      errorMessage.value = 'Error fetching user data: $e';
      print(errorMessage.value);
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> updateUserData() async {
    try {
      isLoading.value = true;
      hasError.value = false;
      errorMessage.value = '';

      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
          'fullName': nameController.text.trim(),
          'email': emailController.text.trim(),
          'phoneNumber': emergencyContactController.text.trim(),
        });
        await fetchUserData();
        return true;
      } else {
        throw Exception('User not authenticated');
      }
    } catch (e) {
      hasError.value = true;
      errorMessage.value = 'Error updating user data: $e';
      print(errorMessage.value);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    emergencyContactController.dispose();
    usernameController.dispose();
    super.onClose();
  }
}