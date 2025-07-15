import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:navigate/color.dart';
import 'package:navigate/user/delivery/add_delivery_request.dart';
import 'package:navigate/user/delivery/delivery_container.dart';
import 'package:navigate/user/delivery/delivery_container_detail.dart';

class DeliveryRequest extends StatelessWidget {
  const DeliveryRequest({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
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
              _DeliveryList(
                filterStatuses: ['Pending', 'Accepted'],
                emptyMessage: "No current delivery requests.",
              ),
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

  Future<Map<String, String>> _fetchAllUsernames(
      List<QueryDocumentSnapshot> docs) async {
    final userIds = docs.map((doc) => doc['userId'] as String).toSet();

    final futures = userIds.map((uid) async {
      final userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      String username = 'Unknown';

      if (userDoc.exists) {
        final data = userDoc.data();
        if (data != null && data.containsKey('username')) {
          username = data['username'] ?? 'Unknown';
        }
      }

      return MapEntry(uid, username);
    });

    return Map.fromEntries(await Future.wait(futures));
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 10),
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('deliveries')
            .where('userId', isEqualTo: currentUser?.uid)
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

          return FutureBuilder<Map<String, String>>(
            future: _fetchAllUsernames(docs),
            builder: (context, userSnapshot) {
              if (!userSnapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final usernameMap = userSnapshot.data!;

              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: docs.length,
                itemBuilder: (context, index) {
                  final doc = docs[index];
                  final docId = doc.id;
                  final data = doc.data() as Map<String, dynamic>;
                  final userId = data['userId'];
                  final username = usernameMap[userId] ?? 'Unknown';

                  return RequestContainerWidget(
                    username: username,
                    location: data['address'] ?? '-',
                    materials: List<String>.from(data['materials'] ?? []),
                    bagSize: data['bagSize'] ?? '-',
                    status: data['status'] ?? 'Pending',
                    rejectReason: data['rejectReason'] ?? '-',
                    date: data['date'] ?? 'Unknown date',
                    time: data['time'] ?? '',
                    pointAwarded: data['pointAwarded'] ?? 0,
                    remarks: data['remark'] ?? '-',
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
          );
        },
      ),
    );
  }
}
