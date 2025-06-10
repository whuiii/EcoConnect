import 'package:flutter/material.dart';
import 'package:navigate/color.dart';

class DeliveryInfo extends StatelessWidget {
  const DeliveryInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: primary,
        appBar: AppBar(
          title: const Text("Information"),
          backgroundColor: button,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle("♻️ How to Use the Recycling Pick-up Request"),
                const SizedBox(height: 12),
                _buildStep(
                  icon: Icons.add_circle_outline,
                  title: "1. Submit a Request",
                  description:
                  "Tap the ➕ button on the Recycle Request page to fill in your pick-up details, including your location, contact number, and recyclable items.",
                ),
                _buildStep(
                  icon: Icons.schedule,
                  title: "2. Wait for Confirmation",
                  description:
                  "Our team will review your request and schedule a pick-up. Make sure your contact number is correct for updates.",
                ),
                _buildStep(
                  icon: Icons.recycling,
                  title: "3. Prepare Your Recyclables",
                  description:
                  "Separate your recyclables (paper, plastic, cans, etc.) and label if possible. Ensure they are clean and placed in bags/boxes.",
                ),
                _buildStep(
                  icon: Icons.directions_bike,
                  title: "4. Pick-Up Day",
                  description:
                  "Our staff will arrive at the scheduled time. Be ready to hand over the recyclables. If needed, add remarks like 'leave at doorstep'.",
                ),
                _buildStep(
                  icon: Icons.check_circle_outline,
                  title: "5. Done!",
                  description:
                  "Your items are now on their way to being recycled. Thank you for contributing to a cleaner environment!",
                ),
                const SizedBox(height: 20),
                _buildSectionTitle("📌 Notes"),
                const SizedBox(height: 10),
                Text(
                  "• Only clean and dry recyclables will be accepted.\n"
                      "• Requests should be made at least 1 day in advance.\n"
                      "• You can cancel or modify your request before pickup time.",
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade800),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildStep({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 30, color: button),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    )),
                const SizedBox(height: 4),
                Text(description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade800,
                    )),
              ],
            ),
          )
        ],
      ),
    );
  }
}
