import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:navigate/color.dart';

class IntroPage2 extends StatelessWidget {
  const IntroPage2({super.key});

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

            // Larger Lottie animation
            SizedBox(
              height: lottieHeight,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Lottie.asset(
                  "assets/images/Delivery truck.json",
                  fit: BoxFit.contain,
                ),
              ),
            ),

            //const SizedBox(height: 5),

            // Title
            Text(
              "Request a Waste Pick-Up with Ease",
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
              "Schedule a convenient waste collection from nearby certified centers — perfect for bulky items or when you can't drop off waste yourself.",
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
