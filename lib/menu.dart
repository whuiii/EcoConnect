import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:navigate/color.dart';
import 'package:navigate/delivery/page_delivery.dart';
import 'package:navigate/forgotPassword.dart';
import 'package:navigate/home.dart';
import 'package:navigate/login.dart';
import 'package:navigate/profile.dart';
import 'package:navigate/register.dart';

import 'package:provider/provider.dart';

class ProviderPage extends StatefulWidget {
  const ProviderPage({super.key});

  @override
  State<ProviderPage> createState() => _ProviderPageState();
}

class _ProviderPageState extends State<ProviderPage> {
  final List<Widget> pages = [
    HomePage(),
    DeliveryForm(),
    RegisterPage(),
    Profile(),
  ];
  int currentPage = 0;
  int index = 0;
  final items = <Widget>[
    Icon(Icons.home, size: 30),
    Icon(Icons.delivery_dining, size: 30),
    Icon(Icons.cast_for_education, size: 30),
    Icon(Icons.person, size: 30),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: pages[currentPage],
        bottomNavigationBar: Theme(
          data: Theme.of(context).copyWith(
            iconTheme: IconThemeData(color: Colors.white), // icon color
          ),
          child: CurvedNavigationBar(
            //key: navigationKey,
            color: button, // navigation bar color
            buttonBackgroundColor: primaryColor_darkGreen, // backgrond of icon color
            backgroundColor: Colors.transparent,
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
        )

        // bottomNavigationBar: BottomNavigationBar(
        //   currentIndex: currentPage,
        //   onTap: (value) {
        //     setState(() {
        //       currentPage = value;
        //     });
        //   },
        //   items: const [
        //     BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        //     BottomNavigationBarItem(icon: Icon(Icons.edit), label: "Edit"),
        //     BottomNavigationBarItem(
        //         icon: Icon(Icons.calculate), label: "Calculation")
        //   ],
        // ),
        );
  }
}
