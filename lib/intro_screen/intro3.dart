import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../color.dart';

class IntroPage3 extends StatelessWidget {
  const IntroPage3({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final double lottieHeight = screenHeight * 0.6;

    return SafeArea(
      child: Container(
        color: primary,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const SizedBox(height: 40),

            // Responsive Lottie animation
            SizedBox(
              height: lottieHeight,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Lottie.asset(
                  "assets/images/Object Reward DC.json",
                  fit: BoxFit.contain,
                ),
              ),
            ),

            // Title
            Text(
              "Earn Rewards for Going Green",
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
              "Take sustainable actions like recycling or requesting pick-ups to earn points, unlock eco-badges, and redeem exclusive rewards from our green partners.",
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
