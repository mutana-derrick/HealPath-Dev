import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healpath/src/features/authentication/screens/login/login_screen.dart';

class SignUpFooter extends StatelessWidget {
  const SignUpFooter({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text("OR"),
        const SizedBox(
          height: 20,
        ),
        SizedBox(
          height: 48,
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              shape: const RoundedRectangleBorder(),
              foregroundColor: Theme.of(context).brightness == Brightness.light
                  ? Colors.black // Set to black in light mode
                  : Colors.white, // Set to white in dark mode
              side: const BorderSide(color: Colors.blue),
              padding: const EdgeInsets.symmetric(vertical: 15),
            ),
            icon: const Image(
              image: AssetImage("assets/logo/google.png"),
              width: 20,
            ),
            label: const Text("Sign-in With Google"),
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        TextButton(
          onPressed: () => Get.to(() => const LoginScreen()),
          child: Text.rich(
            TextSpan(
              text: "Already have an Account? ",
              style: Theme.of(context).textTheme.bodyLarge,
              children: const [
                TextSpan(
                  text: "Login",
                  style: TextStyle(
                    color: Colors.blue,
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
