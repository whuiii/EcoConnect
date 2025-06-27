import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:navigate/admin/admin_request_detail.dart';
import 'package:navigate/user/delivery/delivery_container_detail.dart';
import '../../color.dart';
import '../../user/delivery/delivery_container.dart'; // reuse the same widget

class AdminDeliveryRequest extends StatelessWidget {
  const AdminDeliveryRequest({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 235, 228, 205),
        appBar: AppBar(
          title: const Text("All Delivery Requests"),
          foregroundColor: green1,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 25),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('deliveries')
                          .orderBy('createdAt', descending: true)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }

                        final docs = snapshot.data!.docs;
                        if (docs.isEmpty) {
                          return const Center(
                              child: Text("No deliveries found"));
                        }

                        return ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: docs.length,
                            itemBuilder: (context, index) {
                              final doc = docs[index];
                              final docId = doc.id;
                              final data = doc.data() as Map<String, dynamic>;

                              return RequestContainerWidget(
                                username: data['username'] ?? 'Unknown',
                                location: data['address'] ?? '-',
                                materials:
                                    List<String>.from(data['materials'] ?? []),
                                bagSize: data['bagSize'] ?? '-',
                                status: data['status'] ?? 'Pending',
                                rejectReason: data['rejectReason'] ?? '-',
                                date: data['date'] ?? 'Unknown date',
                                time: data['time'] ?? '',
                                pointAwarded: data['pointAwarded'] ?? 0,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => AdminDeliveryDetailPage(
                                          documentId: docId),
                                    ),
                                  );
                                },
                              );
                            });
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
