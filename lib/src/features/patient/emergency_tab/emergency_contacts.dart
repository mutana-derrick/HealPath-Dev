import 'package:flutter/material.dart';
import 'patient_emergency_controller.dart';

class EmergencyContacts extends StatelessWidget {
  final PatientEmergencyController controller;

  const EmergencyContacts({Key? key, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            const ListTile(
              leading: Icon(Icons.phone, color: Colors.green),
              title: Text('Emergency Contacts'),
            ),
            ListTile(
              title: const Text('Emergency Hotline'),
              subtitle: Text(controller.emergencyNumber),
              trailing: IconButton(
                icon: const Icon(Icons.call, color: Colors.green),
                onPressed: controller.callEmergency,
              ),
            ),
            ListTile(
              title: const Text('Icyizere Psychotherapeutic Center'),
              subtitle: Text(controller.kigali),
              trailing: IconButton(
                icon: const Icon(Icons.map, color: Colors.blue),
                onPressed: () => controller.openKigali(context),
              ),
            ),
            ListTile(
              title: const Text('CARAES Butare'),
              subtitle: Text(controller.butare),
              trailing: IconButton(
                icon: const Icon(Icons.map, color: Colors.blue),
                onPressed: () => controller.openButare(context),
              ),
            )
          ],
        ),
      ),
    );
  }
}
