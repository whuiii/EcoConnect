import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart'; // Optional if you want nice icons
import 'package:navigate/color.dart';   // Use your custom colors

class FAQPage extends StatelessWidget {
  const FAQPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("FAQs"),
        centerTitle: true,
        backgroundColor: green3,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            "Frequently Asked Questions",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),

          buildFAQItem(
            question: "What is EcoConnect?",
            answer: "EcoConnect is an app that helps users recycle, reuse, and reduce waste by connecting them with local recycling centers and providing helpful tips.",
          ),

          buildFAQItem(
            question: "How do I create an account?",
            answer: "Tap the Sign Up button on the home screen, fill in your details, and verify your email address to start using EcoConnect.",
          ),

          buildFAQItem(
            question: "How can I update my profile information?",
            answer: "Go to your Profile page and tap the Edit Profile button to update your personal information.",
          ),

          buildFAQItem(
            question: "Is my data safe?",
            answer: "Yes! We use secure encryption methods to protect your data. Please refer to our Privacy Policy for more details.",
          ),

          buildFAQItem(
            question: "How do I contact support?",
            answer: "You can reach us via the Contact Us section or email us directly at ecoconnect@example.com.",
          ),

          buildFAQItem(
            question: "Can I delete my account?",
            answer: "Yes, you can request account deletion in the app settings or by contacting support.",
          ),

          const SizedBox(height: 20),

          Center(
            child: Text(
              "Didn't find what you were looking for?\nContact us at ecoconnect@example.com",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700,
              ),
            ),
          )
        ],
      ),
    );
  }

  /// Reusable FAQ ExpansionTile
  Widget buildFAQItem({
    required String question,
    required String answer,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        childrenPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Icon(Iconsax.message_question, color: green3),
        title: Text(
          question,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        children: [
          Text(
            answer,
            style: const TextStyle(fontSize: 14, height: 1.5),
          ),
        ],
      ),
    );
  }
}
