import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:navigate/intro_screen/intro1.dart';
import 'package:navigate/intro_screen/intro2.dart';
import 'package:navigate/intro_screen/intro3.dart';
import 'package:navigate/mainpage.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  //controller keep track of which page
  PageController _controller = PageController();

  bool onLastPage = false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _controller,
            onPageChanged: (index){
              setState(() {
                onLastPage = (index == 2);
              });
            },
            children: [
              IntroPage1(),
              IntroPage2(),
              IntroPage3(),
            ],
          ),

          //indicator
          Container(
            alignment: Alignment(0, 0.75), // 0.
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  //skip
                  GestureDetector(
                    onTap:(){
                      _controller.jumpToPage(2);
                      //Get.to(MainPage());
                      },
                      child: Text("Skip"),
                  ),

                  //indicator
                  SmoothPageIndicator(
                      controller: _controller, count: 3 //pages
                  ),

                  //continue
                  onLastPage?
                  GestureDetector(onTap:(){
                    Navigator.push(context, MaterialPageRoute(builder: (context){
                      return MainPage();
                    }),
                    );
                  }, child: Text("Done"),
                  ):
                  GestureDetector(onTap:(){
                    _controller.nextPage(
                        duration: Duration(milliseconds: 500),
                        curve: Curves.easeIn);
                  }, child: Text("Next"),
                  ),
                ],
              ),
          ),
        ],
      )
    );
  }
}
