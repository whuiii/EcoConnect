import 'package:flutter/material.dart';
import 'package:navigate/color.dart'; // Replace with your actual colors if needed

class AboutUs extends StatelessWidget {
  const AboutUs({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("About Us"),
        backgroundColor: green3,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Logo
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: ClipOval(
                child: Image.asset(
                  'assets/images/EcoConnect_Logo.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // App Name
            const Text(
              "EcoConnect",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            // Tagline
            const Text(
              "Recycle • Reuse • Reduce",
              style: TextStyle(
                fontSize: 16,
                fontStyle: FontStyle.italic,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 30),

            // About description
            const Text(
              "EcoConnect is dedicated to building a sustainable future through community-driven recycling and waste management. "
                  "We empower people to make eco-friendly choices every day, connecting them with local resources and recycling programs.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 30),

            // Contact info
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                ListTile(
                  leading: Icon(Icons.email, color: Colors.green),
                  title: Text("ecoconnect@example.com"),
                ),
                ListTile(
                  leading: Icon(Icons.web, color: Colors.green),
                  title: Text("www.ecoconnect.org"),
                ),
                ListTile(
                  leading: Icon(Icons.phone, color: Colors.green),
                  title: Text("+1 234 567 890"),
                ),
              ],
            ),

            const SizedBox(height: 30),

            // Version or copyright
            const Text(
              "© 2025 EcoConnect. All rights reserved.",
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
