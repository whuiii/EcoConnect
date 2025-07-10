import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:navigate/color.dart';
import 'package:navigate/user/ranking.dart/container_ranking.dart';
import 'package:navigate/user/ranking.dart/container_top3_ranking.dart';
import 'package:navigate/user/ranking.dart/redeem/page_redeem.dart';

enum RankingCategory { point, weight, frequency }

class RankingPage extends StatefulWidget {
  const RankingPage({super.key});

  @override
  State<RankingPage> createState() => _RankingPageState();
}

class _RankingPageState extends State<RankingPage> {
  RankingCategory _selectedTab = RankingCategory.point;

  String getSelectedCategoryName() {
    switch (_selectedTab) {
      case RankingCategory.point:
        return 'point';
      case RankingCategory.weight:
        return 'weight';
      case RankingCategory.frequency:
        return 'frequency';
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      return const Scaffold(
        body: Center(
          child: Text("Not logged in"),
        ),
      );
    }

    final userStream = FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.uid)
        .snapshots();

    return StreamBuilder<DocumentSnapshot>(
      stream: userStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        final data = snapshot.data!.data() as Map<String, dynamic>;
        final username = data['username'] ?? 'No Name';
        final point = data['point'] ?? 0;

        return Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                // Top Container
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        green3.withOpacity(0.9), // Original green3 shade
                        green3.withOpacity(0.7), // Slight variation for depth
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      //Profile Image with subtle glow border
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white.withOpacity(0.5),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: ClipOval(
                          child: Image.network(
                            data['profileImage'] ?? '', // from Firestore
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              // Fallback if the image URL is broken or empty
                              return Image.asset(
                                'assets/images/ava.jpg',
                                fit: BoxFit.cover,
                              );
                            },
                          ),
                        ),
                      ),

                      const SizedBox(width: 20),

                      // Username & Points with icon badge
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              username,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 0.5,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.star,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    "Point: $point",
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            SizedBox(
                              height: 28,
                              child: TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const RedeemPage(),
                                    ),
                                  );
                                },
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.symmetric(horizontal: 12),
                                  backgroundColor:
                                      Colors.white.withOpacity(0.2),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                ),
                                child: const Text(
                                  "Click to exchange reward",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    //decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),
                Container(
                  color: back1,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                    children: [
                      Top3RankingSection(
                        category: getSelectedCategoryName(),
                      ),
                      const SizedBox(height: 10),
                      CupertinoSlidingSegmentedControl<RankingCategory>(
                        backgroundColor: CupertinoColors.systemGrey5,
                        thumbColor: _selectedTab == RankingCategory.point
                            ? point_color
                            : _selectedTab == RankingCategory.weight
                                ? weight_color
                                : frequency_color,
                        groupValue: _selectedTab,
                        onValueChanged: (RankingCategory? value) {
                          if (value != null) {
                            setState(() {
                              _selectedTab = value;
                            });
                          }
                        },
                        children: const <RankingCategory, Widget>{
                          RankingCategory.point: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 25),
                            child: Text('Point'),
                          ),
                          RankingCategory.weight: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 25),
                            child: Text('Weight'),
                          ),
                          RankingCategory.frequency: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 25),
                            child: Text('Frequency'),
                          ),
                        },
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: RankingContainer(
                    category: getSelectedCategoryName(),
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
