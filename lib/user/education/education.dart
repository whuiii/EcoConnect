import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:navigate/color.dart';
import 'package:navigate/user/education/diy.dart';
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
        print("Tapped on Fun Fact");
      }
    },
    {
      "image": "assets/images/Tips.png",
      "onTap": () {
        print("Tapped on Recycle Tips");
      }
    },
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
    "Recycle Tips",
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: SizedBox(
                    width: double.infinity,
                    height: 300,
                    child: MaterialButton(
                      onPressed: () {
                        Get.to(WasteSort());
                      },
                      color: button.withOpacity(0.3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: EdgeInsets.zero,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Stack(
                          children: [
                            Align(
                              alignment: Alignment(0, 0.6),
                              child: Image.asset(
                                "assets/images/SortWaste.png",
                                width: 300,
                                height: 300,
                                fit: BoxFit.contain,
                              ),
                            ),
                            Container(
                              alignment: Alignment.topCenter,
                              padding: EdgeInsets.only(top: 10),
                              child: Text(
                                'How to sort?',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  shadows: [
                                    Shadow(
                                      offset: Offset(1, 1),
                                      blurRadius: 2,
                                      color: Colors.black45,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 20),

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
                            onTap: categories[3]['onTap'],
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
                                        categories[3]['image'],
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    labels[3],
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
                                  onTap: categories[2]['onTap'],
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
                                              categories[2]['image'],
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 5),
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
