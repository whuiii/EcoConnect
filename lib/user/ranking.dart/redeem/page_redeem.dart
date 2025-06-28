import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:navigate/color.dart';
import 'package:navigate/user/ranking.dart/redeem/voucher_detail.dart';

class RedeemPage extends StatelessWidget {
  const RedeemPage({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      return const Scaffold(
        body: Center(child: Text("User not logged in")),
      );
    }

    final userStream = FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.uid)
        .snapshots();

    return StreamBuilder<DocumentSnapshot>(
      stream: userStream,
      builder: (context, userSnapshot) {
        if (!userSnapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final userData = userSnapshot.data!.data() as Map<String, dynamic>;
        final point = userData['point'] ?? 0;

        return Scaffold(
          appBar: AppBar(
            title: const Text("My Rewards"),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Points Card Display
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        color: Colors.green.shade100,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              Icon(Icons.star, color: Colors.orange, size: 40),
                              const SizedBox(height: 8),
                              Text(
                                '$point pts',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green.shade900,
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'Available Points',
                                style: TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Voucher List from Firebase
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('vouchers')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return const Center(
                            child: Text('No vouchers available.'));
                      }

                      final vouchers = snapshot.data!.docs;

                      return ListView.builder(
                        itemCount: vouchers.length,
                        itemBuilder: (context, index) {
                          final doc = vouchers[index];
                          final docId = doc.id;

                          final data = doc.data() as Map<String, dynamic>;

                          final title = data['title'] ?? 'No Title';
                          final imageUrl =
                              (data['image'] ?? '').replaceAll('\\', '/');
                          final point = data['point'] ?? 0;
                          final validUntil = data['validUntil']?.toDate();
                          final status = data['status'] ?? 'unknown';
                          final validText = validUntil != null
                              ? 'Valid until ${validUntil.day}/${validUntil.month}/${validUntil.year}'
                              : 'No Expiry Date';
                          final code = data['code'] ?? '0';

                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 2,
                            child: ListTile(
                              leading: imageUrl.isNotEmpty
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.asset(
                                        imageUrl,
                                        width: 40,
                                        height: 40,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : const Icon(Icons.local_offer,
                                      color: Colors.deepOrange),
                              title: Text(
                                title,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    validText,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  if (status == 'redeemed') ...[
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            Clipboard.setData(
                                                ClipboardData(text: code));
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                  content: Text(
                                                      "Copied to clipboard")),
                                            );
                                          },
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                'Code: $code',
                                                style: const TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.black87,
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              const Icon(
                                                Icons.copy,
                                                size: 16,
                                                color: Colors.black54,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ],
                              ),
                              trailing: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    (status == 'active')
                                        ? 'Redeem'
                                        : 'Redeemed',
                                    style: TextStyle(
                                      color: (status == 'active')
                                          ? Colors.redAccent
                                          : Colors.grey,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    '$point pts',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                              onTap: () {
                                if (status == 'active') {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => VoucherDetailPage(
                                        docId: docId,
                                        title: title,
                                        description: data['description'] ??
                                            'No description',
                                        rules: data['rules'] ?? 'No rules',
                                        imagePath: imageUrl,
                                        point: point,
                                        validUntil: validUntil,
                                      ),
                                    ),
                                  );
                                }
                              },
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
