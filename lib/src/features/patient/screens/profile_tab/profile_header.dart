import 'package:flutter/material.dart';
import 'package:healpath/src/features/patient/screens/profile_tab/header_curve_painter.dart';



class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: HeaderCurvePainter(),
      child: Container(
        height: 180,
        padding: const EdgeInsets.only(bottom: 50),
        alignment: Alignment.center,
        child: Text(
          'Profile',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.blue[900],
          ),
        ),
      ),
    );
  }
}
