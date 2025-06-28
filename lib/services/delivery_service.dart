import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DeliveryService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<void> createDelivery(
      {required String userId,
      required String email,
      required String username,
      required String phoneNumber,
      required List<String> materials,
      required String bagSize,
      required DateTime date,
      required String time,
      required String address,
      required double latitude,
      required double longitude,
      required String remark,
      required String status}) async {
    // Format date to dd/MM/yyyy
    String formattedDate = DateFormat('dd/MM/yyyy').format(date);

    await FirebaseFirestore.instance.collection('deliveries').add({
      'userId': userId,
      'email': email,
      'username': username,
      'phoneNumber': phoneNumber,
      'materials': materials,
      'bagSize': bagSize,
      'date': formattedDate, // Save date
      'time': time, // Save time as string
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'remark': remark,
      'status': status,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}
