import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:healpath/src/features/authentication/screens/login/login_screen.dart';

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
      String phoneNumber, PlatformFile? file) async {
    try {
      // Start loading
      isLoading(true);

      // Firebase Authentication
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      // Upload discharge summary file if it exists
      String fileUrl = '';
      if (file != null) {
        fileUrl = await _uploadFile(file, userCredential.user!.uid);
      }

      // Store user data in Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'email': email,
        'fullName': fullName,
        'phoneNumber': phoneNumber,
        'role': 'patient',
        'dischargeSummaryUrl': fileUrl,
        'createdAt': DateTime.now(),
      });

      // Show success message
      _showSnackBar("Success", "Account created successfully!", true);

      // Navigate to login screen after a short delay
      Future.delayed(Duration(seconds: 2), () {
        Get.off(() =>
            LoginScreen()); // Replace with your actual login screen widget
      });
    } catch (e) {
      // Error handling
      _showSnackBar("Error", e.toString(), false);
    } finally {
      // Stop loading
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
}
