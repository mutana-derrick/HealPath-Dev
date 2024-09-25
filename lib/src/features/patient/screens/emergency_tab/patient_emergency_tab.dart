import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/patient_emergency_controller.dart';
import 'emergency_card.dart';
import 'info_section.dart';
import 'emergency_contacts.dart';

class PatientEmergencyTab extends StatelessWidget {
  const PatientEmergencyTab({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PatientEmergencyController>(
      init: PatientEmergencyController(),
      builder: (controller) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.red.shade50, Colors.white],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: ListView(
                children: [
                  const Text(
                    'Emergency Services',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  EmergencyCard(controller: controller),
                  const SizedBox(height: 20),
                  const InfoSection(),
                  const SizedBox(height: 20),
                  EmergencyContacts(controller: controller),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}