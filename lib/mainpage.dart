import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:navigate/admin/admin_login.dart';
import 'package:navigate/admin/admin_navigation_bar.dart';
import 'package:navigate/color.dart';
import 'package:navigate/login.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  // int activateIndex = 0;
  // Timer? _timer;

  // final List<String> _images = [
  //   'assets/images/1.gif',
  //   'assets/images/2.gif',
  //   'assets/images/3.gif',
  // ];
  //
  // @override
  // void initState() {
  //   super.initState();
  //   _timer = Timer.periodic(Duration(seconds: 3), (timer) {
  //     if (!mounted) return;
  //     setState(() {
  //       activateIndex = (activateIndex + 1) % _images.length;
  //     });
  //   });
  // }
  //
  // @override
  // void dispose() {
  //   _timer?.cancel(); // Clean up timer
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: back1,
            body: Container(
              color: back1,
              //width: double.infinity,
              // decoration: BoxDecoration(
              //     gradient: LinearGradient(begin: Alignment.topCenter, colors: [
              //
              //       Colors.green,
              //       Colors.green.shade300,
              //       Colors.green.shade200,
              //       Colors.green.shade100,
              //       Colors.green.shade50,
              //       Colors.white,
              //     ]
              //     )),
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      SizedBox(height: 25),
                      FadeInUp(
                        duration: Duration(milliseconds: 800),
                        child: Container(
                          height: 380,
                          child:
                              Image.asset('assets/images/EcoConnect_Logo.png'),
                          // child: Stack(
                          //   children: _images.asMap().entries.map((e) {
                          //     return Positioned.fill(
                          //       child: AnimatedOpacity(
                          //         duration: Duration(seconds: 1),
                          //         opacity: activateIndex == e.key ? 1 : 0,
                          //         child: Image.asset(
                          //           e.value,
                          //           fit: BoxFit.cover, // Auto scales the image
                          //           //width: double.infinity,
                          //         ),
                          //       ),
                          //     );
                          //   }).toList(),
                          // ),
                        ),
                      ),
                      FadeInUp(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Welcome to EcoConnect",
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w800,
                                color: primaryColor_darkGreen,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      FadeInUp(
                        child: Text(
                          '''Sort smarter. Track your waste.
Earn rewards for a greener lifestyle.''',
                          textAlign:
                              TextAlign.center, // Optional: center the text
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: primaryColor_darkGreen,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      FadeInUp(
                        delay: Duration(milliseconds: 800),
                        duration: Duration(milliseconds: 1500),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pushNamed('/1');
                                //Get.to(AdminNavigate());
                              },
                              child: Text(
                                "Login as User",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(vertical: 15),
                                backgroundColor: button,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      FadeInUp(
                        delay: Duration(milliseconds: 800),
                        duration: Duration(milliseconds: 1500),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                Get.to(AdminLoginPage());
                              },
                              child: Text(
                                "Login as Company",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(vertical: 15),
                                backgroundColor: button,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )));
  }
}
