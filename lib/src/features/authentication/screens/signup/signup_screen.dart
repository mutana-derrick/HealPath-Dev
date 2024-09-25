import 'package:flutter/material.dart';
import 'package:healpath/src/features/authentication/screens/signup/signup_footer.dart';
import 'package:healpath/src/features/authentication/screens/signup/signup_form.dart';
import 'package:healpath/src/features/authentication/screens/signup/signup_header.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(30),
          // height: MediaQuery.of(context).size.height,
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
