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
        body: Center(child: Text("Not logged in")),
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
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final data = snapshot.data!.data() as Map<String, dynamic>;
        final username = data['username'] ?? 'No Name';
        final point = data['point'] ?? 0;

        return Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                // Top Banner
                Container(
                  color: green3,
                  child: Row(
                    children: [
                      // Profile Image
                      Container(
                        width: 100,
                        height: 100,
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(45),
                            child: Image.asset(
                              "assets/images/ava.jpg",
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      // Profile Name
                      Container(
                        width: MediaQuery.of(context).size.width * 0.4,
                        child: Text(
                          username,
                          style: TextName,
                        ),
                      ),
                      const SizedBox(width: 10),
                      // Points
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Point: $point", style: TextPoint),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const RedeemPage(),
                                ),
                              );
                            },
                            child: Text(
                              "Click to exchange reward",
                              style: TextLink,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Top 3 Ranking and Tab Bar
                Container(
                  color: back1,
                  child: Column(
                    children: [
                      Top3RankingSection(category: getSelectedCategoryName()),
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

                // Ranking List
                Expanded(
                  child: RankingContainer(category: getSelectedCategoryName()),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
