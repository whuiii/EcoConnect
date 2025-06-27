import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:navigate/menu.dart';
import 'package:navigate/providers/user_provider.dart';
import 'package:provider/provider.dart';

class VoucherDetailPage extends StatelessWidget {
  final String docId;
  final String title;
  final String description;
  final String rules;
  final String imagePath;
  final int point;
  final DateTime? validUntil;

  const VoucherDetailPage({
    super.key,
    required this.docId,
    required this.title,
    required this.description,
    required this.rules,
    required this.imagePath,
    required this.point,
    required this.validUntil,
  });

  @override
  Widget build(BuildContext context) {
    final validText = validUntil != null
        ? '${validUntil!.day}/${validUntil!.month}/${validUntil!.year}'
        : 'No Expiry Date';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Voucher Details'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          if (imagePath.isNotEmpty)
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  )
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  imagePath,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          const SizedBox(height: 20),
          Text(
            title,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            '$point pts',
            style: TextStyle(
              fontSize: 18,
              color: Colors.orange.shade700,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Valid until: $validText',
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const Divider(height: 32, thickness: 1),
          Text(
            'Description',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: const TextStyle(fontSize: 15, height: 1.5),
          ),
          const SizedBox(height: 24),
          Text(
            'Terms & Conditions',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            rules,
            style: const TextStyle(fontSize: 15, height: 1.5),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: SizedBox(
          height: 50,
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () async {
              try {
                final userId = FirebaseAuth.instance.currentUser?.uid;
                if (userId == null) throw 'User not logged in';

                final userDoc =
                    FirebaseFirestore.instance.collection('users').doc(userId);
                final userSnap = await userDoc.get();
                final currentPoint = userSnap.data()?['point'] ?? 0;

                if (currentPoint < point) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content:
                            Text('Not enough points to redeem this voucher.')),
                  );
                  return;
                }

                // 1. Redeem the voucher
                await FirebaseFirestore.instance
                    .collection('vouchers')
                    .doc(docId)
                    .update({'status': 'redeemed'});

                // 2. Deduct points from the user
                await userDoc.update({'point': currentPoint - point});

                // 3. Refresh provider
                final userProvider =
                    Provider.of<UserProvider>(context, listen: false);
                await userProvider.fetchUser();

                // 4. Feedback
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Voucher redeemed!')),
                );

                // 5. Navigate
                await Future.delayed(const Duration(milliseconds: 500));
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => ProviderPage(initialPage: 0),
                  ),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Failed to redeem: $e'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            label: const Text(
              'Redeem Voucher',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 5,
            ),
          ),
        ),
      ),
    );
  }
}
