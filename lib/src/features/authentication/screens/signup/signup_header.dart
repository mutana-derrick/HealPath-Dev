import 'package:flutter/material.dart';

class SignUpHeader extends StatelessWidget {
  const SignUpHeader({
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
          "SignUp",
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ],
    );
  }
}
