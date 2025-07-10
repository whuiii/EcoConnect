import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:navigate/color.dart';
import 'package:navigate/mainpage.dart';
import 'package:navigate/user/profile/FAQs.dart';
import 'package:navigate/user/profile/aboutUs.dart';
import 'package:navigate/user/profile/privacyPolicy.dart';
import 'package:navigate/user/profile/termsConditions.dart';

import 'admin_editprofile.dart';

class AdminProfile extends StatefulWidget {
  const AdminProfile({super.key});

  @override
  State<AdminProfile> createState() => _AdminProfileState();
}

class _AdminProfileState extends State<AdminProfile> {
  // Fallback mock company data
  final String companyName = "EcoWaste Management Sdn Bhd";

  final String registrationNumber = "SSM 1234567";

  final String companyEmail = "info@ecowaste.com";

  final String companyAddress =
      "123 Green Street, Eco City, Selangor, Malaysia";

  final String companyLogo = "";
  // default empty
  Future<Map<String, String>> fetchCompanyData() async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null)
        return {
          'companyName': '',
          'email': '',
          'address': '',
          'registrationNumber': '',
          'companyLogo': '',
        };

      final userDoc = await FirebaseFirestore.instance
          .collection('companies')
          .doc(uid)
          .get();

      if (userDoc.exists) {
        final data = userDoc.data()!;
        return {
          'companyName': data['companyName'] ?? '',
          'email': data['email'] ?? '',
          'address': data['address'] ?? '',
          'registrationNumber': data['registrationNumber'] ?? '',
          'companyLogo': data['companyLogo'] ?? '',
        };
      } else {
        return {
          'companyName': '',
          'email': '',
          'address': '',
          'registrationNumber': '',
          'companyLogo': '',
        };
      }
    } catch (e) {
      print('Error fetching user data: $e');
      return {
        'companyName': '',
        'email': '',
        'address': '',
        'registrationNumber': '',
        'companyLogo': '',
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              FutureBuilder<Map<String, String>>(
                future: fetchCompanyData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return SizedBox(
                      height: 300,
                      child: Center(child: CircularProgressIndicator()),
                    );
                  } else if (snapshot.hasError || !snapshot.hasData) {
                    return Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        "Error loading company data",
                        style: TextStyle(color: Colors.red),
                      ),
                    );
                  } else {
                    final data = snapshot.data!;
                    return _buildTopContainer(
                      companyName: data['companyName']!.isNotEmpty
                          ? data['companyName']!
                          : companyName,
                      registrationNumber: data['registrationNumber']!.isNotEmpty
                          ? data['registrationNumber']!
                          : registrationNumber,
                      companyEmail: data['email']!.isNotEmpty
                          ? data['email']!
                          : companyEmail,
                      companyAddress: data['address']!.isNotEmpty
                          ? data['address']!
                          : companyAddress,
                      companyLogo: data['companyLogo']!,
                    );
                  }
                },
              ),
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
                        onPressed: () async {
                          final result =
                              await Get.to(() => const AdminEditProfile());
                          if (result == true) {
                            setState(
                                () {}); // ✅ This refreshes the FutureBuilder
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: button,
                          padding: const EdgeInsets.symmetric(vertical: 12),
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

  Widget _buildTopContainer({
    required String companyName,
    required String registrationNumber,
    required String companyEmail,
    required String companyAddress,
    required String companyLogo,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: green3,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(30, 20, 30, 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                "Reg. No: $registrationNumber",
                style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.white),
              ),
            ),
          ),
          const SizedBox(height: 15),
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              border: Border.all(color: Colors.white, width: 4),
              boxShadow: [
                BoxShadow(
                    color: Colors.black26, blurRadius: 6, offset: Offset(0, 3)),
              ],
            ),
            child: ClipOval(
              child: companyLogo.isNotEmpty
                  ? Image.network(
                      companyLogo,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset('assets/images/EcoConnect_Logo.png',
                            fit: BoxFit.cover);
                      },
                    )
                  : Image.asset('assets/images/EcoConnect_Logo.png',
                      fit: BoxFit.cover),
            ),
          ),
          const SizedBox(height: 15),
          Text(
            companyName,
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontSize: 24, fontWeight: FontWeight.w700, color: Colors.white),
          ),
          const SizedBox(height: 15),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            margin: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
                color: Colors.white24, borderRadius: BorderRadius.circular(10)),
            child: Row(
              children: [
                const Icon(Icons.email, color: Colors.white, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(companyEmail,
                      style:
                          const TextStyle(fontSize: 15, color: Colors.white)),
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            decoration: BoxDecoration(
                color: Colors.white24, borderRadius: BorderRadius.circular(10)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.location_on, color: Colors.white, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(companyAddress,
                      style:
                          const TextStyle(fontSize: 15, color: Colors.white)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ✅ Keep your ProfileMenuWidget the same:
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
