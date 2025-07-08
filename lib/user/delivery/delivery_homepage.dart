import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:navigate/user/delivery/delivery_container.dart';
import 'package:navigate/user/delivery/delivery_container_detail.dart';
import 'package:navigate/user/delivery/delivery_info.dart';
import 'package:navigate/user/delivery/page_delivery.dart';

import '../../color.dart';
import 'add_delivery_request.dart';

class DeliveryRequest extends StatelessWidget {
  const DeliveryRequest({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Two tabs: Current & Past
      child: SafeArea(
        child: Scaffold(
          backgroundColor: const Color.fromARGB(255, 235, 228, 205),
          appBar: AppBar(
            title: const Text("Recycle Request"),
            foregroundColor: green1,
            automaticallyImplyLeading: false,
            bottom: const TabBar(
              indicatorColor: Colors.white,
              labelColor: Colors.white,
              unselectedLabelColor: green1,
              tabs: [
                Tab(text: "Current"),
                Tab(text: "Past"),
              ],
            ),
            actions: [
              IconButton(
                onPressed: () {
                  Get.to(() => const Delivery());
                },
                icon: const Icon(Icons.add),
              ),
            ],
          ),
          body: TabBarView(
            children: [
              // Current Deliveries Tab
              _DeliveryList(
                filterStatuses: ['Pending', 'Accepted'],
                emptyMessage: "No current delivery requests.",
              ),
              // Past Deliveries Tab
              _DeliveryList(
                filterStatuses: ['Completed', 'Rejected'],
                emptyMessage: "No past delivery requests.",
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DeliveryList extends StatelessWidget {
  final List<String> filterStatuses;
  final String emptyMessage;

  const _DeliveryList({
    required this.filterStatuses,
    required this.emptyMessage,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 10),
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('deliveries')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs.where((doc) {
            final data = doc.data() as Map<String, dynamic>;
            final status = data['status'] ?? 'Pending';
            return filterStatuses.contains(status);
          }).toList();

          if (docs.isEmpty) {
            return Center(child: Text(emptyMessage));
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
                materials: List<String>.from(data['materials'] ?? []),
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
                      builder: (_) => DeliveryDetailPage(documentId: docId),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
