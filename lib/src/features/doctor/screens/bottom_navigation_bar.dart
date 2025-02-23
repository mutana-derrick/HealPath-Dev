import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final ValueChanged onTabChange;

  const CustomBottomNavigationBar({super.key, required this.onTabChange});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: GNav(
          backgroundColor: Colors.blue,
          color: Colors.blue[900],
          activeColor: Colors.white,
          tabBackgroundColor: Colors.blue.shade600,
          padding: const EdgeInsets.all(16),
          gap: 5,
          duration: const Duration(milliseconds: 1000),
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
              text: "Messages", // Changed from "Community" to "Messages"
            ),
            GButton(
              icon: Icons.groups, // Changed from chat to groups
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
