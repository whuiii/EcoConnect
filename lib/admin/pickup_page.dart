import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:navigate/admin/admin_request_detail.dart';
import '../../color.dart';
import '../../user/delivery/delivery_container.dart'; // reuse the same widget

class AdminDeliveryRequest extends StatelessWidget {
  const AdminDeliveryRequest({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Two tabs: Current & Past
      child: SafeArea(
        child: Scaffold(
          backgroundColor: const Color.fromARGB(255, 235, 228, 205),
          appBar: AppBar(
            title: const Text("Delivery Requests"),
            foregroundColor: green1,
            bottom: const TabBar(
              indicatorColor: Colors.white,
              labelColor: Colors.white,
              unselectedLabelColor: green1,
              tabs: [
                Tab(text: "Current"),
                Tab(text: "Past"),
              ],
            ),
          ),
          body: const TabBarView(
            children: [
              _AdminDeliveryList(
                filterStatuses: ['Pending', 'Accepted'],
                emptyMessage: "No current delivery requests.",
              ),
              _AdminDeliveryList(
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

class _AdminDeliveryList extends StatelessWidget {
  final List<String> filterStatuses;
  final String emptyMessage;

  const _AdminDeliveryList({
    required this.filterStatuses,
    required this.emptyMessage,
  });
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User?>(
      future: Future.value(FirebaseAuth.instance.currentUser),
      builder: (context, userSnapshot) {
        if (!userSnapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final currentAdminUid = userSnapshot.data!.uid;

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 10),
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('deliveries')
                .where('companyUid', isEqualTo: currentAdminUid)
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
                          builder: (_) =>
                              AdminDeliveryDetailPage(documentId: docId),
                        ),
                      );
                    },
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}
