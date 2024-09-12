import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart'; // Import the GNav package
import 'package:healpath/src/features/patient/community_tab.dart';
import 'package:healpath/src/features/patient/emergency_tab.dart';
import 'package:healpath/src/features/patient/profile_tab.dart';
import 'package:healpath/src/features/patient/progress_tab.dart';

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
              children: const [
                PatientCommunityTab(),
                PatientProgressTab(),
                PatientEmergencyTab(),
                PatientProfileTab()
              ],
            ),
          ),
          bottomNavigationBar: Container(
            color: Colors.blue, // Background color for the nav bar
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
                    icon: Icons.trending_up,
                    text: 'Progress',
                  ),
                  GButton(
                    icon: Icons.emergency,
                    text: 'Emergency',
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
