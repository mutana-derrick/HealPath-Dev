import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:healpath/src/features/patient/screens/patient_onboarding_screen.dart';

class SignUpController extends GetxController {
  // Firebase instances
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Trackers
  var isLoading = false.obs;
  var selectedFileName = ''.obs;
  var isPasswordVisible = false.obs; // Password visibility tracker

    /// Function to handle patient sign-up
  Future<void> signUpPatient(String email, String password, String fullName,
      String phoneNumber, DateTime dateOfBirth, String gender, PlatformFile? file) async {
    try {
      isLoading(true);

      // Check if age is above 18
      final age = DateTime.now().difference(dateOfBirth).inDays ~/ 365;
      if (age < 18) {
        throw Exception("You must be at least 18 years old to sign up.");
      }

      // Firebase Authentication
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      String fileUrl = '';
      if (file != null) {
        fileUrl = await _uploadFile(file, userCredential.user!.uid);
      }

      // Get FCM token
      String? fcmToken = await getFCMToken();

      // Create user document
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'email': email,
        'fullName': fullName,
        'phoneNumber': phoneNumber,
        'dateOfBirth': dateOfBirth,
        'gender': gender,
        'role': 'patient',
        'status': 'Active',
        'createdAt': DateTime.now(),
        'fcmToken': fcmToken,
      });

      // Create patient document
      await _firestore
          .collection('patients')
          .doc(userCredential.user!.uid)
          .set({
        'userId': userCredential.user!.uid,
        'dischargeSummaryUrl': fileUrl,
        'treatmentPlanId': null,
        'satisfaction': 0,
        'onboardingCompleted': false,
        'createdAt': DateTime.now(),
      });

      _showSnackBar("Success", "Account created successfully!", true);

      // Navigate to the onboarding screen
      Get.off(() => PatientOnboardingScreen());
    } catch (e) {
      _showSnackBar("Error", e.toString(), false);
    } finally {
      isLoading(false);
    }
  }

  /// Private function to handle file upload to Firebase Storage
  Future<String> _uploadFile(PlatformFile? file, String userId) async {
    try {
      if (file == null || file.bytes == null) return '';

      // Use putData for uploading Uint8List
      UploadTask uploadTask = _storage
          .ref('discharge_summaries/$userId/${file.name}')
          .putData(file.bytes!);

      TaskSnapshot snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      // Log or handle upload error
      _showSnackBar("Error", "File upload failed: ${e.toString()}", false);
      return '';
    }
  }

  /// Toggles password visibility
  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  /// Custom method to show snackbar
  void _showSnackBar(String title, String message, bool isSuccess) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: isSuccess ? Colors.lightBlue[100] : Colors.red[100],
      colorText: isSuccess ? Colors.blue[900] : Colors.red[900],
      borderRadius: 10,
      margin: EdgeInsets.all(15),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      duration: Duration(seconds: 4),
      icon: Icon(
        isSuccess ? Icons.check_circle : Icons.error,
        color: isSuccess ? Colors.blue[900] : Colors.red[900],
      ),
      shouldIconPulse: false,
      snackStyle: SnackStyle.FLOATING,
    );
  }

  Future<String?> getFCMToken() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    String? token = await messaging.getToken();
    return token;
  }
}