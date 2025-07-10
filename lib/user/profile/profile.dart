import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:navigate/color.dart';
import 'package:navigate/user/profile/FAQs.dart';
import 'package:navigate/user/profile/aboutUs.dart';
import 'package:navigate/user/profile/editProfile.dart';
import 'package:navigate/mainpage.dart';
import 'package:navigate/user/profile/privacyPolicy.dart';
import 'package:navigate/user/profile/termsConditions.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Future<Map<String, String>> fetchUserData() async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null)
        return {
          'username': 'EcoConnect',
          'email': '',
          'address': '',
        };

      final userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (userDoc.exists) {
        final data = userDoc.data()!;
        return {
          'username': data['username'] ?? 'EcoConnect',
          'email': data['email'] ?? '',
          'address': data['address'] ?? '',
          'profileImage': data['profileImage'] ?? ''
        };
      } else {
        return {'username': 'EcoConnect', 'email': '', 'address': ''};
      }
    } catch (e) {
      print('Error fetching user data: $e');
      return {'username': 'EcoConnect', 'email': '', 'address': ''};
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: FutureBuilder<Map<String, String>>(
            future: fetchUserData(),
            builder: (context, snapshot) {
              final username = snapshot.data?['username'] ?? 'EcoConnect';
              final userEmail = snapshot.data?['email'] ?? '';
              final userAddress = snapshot.data?['address'] ?? '';
              final profileImageUrl = snapshot.data?['profileImage'] ?? '';

              return Column(
                children: [
                  // Top Container
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: green3,
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                    ),
                    padding: const EdgeInsets.all(30),
                    child: Column(
                      children: [
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            border: Border.all(
                              color: Colors.white,
                              width: 4,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 6,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: ClipOval(
                            child: Image.network(
                              profileImageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset(
                                  'assets/images/EcoConnect_Logo.png',
                                  fit: BoxFit.cover,
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        snapshot.connectionState == ConnectionState.waiting
                            ? const CircularProgressIndicator(
                                color: Colors.white)
                            : Text(
                                username,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                        const SizedBox(height: 15),
                        if (userEmail.isNotEmpty)
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 15),
                            margin: const EdgeInsets.only(bottom: 10),
                            decoration: BoxDecoration(
                              color: Colors.white24,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.email,
                                    color: Colors.white, size: 20),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    userEmail,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        if (userAddress.isNotEmpty)
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 15),
                            decoration: BoxDecoration(
                              color: Colors.white24,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(Icons.location_on,
                                    color: Colors.white, size: 20),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    userAddress,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),

                  // Bottom Container (White)
                  Container(
                    width: double.infinity,
                    color: back1,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    child: Column(
                      children: [
                        SizedBox(
                          width: 200,
                          child: ElevatedButton(
                            onPressed: () async {
                              final result = await Get.to(() => EditProfile());
                              if (result == true) {
                                setState(
                                    () {}); // ✅ This refreshes the FutureBuilder
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: button,
                              foregroundColor: button,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              "Edit Profile",
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Divider(),
                        ProfileMenuWidget(
                          title: "About Us",
                          icon: Icons.info,
                          onPress: () {
                            Get.to(AboutUs());
                          },
                        ),
                        ProfileMenuWidget(
                          title: "Privacy Policy",
                          icon: Icons.privacy_tip,
                          onPress: () {
                            Get.to(PrivacyPolicy());
                          },
                        ),
                        ProfileMenuWidget(
                          title: "Terms & Conditions",
                          icon: Icons.star,
                          onPress: () {
                            Get.to(TermsConditionsPage());
                          },
                        ),
                        ProfileMenuWidget(
                          title: "FAQs",
                          icon: Icons.question_mark,
                          onPress: () {
                            Get.to(FAQPage());
                          },
                        ),
                        const Divider(),
                        ProfileMenuWidget(
                          title: "Logout",
                          icon: Icons.logout_rounded,
                          textColor: Colors.red,
                          endIcon: false,
                          onPress: () {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MainPage()),
                              (route) => false,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class ProfileMenuWidget extends StatelessWidget {
  const ProfileMenuWidget({
    Key? key,
    required this.title,
    required this.icon,
    required this.onPress,
    this.endIcon = true,
    this.textColor,
  }) : super(key: key);

  final String title;
  final IconData icon;
  final VoidCallback onPress;
  final bool endIcon;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onPress,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: button,
        ),
        child: Icon(icon, color: Colors.white, size: 24),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: textColor ?? Colors.black,
        ),
      ),
      trailing: endIcon
          ? Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: Colors.grey.shade300,
              ),
              child: Icon(Icons.keyboard_arrow_right,
                  size: 18, color: Colors.grey.shade800),
            )
          : null,
    );
  }
}
