import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final ValueChanged<int> onTabChange;

  const CustomBottomNavigationBar({super.key, required this.onTabChange});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: GNav(
          backgroundColor: Colors.blue,
          color: Colors.blue[900],
          activeColor: Colors.white,
          tabBackgroundColor: Colors.blue.shade600,
          padding: const EdgeInsets.all(16),
          gap: 5,
          onTabChange: onTabChange,
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
