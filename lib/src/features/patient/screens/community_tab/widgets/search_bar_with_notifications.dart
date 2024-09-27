import 'package:flutter/material.dart';
import 'package:healpath/src/features/patient/screens/community_tab/widgets/circle_button.dart';
import 'package:healpath/src/features/authentication/screens/login/login_screen.dart';
import 'package:healpath/src/features/authentication/controllers/logout_controller.dart';
import 'package:get/get.dart';

class SearchBarWithNotifications extends StatelessWidget {
  final VoidCallback onNotificationTap;

  SearchBarWithNotifications({super.key, required this.onNotificationTap}) {
    // Lazy initialization of LogOutController
    Get.lazyPut(() => LogOutController(), fenix: true);
  }

  void _handleLogout() async {
    try {
      final LogOutController logOutController = Get.find<LogOutController>();
      await logOutController.signOut();
      Get.offAll(() => LoginScreen());
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to log out. Please try again.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.black,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: const BoxDecoration(color: Colors.blue),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search Posts and Comments',
                hintStyle: TextStyle(color: Colors.blue.shade900),
                prefixIcon: Icon(Icons.search, color: Colors.blue.shade900),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide:
                      BorderSide(color: Colors.blue.shade900, width: 2.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide:
                      BorderSide(color: Colors.blue.shade900, width: 1.0),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 8),
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: Icon(Icons.notifications, color: Colors.blue.shade900),
            onPressed: onNotificationTap,
          ),
          CircleButton(
            icon: Icons.logout, // Icon for logout
            color: Colors.blue.shade900, // Icon color
            backgroundColor: Colors.blue, // Button background color
            onPressed: _handleLogout, // Action for logout button
          ),
        ],
      ),
    );
  }
}
