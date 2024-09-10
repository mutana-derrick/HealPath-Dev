import 'package:flutter/material.dart';
import 'package:healpath/src/features/authentication/screens/signup/signup_footer.dart';
import 'package:healpath/src/features/authentication/screens/signup/signup_form.dart';
import 'package:healpath/src/features/authentication/screens/signup/signup_header.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(30),
          height: MediaQuery.of(context).size.height,
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SignUpHeader(),
              SignUpForm(),
              SignUpFooter(),
            ],
          ),
        ),
      ),
    );
  }
}
