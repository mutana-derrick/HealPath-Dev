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

  // Validation
  bool get isCurrentStepValid {
    switch (currentStep.value) {
      case 0:
        return drugOfChoice.isNotEmpty;
      case 1:
        return injectionFrequency.isNotEmpty;
      case 2:
        return hivStatus.isNotEmpty;
      case 3:
        return needleSharingHistory.isNotEmpty;
      default:
        return false;
    }
  }

  bool get isFormValid {
    return drugOfChoice.isNotEmpty &&
        injectionFrequency.isNotEmpty &&
        hivStatus.isNotEmpty &&
        needleSharingHistory.isNotEmpty;
  }

  void nextPage() {
    if (isCurrentStepValid) {
      if (currentStep.value < 3) {
        pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      } else if (isFormValid) {
        submitOnboardingData();
      }
    } else {
      Get.snackbar('Error', 'Please answer the current question before proceeding.');
    }
  }

  Future<void> submitOnboardingData() async {
    if (!isFormValid) {
      Get.snackbar('Error', 'Please answer all questions before submitting.');
      return;
    }

    try {
      isLoading(true);
      final user = _auth.currentUser;
      if (user != null) {
        await _firestore.collection('patients').doc(user.uid).update({
          'drugOfChoice': drugOfChoice.value,
          'injectionFrequency': injectionFrequency.value,
          'hivStatus': hivStatus.value,
          'needleSharingHistory': needleSharingHistory.value,
          'onboardingCompleted': true,
        });
        Get.snackbar('Success', 'Onboarding completed successfully!');
        Get.off(() => LoginScreen());
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to submit onboarding data: ${e.toString()}');
    } finally {
      isLoading(false);
    }
  }
}