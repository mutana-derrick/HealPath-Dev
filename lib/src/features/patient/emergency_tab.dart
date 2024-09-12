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
                  _buildEmergencyCard(controller),
                  const SizedBox(height: 20),
                  _buildInfoSection(),
                  const SizedBox(height: 20),
                  _buildEmergencyContacts(controller, context), // Pass context here
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmergencyCard(PatientEmergencyController controller) {
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

  Widget _buildInfoSection() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            const ListTile(
              leading: Icon(Icons.info_outline, color: Colors.blue),
              title: Text('When to Call Emergency'),
              subtitle: Text('Call immediately if you experience:'),
            ),
            const SizedBox(height: 10),
            _buildInfoItem('Severe chest pain or difficulty breathing'),
            _buildInfoItem('Sudden severe headache or loss of consciousness'),
            _buildInfoItem('Uncontrolled bleeding'),
            _buildInfoItem('Severe allergic reaction'),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Colors.green, size: 20),
          const SizedBox(width: 10),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }

  Widget _buildEmergencyContacts(PatientEmergencyController controller, BuildContext context) {
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
                onPressed: () => controller.openKigali(context), // Pass context here
              ),
            ),
            ListTile(
              title: const Text('CARAES Butare'),
              subtitle: Text(controller.butare),
              trailing: IconButton(
                icon: const Icon(Icons.map, color: Colors.blue),
                onPressed: () => controller.openButare(context), // Pass context here
              ),
            )
          ],
        ),
      ),
    );
  }
}

class PatientEmergencyController extends GetxController {
  final String emergencyNumber = '+1234567890'; // Replace with actual emergency number
  final String kigali = 'NNPTH-Icyizere Psychotherapeutic Center, Kigali'; // Replace with actual hospital name
  final String butare = 'Caraes Butare';

  void callEmergency() async {
    final Uri url = Uri(scheme: 'tel', path: emergencyNumber);
    await launchUrl(url);
  }

  void openKigali(BuildContext context) async {
    final String kigaliQuery = Uri.encodeComponent(kigali);
    final Uri kigaliurl = Uri.parse('https://www.google.com/maps/search/?api=1&query=$kigaliQuery');
    final bool kigalilaunched = await launchUrl(kigaliurl, mode: LaunchMode.externalApplication);

    if (!kigalilaunched) {
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Open Map'),
          content: const Text('Confirm to open the following link in your web browser:'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
                launchUrl(
                  Uri.parse('https://www.google.com/maps/place/NNPTH-Icyizere+Psychotherapeutic+Center/@-1.9732625,30.1163281,15z/'),
                  mode: LaunchMode.externalApplication,
                );
              },
              child: const Text('Open in Web Browser'),
            ),
          ],
        ),
      );
    }
  }
  void openButare(BuildContext context) async {
    final String butareQuery = Uri.encodeComponent(butare);
    final Uri butareurl = Uri.parse('https://www.google.com/maps/search/?api=1&query=$butareQuery');
    final bool butarelaunched = await launchUrl(butareurl, mode: LaunchMode.externalApplication);

    if (!butarelaunched) {
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Open Map'),
          content: const Text('Confirm to open the following link in your web browser:'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
                launchUrl(
                  Uri.parse('https://www.google.com/maps/place/CARAES Butare/'),
                  mode: LaunchMode.externalApplication,
                );
              },
              child: const Text('Open in Web Browser'),
            ),
          ],
        ),
      );
    }
  }
}
