import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:navigate/color.dart';
import 'package:flutter/cupertino.dart';
import 'package:navigate/services/user_service.dart';
import 'package:navigate/user/delivery/delivery_form.dart';
import 'package:navigate/user/education/education.dart';

import 'package:navigate/user/profile/profile.dart';

import 'package:navigate/user/ranking.dart/provider_ranking.dart';
import 'package:navigate/user/ranking.dart/top3_ranking.dart';

enum RankingCategory { point, weight, frequency }

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String username = 'Loading...';
  int index = 0;
  int userPoints = 120;
  RankingCategory _selectedTab = RankingCategory.point;
  final page = [
    HomePage(),
    Delivery(), //LoginPage(),
    Education(),
    Profile(),
  ];

  Widget _getTabContent() {
    switch (_selectedTab) {
      case RankingCategory.point:
        return RankingPage(category: 'point');
      case RankingCategory.weight:
        return RankingPage(category: 'weight');
      case RankingCategory.frequency:
        return RankingPage(category: 'frequency');
      default:
        return Center(child: Text('Unknown Page'));
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
              color: primary,
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
                      username,
                      style: TextName,
                    ),
                  ),
                  SizedBox(width: 10),
                  //Points
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Point: $userPoints", style: TextPoint),
                      Text(
                        "Click to exchange reward",
                        style: TextLink,
                      ),
                    ],
                  )
                ],
              ),
            ),
            Container(
              color: primary,
              child:

                  //Rankings
                  Column(
                children: [
                  //Image
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //Image
                      Top3Ranking(
                          size: 70,
                          rank: 2,
                          imagePath: "assets/images/ava.jpg",
                          name: "Recycle Monster",
                          colored: const Color.fromARGB(255, 246, 235, 235)),

                      Top3Ranking(
                          size: 100,
                          rank: 1,
                          imagePath: "assets/images/ava.jpg",
                          name: "Yihong",
                          colored: Colors.yellow),
                      Top3Ranking(
                          size: 70,
                          rank: 3,
                          imagePath: "assets/images/ava.jpg",
                          name: "Mega Knight",
                          colored: Colors.orangeAccent),
                    ],
                  ),
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
              child: _getTabContent(),
            ),
          ],
        ),
      ),
    );
  }
}
