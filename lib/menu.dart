import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:navigate/color.dart';
import 'package:navigate/delivery/delivery.dart';
import 'package:navigate/delivery/delivery_form.dart';
import 'package:navigate/delivery/page_delivery.dart';
import 'package:navigate/education/education.dart';
import 'package:navigate/forgotPassword.dart';
import 'package:navigate/home.dart';
import 'package:navigate/login.dart';
import 'package:navigate/profile/profile.dart';
import 'package:navigate/register.dart';

import 'package:provider/provider.dart';

class ProviderPage extends StatefulWidget {
  final int initialPage;
  const ProviderPage({super.key, this.initialPage = 0});

  @override
  State<ProviderPage> createState() => _ProviderPageState();
}

class _ProviderPageState extends State<ProviderPage> {
  late int currentPage;
  late int index;

  final List<Widget> pages = [
    HomePage(),
    DeliveryRequest(),
    Education(),
    Profile(),
  ];

  final items = <Widget>[
    Icon(Icons.home, size: 30),
    Icon(Icons.delivery_dining, size: 30),
    Icon(Icons.cast_for_education, size: 30),
    Icon(Icons.person, size: 30),
  ];
  @override
  void initState() {
    super.initState();
    currentPage = widget.initialPage;
    index = widget.initialPage;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: pages[currentPage],
        bottomNavigationBar: Theme(
          data: Theme.of(context).copyWith(
            iconTheme: IconThemeData(color: Colors.white), // icon color
          ),
          child: CurvedNavigationBar(
            backgroundColor: Colors.transparent,
            //key: navigationKey,
            color: button, // navigation bar color
            buttonBackgroundColor:
                primaryColor_darkGreen, // backgrond of icon color

            height: 60,
            animationCurve: Curves.easeInOut,
            animationDuration:
                Duration(milliseconds: 300), // make the animation more faster
            index: index,
            items: items,
            onTap: (index) => setState(() {
              this.index = index;
              currentPage = index;
            }),
          ),
        ));
  }
}
