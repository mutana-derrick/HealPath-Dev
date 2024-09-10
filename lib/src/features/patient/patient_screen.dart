import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
          body: IndexedStack(
            index: controller.tabIndex,
            children: const [
              PatientCommunityTab(),
              PatientProgressTab(),
              PatientEmergencyTab(),
              PatientProfileTab()
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: controller.tabIndex,
            onTap: controller.changeTabIndex,
            type: BottomNavigationBarType.fixed,
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(Icons.group), label: 'Community'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.trending_up), label: 'Progress'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.emergency), label: 'Emergency'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.person), label: 'Profile'),
            ],
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
    update();
  }
}
