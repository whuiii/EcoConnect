import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

class Navigate extends StatefulWidget {
  //const Navigate({super.key});

  @override
  State<Navigate> createState() => _NavigateState();
}

class _NavigateState extends State<Navigate> {
  int index = 2;
  final page = [
    //Home(),
    // Delivery(),
    // Education(),
    // Profile(),
  ];

  @override
  Widget build(BuildContext context) {
    final items = <Widget>[
      Icon(Icons.home,size: 30,),
      Icon(Icons.delivery_dining,size: 30,),
      Icon(Icons.cast_for_education, size: 30,),
      Icon(Icons.person, size: 30,),
    ];
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.blue,
      appBar: AppBar(
        title: Text("Navigation Bar Bottom"),
        elevation: 0,
        centerTitle: true,
      ),
      //body: page[index], // go to the accroding page
      bottomNavigationBar:Theme(data: Theme.of(context).copyWith(
        iconTheme: IconThemeData(color: Colors.black), // icon color
      ), child: CurvedNavigationBar(
        //key: navigationKey,
        color: Colors.green.shade200, // navigation bar color
        buttonBackgroundColor: Colors.green, // backgrond of icon color
        backgroundColor: Colors.transparent,
        height: 60,
        animationCurve: Curves.easeInOut,
        animationDuration: Duration(milliseconds: 300), // make the animation more faster
        index: index,
        items: items,
        onTap: (index) => setState(() => this.index = index),

      ),)

    );
  }
}

