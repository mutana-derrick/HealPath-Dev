import 'package:flutter/material.dart';
import 'package:healpath/src/features/authentication/controllers/logout_controller.dart';
import 'package:healpath/src/features/authentication/screens/login/login_screen.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'package:healpath/src/features/doctor/screens/circle_button.dart'; // Custom CircleButton widget
import 'package:get/get.dart';

class UpperBar extends StatelessWidget {
  UpperBar({super.key}) {
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
    // Format today's date as 'MMM / d / yyyy' (e.g., "Sep / 11 / 2024")
    final String formattedDate =
        DateFormat('MMM / d / yyyy').format(DateTime.now());

    return Container(
      // Padding for the content inside the bar
      padding: const EdgeInsets.only(top: 55, left: 20, right: 20),
      height: 200,
      width: double.infinity,
      // Decoration for the upper bar with rounded corners, shadow, and gradient
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color:
                Colors.black.withOpacity(0.2), // Shadow color with some opacity
            spreadRadius: 5, // Spread of the shadow
            blurRadius: 10, // Blur effect for shadow
            offset: const Offset(2, 3), // Offset position of the shadow
          ),
        ],
        // Gradient for the background color from dark blue to light blue
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: const [0.1, 0.5],
          colors: [
            Colors.blue[500]!, // Darker blue
            Colors.blue[400]!, // Lighter blue
          ],
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween, // Space out the content
            crossAxisAlignment:
                CrossAxisAlignment.start, // Align items to the start
            children: [
              // Greeting text "Hello, Dr Kwizigira"
              Text(
                "Hello,\nDr Kwizigira",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.white), // White text color for the greeting
              ),
              Column(
                children: [
                  // Notification button using CircleButton custom widget
                  CircleButton(
                    icon: Icons.logout, // Icon for logout
                    color: Colors.blue.shade900, // Icon color
                    backgroundColor:
                        Colors.blue.shade400, // Button background color
                    onPressed: _handleLogout, // Action for logout button
                  ),
                  const SizedBox(height: 8), // Space between button and date
                  // Dynamic date text to display the formatted current date
                  Text(
                    formattedDate, // Use the dynamically formatted date
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.blueGrey[900]), // Date text color
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
