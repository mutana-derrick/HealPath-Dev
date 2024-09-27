import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class LogOutController extends GetxController {
  
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw Exception('Failed to sign out');
    }
  }
}
