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
            child: TextField(
              controller: reasonController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Click me to fill reason',
                hintText: 'Type your reason here...',
                border: OutlineInputBorder(),
              ),
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

  void _showCompletionDialog(BuildContext context) {
    List<Map<String, dynamic>> entries = [
      {'material': 'Plastic', 'weightController': TextEditingController()},
    ];

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

      // 🔍 Get userId from deliveryData
      final data = deliveryData.data() as Map<String, dynamic>;
      final userId = data['userId'];

      // 📌 Update delivery document
      final updateData = {
        'status': 'Completed',
        'totalWeightKg': totalWeight,
        'pointAwarded': totalPoint,
        'materialsBreakdown': materials,
        'completedAt': DateTime.now(),
      };

      await FirebaseFirestore.instance
          .collection('deliveries')
          .doc(widget.documentId)
          .update(updateData);

      // 📌 Update user’s total point, total weight, and frequency
      final userRef =
          FirebaseFirestore.instance.collection('users').doc(userId);

      await FirebaseFirestore.instance.runTransaction((transaction) async {
        final snapshot = await transaction.get(userRef);

        if (snapshot.exists) {
          final data = snapshot.data() as Map<String, dynamic>;
          final currentPoint = data['point'] ?? 0;
          final currentWeight = (data['weight'] ?? 0).toDouble();
          final currentFrequency = data['frequency'] ?? 0;

          transaction.update(userRef, {
            'point': currentPoint + totalPoint,
            'weight': currentWeight + totalWeight,
            'frequency': currentFrequency + 1,
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
      Navigator.of(context).pop(); // Close the dialog
      Navigator.of(context).pop(); // Close the detail page
    }

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: const Text('Complete Delivery'),
            content: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height *
                      0.6, // max 60% of screen
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ...entries.map((entry) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          children: [
                            Flexible(
                              flex: 5,
                              child: DropdownButtonFormField<String>(
                                value: entry['material'],
                                items: materialTypes.map((material) {
                                  return DropdownMenuItem<String>(
                                    value: material,
                                    child: Text(
                                      material,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          fontSize:
                                              15.5), // You can adjust the size as needed
                                    ),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  if (value != null) {
                                    setState(() => entry['material'] = value);
                                  }
                                },
                                decoration: const InputDecoration(
                                  labelText: 'Material',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Flexible(
                              flex: 3,
                              child: TextField(
                                controller: entry['weightController'],
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  labelText: 'kg',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                setState(() => entries.remove(entry));
                              },
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                    ElevatedButton.icon(
                      onPressed: () {
                        if (entries.length >= 3) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    'You can only add up to 3 materials.')),
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
                      style: ElevatedButton.styleFrom(
                        backgroundColor: green2,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () => _completeDelivery(entries),
                child: const Text('Submit'),
              ),
            ],
          );
        });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Delivery Details"),
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
                if (data['materialsBreakdown'] != null &&
                    data['materialsBreakdown'] is List &&
                    (data['materialsBreakdown'] as List).isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Text("Graded Materials Breakdown",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  ...(data['materialsBreakdown'] as List).map<Widget>((entry) {
                    if (entry is! Map) return SizedBox.shrink();
                    final material = entry['material'] ?? '-';
                    final weight = entry['weight']?.toString() ?? '0';
                    final point = entry['point']?.toString() ?? '-';

                    //The Content of Graded Materials Breakdown
                    return _buildInfo(
                        Iconsax.task, material, "${weight}kg (${point} pts)");
                  }).toList(),
                  if (data['totalWeightKg'] != null)
                    Text("    Total Weight: ${data['totalWeightKg']} kg",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            color: green2)),
                ],
                const SizedBox(height: 8),
                _buildInfo(Iconsax.bag, "Bag Size", data['bagSize'] ?? '-'),
                _buildInfo(Iconsax.box, "Status", data['status'] ?? '-'),
                _buildInfo(Iconsax.note_text, "Remark", data['remark'] ?? '-'),
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
          if (status == "Pending")
            Row(
              children: [
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
                const SizedBox(width: 16),
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
              ],
            )
          else if (status == "Accepted")
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _showCompletionDialog(context),
                style: ElevatedButton.styleFrom(
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
                    text: value,
                    icon: icon,
                    showLabel: true,
                    hint: title,
                    isEnabled: false),
                SizedBox(height: 4),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
