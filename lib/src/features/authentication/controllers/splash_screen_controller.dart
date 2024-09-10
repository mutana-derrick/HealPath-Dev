import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healpath/src/features/authentication/screens/welcome_screen/welcome_screen.dart';

class SplashScreenController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<Offset> offsetAnimation;
  late Animation<double> opacityAnimation;

  @override
  void onInit() {
    super.onInit();

    // Initialize the AnimationController with a duration of 5 seconds
    animationController = AnimationController(
      duration: const Duration(seconds: 30), // Animation lasts for 5 seconds
      vsync: this,
    );

    // Create an offset animation to move a widget from the bottom (Offset(0,1)) to its original position (Offset.zero)
    offsetAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: animationController,
      curve: Curves.easeInOut,
    ));

    // Create an opacity animation to fade in a widget from 0 (invisible) to 1 (fully visible)
    opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: animationController,
      curve: Curves.easeInOut,
    ));

    // Start the animation
    animationController.forward();

    // Add a listener to detect when the animation is complete
    animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // Delay navigation to the WelcomeScreen by 2 seconds, making the total splash time 7 seconds
        Future.delayed(const Duration(seconds: 1), () {
          Get.off(() => const WelcomeScreen()); // Navigate to WelcomeScreen
        });
      }
    });
  }

  @override
  void onClose() {
    // Dispose of the animation controller when the screen is closed
    animationController.dispose();
    super.onClose();
  }
}
