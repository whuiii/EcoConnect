import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class DeliveryQRCodeScreen extends StatelessWidget {
  final Map<String, dynamic> deliveryInfo;

  const DeliveryQRCodeScreen({super.key, required this.deliveryInfo});

  @override
  Widget build(BuildContext context) {
    final String username = deliveryInfo['username'] ?? 'Unknown';
    final String email = deliveryInfo['email'] ?? 'N/A';
    final String phone = deliveryInfo['phoneNumber'] ?? 'N/A';
    final String status = deliveryInfo['status'] ?? 'Pending';
    final String userId = deliveryInfo['userId'] ?? ''; // ✅ Add this

    final Map<String, dynamic> qrData = {
      'userId': userId,
      'username': username,
      'email': email,
      'phoneNumber': phone,
      'status': status,
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text("Show this to drop-off center"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              QrImageView(
                data: jsonEncode(qrData),
                version: QrVersions.auto,
                size: 250.0,
              ),
              const SizedBox(height: 30),
              Text("Username: $username", style: const TextStyle(fontSize: 16)),
              Text("Email: $email", style: const TextStyle(fontSize: 16)),
              Text("Phone: $phone", style: const TextStyle(fontSize: 16)),
            ],
          ),
        ),
      ),
    );
  }
}
