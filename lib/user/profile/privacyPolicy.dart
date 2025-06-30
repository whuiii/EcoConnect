import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:navigate/color.dart'; // Your custom colors

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Privacy Policy"),
        backgroundColor: green3,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Privacy Policy",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            const Text(
              "Last Updated: June 28, 2025",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const Divider(height: 40, thickness: 1),

            buildSection(
              icon: Iconsax.shield_tick,
              iconColor: Colors.teal.shade400,
              title: "Your Privacy Matters",
              content:
              "At EcoConnect, your privacy is important to us. This Privacy Policy explains how we collect, use, and protect your personal information when you use our services.",
            ),

            const Divider(height: 40),

            buildSection(
              icon: Iconsax.folder_open,
              iconColor: Colors.orange.shade400,
              title: "Information We Collect",
              content:
              "• Personal Data: Name, email address, phone number, and profile photo.\n"
                  "• Usage Data: How you interact with our app.\n"
                  "• Location Data: If you enable location services.",
            ),

            const Divider(height: 40),

            buildSection(
              icon: Iconsax.setting_2,
              iconColor: Colors.purple.shade400,
              title: "How We Use Your Data",
              content:
              "We use your information to:\n"
                  "• Provide and maintain our services.\n"
                  "• Communicate updates and offers.\n"
                  "• Ensure a secure, seamless experience.",
            ),

            const Divider(height: 40),

            buildSection(
              icon: Iconsax.lock,
              iconColor: Colors.blue.shade400,
              title: "How We Keep It Safe",
              content:
              "We take reasonable measures to protect your information from unauthorized access, alteration, or disclosure.",
            ),

            const Divider(height: 40),

            buildSection(
              icon: Iconsax.user_cirlce_add,
              iconColor: Colors.redAccent.shade200,
              title: "Your Rights",
              content:
              "You can review, update, or delete your data anytime by contacting us at ecoconnect@example.com.",
            ),

            const Divider(height: 40),

            buildSection(
              icon: Iconsax.refresh,
              iconColor: Colors.amber.shade600,
              title: "Changes to This Policy",
              content:
              "We may update this Privacy Policy occasionally. We encourage you to review it regularly for any changes.",
            ),

            const Divider(height: 40),

            buildSection(
              icon: Iconsax.direct,
              iconColor: Colors.green.shade400,
              title: "Contact Us",
              content:
              "If you have any questions about this Privacy Policy, please email us at ecoconnect@example.com.",
            ),

            const SizedBox(height: 40),

            Center(
              child: Text(
                "© 2025 EcoConnect. All rights reserved.",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Beautiful reusable section with a custom icon color
  Widget buildSection({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String content,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(10),
              child: Icon(icon, color: iconColor, size: 26),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          content,
          style: const TextStyle(
            fontSize: 16,
            height: 1.6,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}
