import 'package:flutter/material.dart';
import 'package:navigate/color.dart';

class IntroPage1 extends StatelessWidget {
  const IntroPage1({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: primary,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 40), // Top padding

            // Title Text
            Text(
              "Make recycling simple, smart, and rewarding — right from your phone.",
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 20), // Tighter space between title and gif

            // Larger GIF
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Image.asset(
                  "assets/images/3.gif",
                  fit: BoxFit.contain,
                ),
              ),
            ),

            const SizedBox(height: 10), // Space before subtitle

            // Optional Subtitle
            Text(
              "Together, we can make a greener world.",
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white70,
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 20), // Bottom space
          ],
        ),
      ),
    );
  }
}
