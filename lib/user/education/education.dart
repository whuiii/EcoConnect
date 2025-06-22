import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:navigate/color.dart';
import 'package:navigate/user/education/diy.dart';
import 'package:navigate/user/education/paper.dart';
import 'package:navigate/user/education/wasteSort.dart'; // Ensure this file defines the 'button' color variable

class Education extends StatefulWidget {
  const Education({super.key});

  @override
  State<Education> createState() => _EducationState();
}

class _EducationState extends State<Education> {
  // Define category items with image and function
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
          automaticallyImplyLeading: false, // hide the go back icon button
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Top Banner Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: SizedBox(
                    width: double.infinity,
                    height: 300,
                    child: MaterialButton(
                      onPressed: () {
                        //print("Sorting education tapped");
                        Get.to(WasteSort());
                        //Get.to(WasteEducationScreen());
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

                // Grid Buttons
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: GridView.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 15,
                    crossAxisSpacing: 15,
                    childAspectRatio: 1,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    children: categories.asMap().entries.map((entry) {
                      int index = entry.key;
                      Map<String, dynamic> category = entry.value;

                      return InkWell(
                        onTap: category['onTap'],
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
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
                                    category['image'],
                                    width: 250,
                                    height: 250,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                labels[index],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
