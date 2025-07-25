import 'package:flutter/material.dart';
import 'package:navigate/intro_screen/intro1.dart';
import 'package:navigate/intro_screen/intro2.dart';
import 'package:navigate/intro_screen/intro3.dart';
import 'package:navigate/intro_screen/intro4.dart';
import 'package:navigate/intro_screen/intro5.dart';
import 'package:navigate/mainpage.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final PageController _controller = PageController();
  bool onLastPage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // PageView with 5 pages
          PageView(
            controller: _controller,
            onPageChanged: (index) {
              setState(() {
                onLastPage = (index == 4); // Last page index is 4
              });
            },
            children: const [
              IntroPage1(),
              IntroPage2(),
              IntroPage3(),
              IntroPage4(),
              IntroPage5(),
            ],
          ),

          // Navigation bar (Skip - Indicator - Next/Done)
          Align(
            alignment: const Alignment(0, 0.75),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Skip button
                GestureDetector(
                  onTap: () {
                    _controller.jumpToPage(4); // Jump to last page
                  },
                  child: const Text("Skip"),
                ),

                // Page indicator
                SmoothPageIndicator(
                  controller: _controller,
                  count: 5,
                ),

                // Next / Done button
                onLastPage
                    ? GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => MainPage()),
                    );
                  },
                  child: const Text("Done"),
                )
                    : GestureDetector(
                  onTap: () {
                    _controller.nextPage(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeIn,
                    );
                  },
                  child: const Text("Next"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
