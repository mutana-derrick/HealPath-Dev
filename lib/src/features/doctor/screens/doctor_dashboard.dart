import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healpath/src/features/doctor/screens/bottom_navigation_bar.dart';
import 'package:healpath/src/features/doctor/screens/community_tab/community_tab.dart';
import 'package:healpath/src/features/doctor/screens/overview_tab.dart';
import 'package:healpath/src/features/doctor/screens/patient_tab/patients_tab.dart';
import 'package:healpath/src/features/doctor/screens/profile_tab/profile_tab.dart';
import 'package:healpath/src/features/doctor/screens/upper_bar.dart';

class DoctorDashboardScreen extends StatefulWidget {
  const DoctorDashboardScreen({super.key});

  @override
  State<DoctorDashboardScreen> createState() => _DoctorDashboardScreenState();
}

class _DoctorDashboardScreenState extends State<DoctorDashboardScreen> {
  // Using GetX to manage the selected index of the bottom navigation bar
  final RxInt _selectedIndex = 0.obs;

  // List of content widgets corresponding to each tab
  final List<Widget> _pages = [
    const OverviewTab(),
    const PatientsTab(),
    const CommunityTab(),
    const ProfileTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Upper bar at the top of the screen
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(160.0), // Adjust the height as needed
        child: UpperBar(),
      ),
      body: Obx(
        () => IndexedStack(
          index: _selectedIndex.value,
          children: _pages,
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        onTabChange: (index) {
          _selectedIndex.value = index;
        },
      ),
    );
  }
}
