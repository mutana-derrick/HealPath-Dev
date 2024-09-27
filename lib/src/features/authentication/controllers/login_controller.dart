import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:healpath/src/features/doctor/screens/doctor_dashboard.dart';

class LoginController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  var isLoading = false.obs;
  var isPasswordVisible = false.obs;

  Future<void> login(String email, String password) async {
    try {
      isLoading(true);

      // ignore: unused_local_variable
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      _showSnackBar("Success", "Logged in successfully!", true);

      // Navigate to dashboard
      Get.off(() => DoctorDashboardScreen());
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      if (e.code == 'user-not-found') {
        errorMessage = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Wrong password provided for that user.';
      } else {
        errorMessage = e.message ?? 'An error occurred. Please try again.';
      }
      _showSnackBar("Error", errorMessage, false);
    } catch (e) {
      _showSnackBar("Error", e.toString(), false);
    } finally {
      isLoading(false);
    }
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

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
