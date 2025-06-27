import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:navigate/user/delivery/delivery_container.dart';
import 'package:navigate/user/delivery/delivery_container_detail.dart';
import 'package:navigate/user/delivery/delivery_info.dart';
import 'package:navigate/user/delivery/page_delivery.dart';

import '../../color.dart';
import 'delivery_form.dart';

class DeliveryRequest extends StatelessWidget {
  const DeliveryRequest({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 235, 228, 205),
        appBar: AppBar(
          title: const Text("Recycle Request"),
          foregroundColor: green1,
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              onPressed: () {
                Get.to(() => const Delivery()); // ensure Delivery() is a widget
              },
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () {
                          Get.to(DeliveryInfo());
                        },
                        child: Container(
                          width: 35,
                          height: 35,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: button,
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.question_mark,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(
                          width: 10), // spacing between icon and text
                      const Text(
                        "Info",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10), // body-level padding
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('deliveries')
                          .orderBy('createdAt', descending: true)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData)
                          return Center(child: CircularProgressIndicator());

                        final docs = snapshot.data!.docs;

                        if (docs.isEmpty) {
                          return Center(child: Text("No deliveries found"));
                        }

                        return ListView.builder(
                            shrinkWrap:
                                true, // Important if you're inside a Column
                            physics:
                                NeverScrollableScrollPhysics(), // Prevent internal scroll conflict
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
                                remark: data['remark'] ?? '-',
                                date: data['date'] ?? 'Unknown date',
                                time: data['time'] ?? '',
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          DeliveryDetailPage(documentId: docId),
                                    ),
                                  );
                                },
                              );
                            });
                      },
                    ),
                  ),
                ),

                // if contain request
                // may use while true to check the availability of the data
                // if no request display a no request picture
              ],
            ),
          ),
        ),
      ),
    );
  }
}
