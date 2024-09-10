import 'package:flutter/material.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Welcome To HealPath !",
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        Text(
          "Login",
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ],
    );
  }
}
