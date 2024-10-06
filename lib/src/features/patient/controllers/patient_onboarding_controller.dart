import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:healpath/src/features/authentication/screens/login/login_screen.dart';

class OnboardingController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final pageController = PageController();
  var currentStep = 0.obs;
  var isLoading = false.obs;

  // Form fields
  var age = ''.obs;
  var gender = ''.obs;
  var drugOfChoice = ''.obs;
  var injectionFrequency = ''.obs;
  var hivStatus = ''.obs;
  var needleSharingHistory = ''.obs;

  Future<void> submitOnboardingData() async {
    try {
      isLoading(true);
      final user = _auth.currentUser;
      if (user != null) {
        await _firestore.collection('patients').doc(user.uid).update({
          'age': age.value,
          'gender': gender.value,
          'drugOfChoice': drugOfChoice.value,
          'injectionFrequency': injectionFrequency.value,
          'hivStatus': hivStatus.value,
          'needleSharingHistory': needleSharingHistory.value,
          'onboardingCompleted': true,
        });
        Get.snackbar('Success', 'Onboarding completed successfully!');
        // Navigate to the log in screen
        Get.off(() => LoginScreen());
      }
    } catch (e) {
      Get.snackbar(
          'Error', 'Failed to submit onboarding data: ${e.toString()}');
    } finally {
      isLoading(false);
    }
  }
}
