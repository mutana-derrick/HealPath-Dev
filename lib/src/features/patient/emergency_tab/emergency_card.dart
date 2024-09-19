import 'package:flutter/material.dart';
import 'patient_emergency_controller.dart';

class EmergencyCard extends StatelessWidget {
  final PatientEmergencyController controller;

  const EmergencyCard({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Icon(Icons.emergency, size: 60, color: Colors.red),
            const SizedBox(height: 20),
            const Text(
              'In case of emergency,\npress the button below',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: controller.callEmergency,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text('Emergency Call', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}