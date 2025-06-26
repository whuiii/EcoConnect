import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:navigate/color.dart';
import 'package:navigate/providers/user_provider.dart';
import 'package:navigate/user/ranking.dart/container_ranking.dart';
import 'package:navigate/user/ranking.dart/container_top3_ranking.dart';
import 'package:navigate/user/ranking.dart/redeem/page_redeem.dart';
import 'package:provider/provider.dart';

enum RankingCategory { point, weight, frequency }

class RankingPage extends StatefulWidget {
  const RankingPage({super.key});

  @override
  State<RankingPage> createState() => _RankingPageState();
}

class _RankingPageState extends State<RankingPage> {
  int index = 0;
  RankingCategory _selectedTab = RankingCategory.point;

  final items = <Widget>[
    Icon(Icons.home, size: 30),
    Icon(Icons.delivery_dining, size: 30),
    Icon(Icons.cast_for_education, size: 30),
    Icon(Icons.person, size: 30),
  ];

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
    final user = Provider.of<UserProvider>(context).user;

    if (user == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar
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
                      user.username ?? 'No Name',
                      style: TextName,
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Points
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Point: ${user.point}", style: TextPoint),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RedeemPage(),
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
            Container(
              color: back1,
              child: Column(
                children: [
                  // Top 3 Ranking Images
                  Top3RankingSection(category: getSelectedCategoryName()),
                  // Ranking Category Tabs
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
              child: RankingContainer(category: getSelectedCategoryName()),
            ),
          ],
        ),
      ),
    );
  }
}
