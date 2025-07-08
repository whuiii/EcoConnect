import 'package:flutter/material.dart';
import 'package:navigate/color.dart'; // Your custom colors

class TermsConditionsPage extends StatelessWidget {
  const TermsConditionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text("Terms & Conditions"),
        centerTitle: true,
        backgroundColor: green3,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Page header with icon
              Row(
                children: [
                  Icon(Icons.gavel, size: 28, color: green3),
                  const SizedBox(width: 8),
                  const Text(
                    "Terms & Conditions",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Divider(thickness: 2),

              const SizedBox(height: 10),
              Text(
                "Welcome to EcoConnect! By using our app, you agree to the following terms and conditions. Please read them carefully.",
                style: TextStyle(
                  fontSize: 16,
                  height: 1.6,
                  color: Colors.grey[800],
                ),
              ),

              const SizedBox(height: 20),

              _buildSection(
                icon: Icons.check_circle_outline,
                title: "1. Use of the App",
                text:
                "You agree to use EcoConnect only for lawful purposes and in a way that does not infringe the rights of others or restrict their use and enjoyment of the app.",
              ),
              _buildSection(
                icon: Icons.person_outline,
                title: "2. User Accounts",
                text:
                "You are responsible for maintaining the confidentiality of your account and password and for restricting access to your device.",
              ),
              _buildSection(
                icon: Icons.copyright_outlined,
                title: "3. Intellectual Property",
                text:
                "All content included in this app, such as text, graphics, logos, and images, is the property of EcoConnect or its content suppliers.",
              ),
              _buildSection(
                icon: Icons.privacy_tip_outlined,
                title: "4. Privacy",
                text:
                "Your use of the app is also governed by our Privacy Policy. Please review it to understand our practices.",
              ),
              _buildSection(
                icon: Icons.warning_amber_outlined,
                title: "5. Limitation of Liability",
                text:
                "EcoConnect will not be liable for any damages that arise from the use or inability to use the app.",
              ),
              _buildSection(
                icon: Icons.update_outlined,
                title: "6. Changes to Terms",
                text:
                "We may update these terms and conditions from time to time. Continued use of the app means you accept any changes.",
              ),
              _buildSection(
                icon: Icons.email_outlined,
                title: "7. Contact Us",
                text:
                "If you have any questions about these Terms & Conditions, please contact us at ecoconnect@example.com.",
              ),

              const SizedBox(height: 30),
              Center(
                child: Text(
                  "© 2025 EcoConnect. All rights reserved.",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
    );

  }

  /// Reusable fancy section builder
  Widget _buildSection({
    required IconData icon,
    required String title,
    required String text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 18),
        Row(
          children: [
            Icon(icon, color: green3),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            height: 1.6,
          ),
        ),
        const SizedBox(height: 10),
        Divider(color: Colors.grey[300]),
      ],
    );
  }
}
