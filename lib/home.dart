import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:navigate/color.dart';
import 'package:flutter/cupertino.dart';
import 'package:navigate/login.dart';
import 'package:navigate/profile.dart';
import 'package:navigate/ranking.dart/provider_ranking.dart';

enum RankingCategory { point, weight, frequency }

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int index = 0;
  int userPoints = 120;
  RankingCategory _selectedTab = RankingCategory.point;
  final page = [
    HomePage(),
    LoginPage(),
    // Frequency(),
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
                        "Chong Yi Hong bt Mohammad Ashraf",
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
                    CupertinoSlidingSegmentedControl<RankingCategory>(
                  backgroundColor: CupertinoColors.systemGrey5,
                  thumbColor: _selectedTab == RankingCategory.point
                      ? Colors.green
                      : _selectedTab == RankingCategory.weight
                          ? Colors.blue
                          : Colors.orange,
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
