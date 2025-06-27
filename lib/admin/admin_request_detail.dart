import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:navigate/color.dart';
import 'package:navigate/user/delivery/placeholder_delivery.dart';

class AdminDeliveryDetailPage extends StatefulWidget {
  final String documentId;

  const AdminDeliveryDetailPage({Key? key, required this.documentId})
      : super(key: key);

  @override
  State<AdminDeliveryDetailPage> createState() =>
      _AdminDeliveryDetailPageState();
}

class _AdminDeliveryDetailPageState extends State<AdminDeliveryDetailPage> {
  late DocumentSnapshot deliveryData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDelivery();
  }

  Future<void> _loadDelivery() async {
    final doc = await FirebaseFirestore.instance
        .collection('deliveries')
        .doc(widget.documentId)
        .get();

    if (mounted) {
      setState(() {
        deliveryData = doc;
        isLoading = false;
      });
    }
  }

  void _showRejectionDialog(BuildContext context) {
    final TextEditingController reasonController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Reject Delivery'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: reasonController,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    labelText: 'Click me to fill reason',
                    hintText: 'Type your reason here...',
                    border: OutlineInputBorder(),
                  ),
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
              onPressed: () {
                final reason = reasonController.text.trim();
                if (reason.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter a reason')),
                  );
                  return;
                }

                Navigator.of(context).pop();
                _updateStatus('Rejected', reason: reason);
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _updateStatus(String newStatus, {String? reason}) async {
    Map<String, dynamic> updateData = {
      'status': newStatus,
    };

    if (reason != null && reason.isNotEmpty) {
      updateData['rejectReason'] = reason;
    }

    await FirebaseFirestore.instance
        .collection('deliveries')
        .doc(widget.documentId)
        .update(updateData);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Status updated to $newStatus')),
    );
    Navigator.pop(context);
  }

  void _showCompletionDialog(BuildContext context) {
    final TextEditingController weightController = TextEditingController();
    String selectedMaterial = 'Plastic';
    final List<String> materialTypes = ['Plastic', 'Paper', 'Glass', 'Metal'];

    int _calculatePoints(String material, double weight) {
      switch (material) {
        case 'Plastic':
          return (weight * 10).round();
        case 'Paper':
          return (weight * 8).round();
        case 'Glass':
          return (weight * 6).round();
        case 'Metal':
          return (weight * 12).round();
        default:
          return (weight * 5).round();
      }
    }

    Future<void> _completeDelivery(
        String material, double weight, int points) async {
      final updateData = {
        'status': 'Completed',
        'materialType': material,
        'weightKg': weight,
        'pointsAwarded': points,
      };

      await FirebaseFirestore.instance
          .collection('deliveries')
          .doc(widget.documentId)
          .update(updateData);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text('Delivery marked as Completed. $points points awarded.')),
      );
      Navigator.pop(context); // or _loadDelivery() to refresh
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Complete Delivery'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                value: selectedMaterial,
                items: materialTypes.map((material) {
                  return DropdownMenuItem<String>(
                    value: material,
                    child: Text(material),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) selectedMaterial = value;
                },
                decoration: const InputDecoration(
                  labelText: 'Material Type',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: weightController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Weight (kg)',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final weight = double.tryParse(weightController.text.trim());
                if (weight == null || weight <= 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Please enter a valid weight')),
                  );
                  return;
                }

                int points = _calculatePoints(selectedMaterial, weight);
                Navigator.of(context).pop();

                _completeDelivery(selectedMaterial, weight, points);
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Delivery Details (Admin)"),
        backgroundColor: green3,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : _buildDetailView(),
    );
  }

  Widget _buildDetailView() {
    final data = deliveryData.data() as Map<String, dynamic>;
    final materials = List<String>.from(data['materials'] ?? []);
    final materialsText = materials.join(', ');
    final status = data['status'] ?? '-';
    final rejectionReason = data['rejectReason'] ?? '';

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                Text("Personal Details",
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                _buildInfo(Iconsax.sms, "Email", data['email'] ?? '-'),
                _buildInfo(Iconsax.user, "Username", data['username'] ?? '-'),
                _buildInfo(Iconsax.call, "Phone", data['phoneNumber'] ?? '-'),
                Divider(),
                Text("Materials / Recycle Info",
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                _buildInfo(Iconsax.repeat_circle, "Materials", materialsText),
                _buildInfo(Iconsax.bag, "Bag Size", data['bagSize'] ?? '-'),
                _buildInfo(Iconsax.box, "Status", data['status'] ?? '-'),
                _buildInfo(Iconsax.note_text, "Remark", data['remark'] ?? '-'),
                // Show rejection reason if status is Rejected and reason exists
                if (status == 'Rejected' && rejectionReason.isNotEmpty)
                  _buildInfo(Iconsax.warning_2, "Reason for Rejection",
                      rejectionReason),
                Divider(),
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
          ),

          // Accept/Reject Buttons
          if (status == "Pending") ...{
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _updateStatus('Accepted'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: green2,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                    child: const Text(
                      'Accept',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 16), // spacing between buttons
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _showRejectionDialog(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 227, 54, 42),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                    child: const Text(
                      'Reject',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          } else if (status == "Accepted") ...[
            Expanded(
              child: ElevatedButton(
                onPressed: () => _showCompletionDialog(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                child: const Text(
                  'Complete',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfo(IconData icon, String title, String value) {
    if (value.isEmpty || value == "-") return SizedBox.shrink();
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
