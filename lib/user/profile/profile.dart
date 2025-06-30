import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:navigate/color.dart';
import 'package:navigate/user/profile/FAQs.dart';
import 'package:navigate/user/profile/aboutUs.dart';
import 'package:navigate/user/profile/editProfile.dart';
import 'package:navigate/mainpage.dart';
import 'package:navigate/user/profile/privacyPolicy.dart';
import 'package:navigate/user/profile/termsConditions.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              // Top Container
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: green3,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                padding: const EdgeInsets.all(30),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white, // Background color behind the image
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
                            child: Image.asset(
                              'assets/images/EcoConnect_Logo.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: Colors.grey.shade300,
                            ),
                            child: Icon(
                              Icons.edit,
                              size: 18,
                              color: Colors.grey.shade800,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),
                    const Text(
                      "EcoConnect",
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w700,
                          color: Colors.white),
                    ),
                    const Text(
                      "Bio Data: Recycle, Reuse, Reduce",
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.white),
                    ),
                    // const SizedBox(height: 20),
                  ],
                ),
              ),

              // Bottom Container (White)
              Container(
                width: double.infinity,
                color: back1,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  children: [
                    SizedBox(
                      width: 200,
                      child: ElevatedButton(
                        onPressed: () {
                          Get.to(EditProfile());
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
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    const Divider(),
                    const SizedBox(height: 10),
                    // ProfileMenuWidget(
                    //   title: "Settings",
                    //   icon: Icons.settings,
                    //   onPress: () {},
                    // ),
                    // const Divider(),
                    // const SizedBox(height: 10),
                    ProfileMenuWidget(
                      title: "About Us",
                      icon: Icons.info,
                      onPress: () {
                        print("Tap on About Us");
                        Get.to(AboutUs());

                      },
                    ),
                    const Divider(),
                    ProfileMenuWidget(
                      title: "Privacy Policy",
                      icon: Icons.privacy_tip,
                      onPress: () {
                        print("Tap on Privacy Policy");
                        Get.to(PrivacyPolicy());
                      },
                    ),
                    ProfileMenuWidget(
                      title: "Terms & Conditions",
                      icon: Icons.star,
                      onPress: () {
                        print("Tap on Terms and Conditions");
                        Get.to(TermsConditionsPage());
                      },
                    ),
                    ProfileMenuWidget(
                      title: "FAQs",
                      icon: Icons.question_mark,
                      onPress: () {
                        print("Tap on FAQs");
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
                          MaterialPageRoute(builder: (context) => MainPage()),
                          (route) => false,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
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
