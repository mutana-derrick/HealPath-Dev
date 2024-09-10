import 'package:flutter/material.dart';
import 'package:healpath/src/features/authentication/screens/login/login_screen.dart';
import 'package:get/get.dart';
// import 'package:healpath/src/features/authentication/screens/signup/signup_screen.dart';
import 'package:healpath/src/features/patient/patient_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset(
              "assets/images/nodrugs.png",
              height: height * 0.6,
            ),
            Column(
              children: [
                Text(
                  " HealPath",
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                Text(
                  "Empowering the healing journey through connection and care.",
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Get.to(() => const LoginScreen()),
                    style: OutlinedButton.styleFrom(
                      shape: const RoundedRectangleBorder(),
                      foregroundColor: Colors.blue,
                      side: const BorderSide(color: Colors.blue),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    child: const Text("LOGIN"),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Get.to(() => const PatientScreen()),
                    style: OutlinedButton.styleFrom(
                      shape: const RoundedRectangleBorder(),
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blue,
                      side: const BorderSide(color: Colors.blue),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    child: const Text("SIGNUP"),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
