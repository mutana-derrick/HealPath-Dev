import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final ValueChanged<int> onTabChange;

  const CustomBottomNavigationBar({super.key, required this.onTabChange});

  @override
  Widget build(BuildContext context) {
    return Container(
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
          backgroundColor: Colors.blue,
          color: Colors.blue[900], // Unselected items color
          activeColor: Colors.white, // Selected items color
          tabBackgroundColor:
              Colors.blue.shade600, // Background color of selected tab
          padding: const EdgeInsets.all(16), // Padding inside the tabs
          gap: 5, // Gap between icon and text
          duration: const Duration(milliseconds: 1000), // Animation duration
          onTabChange: onTabChange, // Handle tab changes
          tabs: const [
            GButton(
              icon: Icons.home_sharp,
              text: "Home",
            ),
            GButton(
              icon: Icons.people_alt_sharp,
              text: "Patients",
            ),
            GButton(
              icon: Icons.chat,
              text: "Community",
            ),
            GButton(
              icon: Icons.person,
              text: "Profile",
            ),
          ],
        ),
      ),
    );
  }
}
