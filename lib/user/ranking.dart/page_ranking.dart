import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:navigate/color.dart';
import 'package:flutter/cupertino.dart';
import 'package:navigate/services/user_service.dart';
import 'package:navigate/user/delivery/delivery_form.dart';
import 'package:navigate/user/education/education.dart';
import 'package:navigate/user/profile/profile.dart';
import 'package:navigate/user/ranking.dart/container_ranking.dart';
import 'package:navigate/user/ranking.dart/container_top3_ranking.dart';

enum RankingCategory { point, weight, frequency }

class RankingPage extends StatefulWidget {
  const RankingPage({super.key});

  @override
  State<RankingPage> createState() => _RankingPageState();
}

class _RankingPageState extends State<RankingPage> {
  String? username;
  int index = 0;
  int? userpoint;
  RankingCategory _selectedTab = RankingCategory.point;
  final page = [
    RankingPage(),
    Delivery(),
    Education(),
    Profile(),
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

  final items = <Widget>[
    Icon(Icons.home, size: 30),
    Icon(Icons.delivery_dining, size: 30),
    Icon(Icons.cast_for_education, size: 30),
    Icon(Icons.person, size: 30),
  ];

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  void loadUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String uid = user.uid;
      final userService = UserService();
      Map<String, dynamic>? userData = await userService.getUserProfile(uid);
      setState(() {
        username = userData?['username'] ?? 'No Name';
        userpoint = userData?['point'] ?? '0';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            //Top Bar
            Container(
              color: green3,
              child: Row(
                children: [
                  //Profile Image
                  Container(
                    width: 100,
                    height: 100,
                    child: Padding(
                      padding: EdgeInsets.all(
                          15), // Adjust Padding to change the image size
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(
                            45), // slightly smaller radius
                        child: Image.asset(
                          "assets/images/ava.jpg",
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  //Profile Name
                  Container(
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: Text(
                      username ?? '',
                      style: TextName,
                    ),
                  ),
                  SizedBox(width: 10),
                  //Points
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Point: $userpoint", style: TextPoint),
                      Text(
                        "Click to exchange reward",
                        style: TextLink,
                      ),
                    ],
                  )
                ],
              ),
            ),
            SizedBox(height: 20),
            Container(
              color: back1,
              child:

                  //Rankings
                  Column(
                children: [
                  //Image
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

                    //TabPage for Ranking Category
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
