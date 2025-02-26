import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:healpath/src/features/doctor/screens/doctor_dashboard.dart';
import 'package:healpath/src/features/patient/screens/patient_screen.dart';

class LoginController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  var isLoading = false.obs;
  var isPasswordVisible = false.obs;

  Future<void> login(String email, String password) async {
    try {
      isLoading(true);

      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      // Fetch user role from Firestore
      DocumentSnapshot userDoc = await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();

      if (userDoc.exists) {
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
        String userRole = userData['role'] ?? '';

        // Update FCM token
        String? fcmToken = await getFCMToken();
        if (fcmToken != null) {
          await updateFCMToken(userCredential.user!.uid, fcmToken);
        }

        _showSnackBar("Success", "Logged in successfully!", true);

        // Navigate based on user role
        if (userRole == 'patient') {
          Get.off(() => PatientScreen());
        } else if (userRole == 'doctor') {
          Get.off(() => DoctorDashboardScreen());
        } else {
          _showSnackBar("Error", "Invalid user role", false);
        }
      } else {
        _showSnackBar("Error", "User data not found", false);
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      if (e.code == 'user-not-found') {
        errorMessage = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Wrong credentials.';
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

  Future<String?> getFCMToken() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    String? token = await messaging.getToken();
    return token;
  }

  Future<void> updateFCMToken(String userId, String token) async {
    try {
      await _firestore.collection('users').doc(userId).update({'fcmToken': token});
      print('FCM Token updated successfully');
    } catch (e) {
      print('Error updating FCM Token: $e');
    }
  }
}