import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:navigate/color.dart';

class IntroPage5 extends StatelessWidget {
  const IntroPage5({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    final double lottieHeight = screenHeight * 0.58;

    return SafeArea(
      child: Container(
        color: primary,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const SizedBox(height: 40),

            // Larger Lottie animation
            SizedBox(
              height: lottieHeight,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Lottie.asset(
                  "assets/images/Lets_start.json",
                  fit: BoxFit.contain,
                ),
              ),
            ),

            //const SizedBox(height: 5),

            // Title
            Text(
              "Let’s Get Started!",
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 12),

            // Subtitle
            Text(
              "Begin your EcoConnect journey today — explore features, take small green actions, and be part of a community working together for a cleaner, smarter, and more sustainable world.",
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white70,
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),

            const Spacer(),
          ],
        ),
      ),
    );
  }
}
