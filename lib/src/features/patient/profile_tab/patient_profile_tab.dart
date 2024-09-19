import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healpath/src/features/patient/profile_tab/patient_profile_controller.dart';
import 'package:healpath/src/features/patient/profile_tab/profile_content.dart';
import 'package:healpath/src/features/patient/profile_tab/profile_header.dart';
import 'package:healpath/src/features/patient/profile_tab/profile_image.dart';


class PatientProfileTab extends StatelessWidget {
  const PatientProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PatientProfileController>(
      init: PatientProfileController(),
      builder: (controller) {
        return Scaffold(
          body: Stack(
            children: [
              Column(
                children: [
                  ProfileHeader(),
                  Expanded(
                    child: ProfileContent(controller: controller),
                  ),
                ],
              ),
              Positioned(
                top: 130,
                left: 0,
                right: 0,
                child: ProfileImage(controller: controller, context: context),
              ),
            ],
          ),
        );
      },
    );
  }
}
