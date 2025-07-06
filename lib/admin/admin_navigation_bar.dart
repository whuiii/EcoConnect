import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:navigate/admin/admin%20profile/admin_profile.dart';
import 'package:navigate/admin/dashboard.dart';
import 'package:navigate/admin/pickup_page.dart';
import 'package:navigate/color.dart';
import 'package:navigate/models/user_model.dart';

import 'package:navigate/user/ranking.dart/cubit_ranking.dart';

import 'package:navigate/user/profile/profile.dart';

class AdminNavigate extends StatefulWidget {
  final int initialPage;
  const AdminNavigate({super.key, this.initialPage = 0});

  @override
  State<AdminNavigate> createState() => _AdminNavigateState();
}

class _AdminNavigateState extends State<AdminNavigate> {
  late int currentPage;
  late int index;
  bool _isLoading = true;
  UserModel? currentUser;

  final List<Widget> pages = [
    BlocProvider(
      create: (context) => RankingCubit()..fetchRankings(),
      child: AdminDashboard(),
    ),
    AdminDeliveryRequest(),
    AdminProfile(),
  ];

  final items = <Widget>[
    Icon(Icons.home, size: 30),
    Icon(Icons.delivery_dining, size: 30),
    Icon(Icons.person, size: 30),
  ];
  @override
  void initState() {
    super.initState();
    currentPage = widget.initialPage;
    index = widget.initialPage;
    // fetchUserData();
  }

  // Future<void> fetchUserData() async {
  //   final user = FirebaseAuth.instance.currentUser;
  //   if (user != null) {
  //     final doc = await FirebaseFirestore.instance
  //         .collection('users')
  //         .doc(user.uid)
  //         .get();

  //     if (doc.exists) {
  //       setState(() {
  //         currentUser = UserModel.fromMap(doc.data()!);
  //         _isLoading = false;
  //       });
  //     }
  //   }
  // }

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
