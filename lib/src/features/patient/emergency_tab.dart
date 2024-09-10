// lib/tabs/patient_emergency_tab.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class PatientEmergencyTab extends StatelessWidget {
  const PatientEmergencyTab({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PatientEmergencyController>(
      init: PatientEmergencyController(),
      builder: (controller) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: controller.callEmergency,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                ),
                child: const Text('Emergency Call',
                    style: TextStyle(fontSize: 20)),
              ),
              const SizedBox(height: 20),
              const Text(
                  'In case of emergency, press the button above to call your doctor.'),
              const SizedBox(height: 20),
              Text('Emergency Hotline: ${controller.emergencyNumber}'),
            ],
          ),
        );
      },
    );
  }
}

class PatientEmergencyController extends GetxController {
  final String emergencyNumber =
      '+1234567890'; // Replace with actual emergency number

  void callEmergency() async {
    final url = 'tel:$emergencyNumber';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      Get.snackbar('Error', 'Could not launch emergency call');
    }
  }
}
