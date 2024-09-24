import 'package:flutter/material.dart';
import 'package:healpath/src/features/authentication/screens/login/login_form.dart';
import 'package:healpath/src/features/authentication/screens/login/login_header.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(30.0),
            height: MediaQuery.of(context).size.height,
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [LoginHeader(), LoginForm()],
            ),
          ),
        ),
      ),
    );
  }
}
