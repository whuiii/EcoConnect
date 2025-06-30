import 'package:flutter/material.dart';
import 'package:navigate/color.dart'; // your custom colors

class TermsConditionsPage extends StatelessWidget {
  const TermsConditionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              const Text(
                "Terms & Conditions",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Welcome to EcoConnect! By using our app, you agree to the following terms and conditions. Please read them carefully.",
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
              const SizedBox(height: 20),

              buildSectionTitle("1. Use of the App"),
              buildSectionText(
                  "You agree to use EcoConnect only for lawful purposes and in a way that does not infringe the rights of others or restrict their use and enjoyment of the app."),

              buildSectionTitle("2. User Accounts"),
              buildSectionText(
                  "You are responsible for maintaining the confidentiality of your account and password and for restricting access to your device."),

              buildSectionTitle("3. Intellectual Property"),
              buildSectionText(
                  "All content included in this app, such as text, graphics, logos, and images, is the property of EcoConnect or its content suppliers."),

              buildSectionTitle("4. Privacy"),
              buildSectionText(
                  "Your use of the app is also governed by our Privacy Policy. Please review it to understand our practices."),

              buildSectionTitle("5. Limitation of Liability"),
              buildSectionText(
                  "EcoConnect will not be liable for any damages that arise from the use or inability to use the app."),

              buildSectionTitle("6. Changes to Terms"),
              buildSectionText(
                  "We may update these terms and conditions from time to time. Continued use of the app means you accept any changes."),

              buildSectionTitle("7. Contact Us"),
              buildSectionText(
                  "If you have any questions about these Terms & Conditions, please contact us at ecoconnect@example.com."),

              const SizedBox(height: 30),
              Center(
                child: Text(
                  "© 2025 EcoConnect. All rights reserved.",
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Reusable helper for section titles
  Widget buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 6),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  /// Reusable helper for section text
  Widget buildSectionText(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 16, height: 1.5),
    );
  }
}
