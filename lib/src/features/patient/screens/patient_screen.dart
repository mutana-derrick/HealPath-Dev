import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart'; // Import the GNav package
import 'package:healpath/src/features/patient/screens/community_tab/patient_community_tab.dart';
import 'package:healpath/src/features/patient/screens/emergency_tab/patient_emergency_tab.dart';
import 'package:healpath/src/features/patient/screens/patient_chat_screen.dart';
import 'package:healpath/src/features/patient/screens/profile_tab/patient_profile_tab.dart';

class PatientScreen extends StatelessWidget {
  const PatientScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PatientNavigationController>(
      init: PatientNavigationController(),
      builder: (controller) {
        return Scaffold(
          body: SafeArea(
            child: IndexedStack(
              index: controller.tabIndex,
              children: [
                PatientCommunityTab(),
                PatientEmergencyTab(),
                PatientChatScreen(),
                PatientProfileTab()
              ],
            ),
          ),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              color: Colors.blue, // Background color for the nav bar
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5), // Shadow color
                  spreadRadius: 1, // Spread of the shadow
                  blurRadius: 10, // Softness of the shadow
                  offset: const Offset(0, -3), // Position of the shadow (X,Y)
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: GNav(
                backgroundColor:
                    Colors.blue, // Background of the navigation bar
                color: Colors.blue[900], // Color of unselected items
                activeColor: Colors.white, // Color of selected items
                tabBackgroundColor:
                    Colors.blue.shade600, // Background color of selected tab
                padding: const EdgeInsets.all(16), // Padding inside the tabs
                gap: 5, // Gap between icon and text
                selectedIndex: controller.tabIndex, // Current selected index
                onTabChange:
                    controller.changeTabIndex, // Function to handle tab changes
                tabs: const [
                  GButton(
                    icon: Icons.group,
                    text: 'Community',
                  ),
                  GButton(
                    icon: Icons.emergency,
                    text: 'Emergency',
                  ),
                  GButton(
                    icon: Icons.chat,
                    text: 'Messages',
                  ),
                  GButton(
                    icon: Icons.person,
                    text: 'Profile',
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class PatientNavigationController extends GetxController {
  var tabIndex = 0;

  void changeTabIndex(int index) {
    tabIndex = index;
    update(); // Updates the UI when the tab index changes
  }
}
