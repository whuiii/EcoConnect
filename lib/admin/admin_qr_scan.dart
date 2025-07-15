import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:intl/intl.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';

class QRScanPage extends StatefulWidget {
  const QRScanPage({super.key});

  @override
  State<QRScanPage> createState() => _QRScanPageState();
}

class _QRScanPageState extends State<QRScanPage> {
  bool isProcessing = false;

  void _onDetect(BarcodeCapture capture) async {
    if (isProcessing) return;

    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isEmpty) return;

    final String? raw = barcodes.first.rawValue;
    if (raw == null) return;

    setState(() => isProcessing = true);

    try {
      final Map<String, dynamic> qrData = _parseQrData(raw);
      final userId = qrData['userId'];
      final username = qrData['username'];
      final email = qrData['email'];
      final phone = qrData['phoneNumber'];

      if (userId == null) throw Exception('Invalid QR content');

      final companyUid = FirebaseAuth.instance.currentUser?.uid;
      if (companyUid == null) throw Exception("Admin not logged in");

      final position = await Geolocator.getCurrentPosition();
      final placemarks = await geo.placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      String address = 'Unknown location';
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        address =
            "${place.name}, ${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.postalCode}, ${place.country}";
      }

      final now = DateTime.now();
      final String formattedDate = DateFormat('yyyy-MM-dd').format(now);
      final String formattedTime = DateFormat('HH:mm:ss').format(now);

      // ✅ Create a new delivery document
      final newDoc =
          await FirebaseFirestore.instance.collection('deliveries').add({
        'userId': userId,
        'username': username,
        'email': email,
        'phoneNumber': phone,
        'companyUid': companyUid,
        'status': 'Pending',
        'createdAt': Timestamp.now(),
        'latitude': position.latitude,
        'longitude': position.longitude,
        'address': address,
        'date': formattedDate,
        'time': formattedTime,
      });

      _showCompletionDialog(context, newDoc.id);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
      setState(() => isProcessing = false);
    }
  }

  Map<String, dynamic> _parseQrData(String raw) {
    try {
      return Map<String, dynamic>.from(jsonDecode(raw));
    } catch (_) {
      return {};
    }
  }

  void _showCompletionDialog(BuildContext context, String deliveryId) {
    List<Map<String, dynamic>> entries = [
      {'material': 'Plastic', 'weightController': TextEditingController()},
    ];
    bool isSubmitting = false;
    final List<String> materialTypes = ['Plastic', 'Paper', 'Aluminium'];

    int _calculatePoint(String material, double weight) {
      switch (material) {
        case 'Plastic':
          return (weight * 10).round();
        case 'Paper':
          return (weight * 8).round();
        case 'Aluminium':
          return (weight * 12).round();
        default:
          return (weight * 5).round();
      }
    }

    Future<void> _completeDelivery(
        List<Map<String, dynamic>> materialList) async {
      // Check for duplicate materials
      final List<String> usedMaterials = [];
      for (var entry in materialList) {
        final material = entry['material'];
        if (usedMaterials.contains(material)) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('Duplicate material "$material" not allowed.')),
          );
          return;
        }
        usedMaterials.add(material);
      }

      double totalWeight = 0;
      int totalPoint = 0;
      final List<Map<String, dynamic>> materials = [];

      for (var entry in materialList) {
        final weight = double.tryParse(entry['weightController'].text.trim());
        if (weight == null || weight <= 0) continue;

        final material = entry['material'];
        final point = _calculatePoint(material, weight);
        totalWeight += weight;
        totalPoint += point;

        materials.add({
          'material': material,
          'weight': weight,
          'point': point,
        });
      }

      if (materials.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Please enter at least one valid entry.')),
        );
        return;
      }

      final deliveryRef =
          FirebaseFirestore.instance.collection('deliveries').doc(deliveryId);
      final deliverySnapshot = await deliveryRef.get();
      final deliveryData = deliverySnapshot.data() as Map<String, dynamic>;
      final userId = deliveryData['userId'];

      await deliveryRef.update({
        'status': 'Completed',
        'totalWeightKg': totalWeight,
        'pointAwarded': totalPoint,
        'materialsBreakdown': materials,
        'completedAt': DateTime.now(),
      });

      if (userId == null || userId.toString().isEmpty) {
        throw Exception("Invalid or missing userId in delivery record");
      }

      final userRef =
          FirebaseFirestore.instance.collection('users').doc(userId);
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        final userSnapshot = await transaction.get(userRef);

        if (userSnapshot.exists) {
          final data = userSnapshot.data() as Map<String, dynamic>;
          transaction.update(userRef, {
            'point': (data['point'] ?? 0) + totalPoint,
            'weight': (data['weight'] ?? 0).toDouble() + totalWeight,
            'frequency': (data['frequency'] ?? 0) + 1,
          });
        } else {
          transaction.set(userRef, {
            'point': totalPoint,
            'weight': totalWeight,
            'frequency': 1,
          });
        }
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Completed. $totalPoint points awarded.')),
      );
      Navigator.of(context, rootNavigator: true).pop(); // close dialog
      Navigator.of(context).pop(); // close scanner page
    }

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: const Text('Complete Delivery'),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  ...entries.map((entry) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Text('Material'),
                              const Spacer(),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () =>
                                    setState(() => entries.remove(entry)),
                              ),
                            ],
                          ),
                          DropdownButtonFormField<String>(
                            value: entry['material'],
                            // Prevent adding duplicate material in UI
                            items: materialTypes
                                .where((material) =>
                                    entries.indexWhere(
                                            (e) => e['material'] == material) ==
                                        -1 ||
                                    entry['material'] == material)
                                .map((material) {
                              return DropdownMenuItem<String>(
                                value: material,
                                child: Text(material),
                              );
                            }).toList(),
                            onChanged: (value) {
                              if (value != null) {
                                setState(() => entry['material'] = value);
                              }
                            },
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: entry['weightController'],
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                            decoration: const InputDecoration(
                              labelText: 'Weight (kg)',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                  ElevatedButton.icon(
                    onPressed: () {
                      if (entries.length >= 3) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Max 3 materials allowed.')),
                        );
                        return;
                      }
                      setState(() {
                        entries.add({
                          'material': 'Plastic',
                          'weightController': TextEditingController(),
                        });
                      });
                    },
                    icon: const Icon(Icons.add),
                    label: const Text("Add Material"),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: isSubmitting
                    ? null
                    : () async {
                        setState(() => isSubmitting = true);
                        await _completeDelivery(entries);
                        setState(() => isSubmitting = false);
                      },
                child: isSubmitting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Submit'),
              ),
            ],
          );
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Scan Delivery QR")),
      body: MobileScanner(
        controller: MobileScannerController(),
        onDetect: _onDetect,
      ),
    );
  }
}
