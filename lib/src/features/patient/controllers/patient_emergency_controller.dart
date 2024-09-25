import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class PatientEmergencyController extends GetxController {
  final String emergencyNumber = '0781312344'; // Replace with actual emergency number
  final String kigali = 'NNPTH-Icyizere Psychotherapeutic Center, Kigali';
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
      _showMapDialog(context, 'https://www.google.com/maps/place/NNPTH-Icyizere+Psychotherapeutic+Center/@-1.9732625,30.1163281,15z/');
    }
  }

  void openButare(BuildContext context) async {
    final String butareQuery = Uri.encodeComponent(butare);
    final Uri butareurl = Uri.parse('https://www.google.com/maps/search/?api=1&query=$butareQuery');
    final bool butarelaunched = await launchUrl(butareurl, mode: LaunchMode.externalApplication);

    if (!butarelaunched) {
      _showMapDialog(context, 'https://www.google.com/maps/place/CARAES Butare/');
    }
  }

  void _showMapDialog(BuildContext context, String url) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Open Map'),
        content: const Text('Confirm to open the following link in your web browser:'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
            },
            child: const Text('Open in Web Browser'),
          ),
        ],
      ),
    );
  }
}