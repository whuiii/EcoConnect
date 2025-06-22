import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DeliveryService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
Future<void> createDelivery({
  required String email,
  required String username,
  required String phoneNumber,
  required List<String> materials,
  required String bagSize,
  required DateTime date,
  required TimeOfDay time,
  required String address,
  required double latitude,
  required double longitude,
}) async {
  await FirebaseFirestore.instance.collection('deliveries').add({
    'email': email,
    'username': username,
    'phoneNumber': phoneNumber,
    'materials': materials,
    'bagSize': bagSize,
    'date': date.toIso8601String(),  // Save date
    'time': '${time.hour}:${time.minute}',  // Save time as string
    'address': address,
    'latitude': latitude,
    'longitude': longitude,
    'createdAt': FieldValue.serverTimestamp(),
  });

  }
}