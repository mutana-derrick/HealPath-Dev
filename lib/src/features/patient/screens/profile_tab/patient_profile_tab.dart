import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healpath/src/features/patient/controllers/patient_profile_controller.dart';
import 'profile_header.dart';
import 'profile_content.dart';
import 'profile_image.dart';

class PatientProfileTab extends StatelessWidget {
  const PatientProfileTab({Key? key}) : super(key: key);

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
                    child: ProfileContent(),
                  ),
                ],
              ),
              Positioned(
                top: 130,
                left: 0,
                right: 0,
                child: ProfileImage(),
              ),
            ],
          ),
        );
      },
    );
  }
}
