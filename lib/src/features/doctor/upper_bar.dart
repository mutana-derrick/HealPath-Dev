import 'package:flutter/material.dart';
import 'package:healpath/src/features/doctor/circle_button.dart';

class UpperBar extends StatelessWidget {
  const UpperBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 55, left: 20, right: 20),
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2), // Shadow color with opacity
            spreadRadius: 5, // How much the shadow spreads
            blurRadius: 10, // How blurry the shadow is
            offset: const Offset(2, 3), // Position of the shadow (x, y)
          ),
        ],
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: const [0.1, 0.5],
          colors: [
            Colors.blue[500]!, // Darker blue
            Colors.blue[400]!, // Light blue
          ],
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Hello,\nDr Kwizigira",
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(color: Colors.white),
              ),
              Column(
                children: [
                  CircleButton(
                    icon: Icons.notifications,
                    color: Colors.blue.shade900,
                    backgroundColor: Colors.blue.shade400,
                    onPressed: () {},
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Sep / 3 / 2024", // Replace with dynamic date if needed
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: Colors.blueGrey[900]),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
