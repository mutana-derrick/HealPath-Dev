import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:healpath/src/features/doctor/screens/bottom_navigation_bar.dart';
import 'package:healpath/src/features/doctor/screens/community_tab/community_tab.dart';
import 'package:healpath/src/features/doctor/screens/doctor_chat_list_screen.dart';
import 'package:healpath/src/features/doctor/screens/overview_tab.dart';
import 'package:healpath/src/features/doctor/screens/patient_tab/patients_tab.dart';
import 'package:healpath/src/features/doctor/screens/profile_tab/profile_tab.dart';
import 'package:healpath/src/features/doctor/screens/upper_bar.dart';

class DoctorDashboardScreen extends StatefulWidget {
  const DoctorDashboardScreen({super.key});

  @override
  State createState() => _DoctorDashboardScreenState();
}

class _DoctorDashboardScreenState extends State {
  final RxInt _selectedIndex = 0.obs;
  final Rx _doctorId = Rx(null);
  final _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _getCurrentDoctor();
  }

  Future _getCurrentDoctor() async {
    final user = _auth.currentUser;
    if (user != null) {
      _doctorId.value = user.uid;
    } else {
      // Handle the case when user is not logged in
      Get.offAllNamed('/login'); // Adjust this to your login route
    }
  }

  List<Widget> _buildPages() {
    // Explicitly define List<Widget>
    if (_doctorId.value == null) {
      return List.generate(
          5, (_) => const Center(child: CircularProgressIndicator()));
    }

    return [
      OverviewTab(),
      PatientsTab(),
      DoctorChatListScreen(doctorId: _doctorId.value!), // Move chat list here
      const CommunityTab(),
      const ProfileTab(), // Put profile tab in the correct position
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(160.0),
        child: UpperBar(),
      ),
      body: Obx(
        () => IndexedStack(
          index: _selectedIndex.value,
          children: _buildPages(),
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
