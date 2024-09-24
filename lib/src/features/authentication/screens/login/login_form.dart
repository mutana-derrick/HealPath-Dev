import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healpath/src/features/authentication/screens/forgot_password/forgot_password_screen.dart';
import 'package:healpath/src/features/doctor/doctor_dashboard.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ------------Email Field-------------------
            SizedBox(
              height: 50,
              child: TextFormField(
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.email_outlined),
                  labelText: "Email",
                  hintText: "email",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 30),
            // ------------Password Field-------------------
            SizedBox(
              height: 50,
              child: TextFormField(
                decoration: const InputDecoration(
                  labelText: "Password",
                  hintText: "password",
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                      onPressed: null, icon: Icon(Icons.remove_red_eye)),
                ),
              ),
            ),
            // ------------Forget Password-------------------
            const SizedBox(height: 30),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                  onPressed: () {
                    Get.to(() => const ForgotPasswordScreen());
                  },
                  child: const Text("Forget Password?")),
            ),
            const SizedBox(height: 10),
            // ------------Login button-------------------
            SizedBox(
              width: double.infinity,
              height: 45,
              child: ElevatedButton(
                  onPressed: () => Get.to(() => const DoctorDashboardScreen()),
                  style: OutlinedButton.styleFrom(
                    shape: const RoundedRectangleBorder(),
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blue,
                    side: const BorderSide(color: Colors.blue),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  child: const Text("LOGIN")),
            )
          ],
        ),
      ),
    );
  }
}
