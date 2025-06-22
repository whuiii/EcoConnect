import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:navigate/user/delivery/placeholder_delivery.dart';

class DeliveryDetailPage extends StatelessWidget {
  final String documentId;

  const DeliveryDetailPage({Key? key, required this.documentId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Delivery Details"),
        backgroundColor: Colors.blueAccent,
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('deliveries')
            .doc(documentId)
            .get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.data!.exists) {
            return Center(child: Text("Delivery not found."));
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;

          final materials = List<String>.from(data['materials'] ?? []);
          final materialsText = materials.join(', ');

          return Padding(
            padding: const EdgeInsets.all(16),
            child: ListView(
              children: [
                // Personal Details Section
                Text("Personal Details",
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                _buildInfo(Iconsax.sms, "Email", data['email'] ?? '-'),
                _buildInfo(Iconsax.user, "Username", data['username'] ?? '-'),
                _buildInfo(Iconsax.call, "Phone", data['phoneNumber'] ?? '-'),
                Divider(),

                // Materials / Recycle Section
                Text("Materials / Recycle Info",
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                _buildInfo(Iconsax.repeat_circle, "Materials", materialsText),
                _buildInfo(Iconsax.bag, "Bag Size", data['bagSize'] ?? '-'),
                _buildInfo(Iconsax.box, "Status", data['status'] ?? '-'),
                _buildInfo(Iconsax.note_text, "Remark", data['remark'] ?? '-'),
                Divider(),

                // Delivery Details Section
                Text("Delivery Details",
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                _buildInfo(Iconsax.calendar, "Date", data['date'] ?? '-'),
                _buildInfo(Iconsax.clock, "Time", data['time'] ?? '-'),
                _buildInfo(
                    Iconsax.location, "Location", data['address'] ?? '-'),
                Divider(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfo(IconData icon, String title, String value) {
    if (value.isEmpty || value == "-")
      return SizedBox.shrink(); // skip empty fields
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                FillInBlank(
                    text: value, icon: icon, hint: title, isEnabled: false),
                SizedBox(height: 4),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
