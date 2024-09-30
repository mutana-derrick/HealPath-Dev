import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore for fetching user data
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class DoctorController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  RxString doctorName = ''.obs;
  RxBool isLoading = true.obs;
  RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchDoctorName();
  }

  Future<void> fetchDoctorName() async {
    try {
      isLoading.value = true;
      User? currentUser = _auth.currentUser;
      if (currentUser != null) {
        // Fetch doctor's document from Firestore
        DocumentSnapshot userDoc =
            await _firestore.collection('users').doc(currentUser.uid).get();

        if (userDoc.exists) {
          doctorName.value = userDoc['fullName'] ??
              'Doctor'; // Replace with the correct field in Firestore
        } else {
          errorMessage.value = 'User document does not exist';
        }
      } else {
        errorMessage.value = 'No user is logged in';
      }
    } catch (e) {
      errorMessage.value = 'Error fetching doctor name: $e';
    } finally {
      isLoading.value = false;
    }
  }
}
