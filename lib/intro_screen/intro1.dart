import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../color.dart';

class IntroPage1 extends StatelessWidget {
  const IntroPage1({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final double animationHeight = screenHeight * 0.72; // Maximize height

    return SafeArea(
      child: Container(
        color: primary,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const SizedBox(height: 10), // Minimal top padding

            // Large Lottie animation inside a container
            Container(
              height: animationHeight,
              width: double.infinity,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Lottie.asset(
                  "assets/images/welcome.json",
                  fit: BoxFit.contain,
                ),
              ),
            ),

            const SizedBox(height: 8), // Small gap between animation and title

            // Title
            const Text(
              "Welcome to EcoConnect",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                height: 1.3,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 8),

            // Subtitle
            const Text(
              "Your smart companion for sustainable living — manage waste responsibly, earn rewards, and make a positive impact on the environment.",
              style: TextStyle(
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
