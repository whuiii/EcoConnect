import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:navigate/color.dart';
import 'package:navigate/user/education/diy.dart';
import 'package:navigate/user/education/funFact.dart';
import 'package:navigate/user/education/news.dart';
import 'package:navigate/user/education/paper.dart';
import 'package:navigate/user/education/wasteSort.dart';

class Education extends StatefulWidget {
  const Education({super.key});

  @override
  State<Education> createState() => _EducationState();
}

class _EducationState extends State<Education> {
  final List<Map<String, dynamic>> categories = [
    {
      "image": "assets/images/FunFact.png",
      "onTap": () {
        Get.to(()=> FunFactPage());
        print("Tapped on Fun Fact");
      }
    },
    // {
    //   "image": "assets/images/Tips.png",
    //   "onTap": () {
    //     print("Tapped on Recycle Tips");
    //   }
    // },
    {
      "image": "assets/images/News.png",
      "onTap": () {
        print("Tapped on News");
        Get.to(() => News());
      }
    },
    {
      "image": "assets/images/DIY.png",
      "onTap": () {
        print("Tapped on DIY video");
        Get.to(() => DiyVideo());
      }
    },
  ];

  final List<String> labels = [
    "Fun Fact",
    //"Recycle Tips",
    "News",
    "DIY Video",
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Education"),
          automaticallyImplyLeading: false,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 25),
            child: Column(
              children: [
                // Top Banner Button
                Container(
                  margin: const EdgeInsets.fromLTRB(20, 10, 20, 20), // LEFT, TOP, RIGHT, BOTTOM
                  height: 300,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(
                      colors: [
                        Colors.greenAccent.withOpacity(0.6),
                        Colors.lightGreenAccent.withOpacity(0.3),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.green.withOpacity(0.3),
                        blurRadius: 12,
                        spreadRadius: 2,
                        offset: Offset(0, 6),
                      ),
                    ],
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () {
                      Get.to(WasteSort());
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Stack(
                        children: [
                          // Lottie Animation in the background
                          Positioned.fill(
                            child: Lottie.asset(
                              'assets/images/Sort.json',
                              fit: BoxFit.cover,
                              repeat: true,
                            ),
                          ),
                          // Semi-transparent overlay for better text contrast
                          Container(
                            color: Colors.black.withOpacity(0.15),
                          ),
                          // Centered title text
                          Center(
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.45),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 8,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: const Text(
                                'How to sort?',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 30,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 1.2,
                                  shadows: [
                                    Shadow(
                                      offset: Offset(1, 1),
                                      blurRadius: 5,
                                      color: Colors.black54,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 15),

                // Categories Title
                Padding(
                  padding: const EdgeInsets.only(left: 23),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Categories",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 20),

                // Custom 3-Button Layout with Fixed Height
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SizedBox(
                    height: 250,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Left Rectangle Button - DIY Video (now index 3)
                        Expanded(
                          flex: 2,
                          child: InkWell(
                            onTap: categories[2]['onTap'],
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              margin: EdgeInsets.only(right: 10),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade400,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: EdgeInsets.all(10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: Image.asset(
                                        categories[2]['image'],
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    labels[2],
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        // Right Column with 2 Equal Width Square Buttons
                        Expanded(
                          flex: 2,
                          child: Column(
                            children: [
                              Expanded(
                                child: InkWell(
                                  onTap: categories[0]['onTap'],
                                  borderRadius: BorderRadius.circular(20),
                                  child: Container(
                                    width: 150,
                                    //margin: EdgeInsets.only(left: 3),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade400,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    padding: EdgeInsets.all(5),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(20),
                                            child: Image.asset(
                                              categories[0]['image'],
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          labels[0],
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10), // Space between buttons
                              Expanded(
                                child: InkWell(
                                  onTap: categories[1]['onTap'],
                                  borderRadius: BorderRadius.circular(20),
                                  child: Container(
                                    width: 150,
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade400,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    padding: EdgeInsets.all(5),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(20),
                                            child: Image.asset(
                                              categories[1]['image'],
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          labels[1],
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
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
                ),

                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
