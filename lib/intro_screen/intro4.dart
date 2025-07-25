import 'package:flutter/material.dart';
import '../color.dart';

class IntroPage4 extends StatelessWidget {
  const IntroPage4({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final double gifHeight = screenHeight * 0.6; // Maximize GIF height

    return SafeArea(
      child: Container(
        color: primary,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const SizedBox(height: 10), // Minimal top padding

            // Enlarged GIF inside a Container
            Container(
              height: gifHeight,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Image.asset(
                  "assets/images/sorting.gif",
                  fit: BoxFit.cover, // Fill more of the container
                ),
              ),
            ),

            const SizedBox(height: 8), // Small gap between GIF and title

            // Title
            const Text(
              "Learn, Watch & Get Inspired",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                height: 1.2,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 8), // Small gap before subtitle

            // Subtitle
            const Text(
              "Explore waste categories, enjoy interactive DIY videos, stay updated with eco-news, and discover fun facts that make learning about sustainability engaging and enjoyable.",
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
