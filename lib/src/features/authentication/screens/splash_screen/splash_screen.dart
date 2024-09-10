import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healpath/src/features/authentication/controllers/splash_screen_controller.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final SplashScreenController controller = Get.put(SplashScreenController());
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/images/nodrugs.png"),
            const SizedBox(height: 20),
            AnimatedBuilder(
              animation: controller.animationController,
              builder: (context, child) {
                return Opacity(
                  opacity: controller.opacityAnimation.value,
                  child: SlideTransition(
                    position: controller.offsetAnimation,
                    child: Column(
                      children: [
                        Text(
                          "Live Drug-Free",
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Text(
                          "Heal Path",
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
