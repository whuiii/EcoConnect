import 'dart:typed_data'; // Correct import for Uint8List

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';

import '../color.dart';
import '../mainpage.dart';
import '../utilis.dart'; // Assuming this contains your pickImage() function

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  Uint8List? _image;

  void selectImage() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      _image = img;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Edit Profile",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: button,
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(30),
            child: Column(
              children: [
                Stack(
                  children: [
                    _image != null
                        ? CircleAvatar(
                      radius: 60,
                      backgroundImage: MemoryImage(_image!),
                    )
                        : CircleAvatar(
                      radius: 60,
                      backgroundImage:
                      AssetImage('assets/images/EcoConnect_Logo.png'),
                      backgroundColor: Colors.transparent,
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
                        child: IconButton(
                          icon: Icon(Icons.add_a_photo),
                          color: Colors.black,
                          onPressed: selectImage,
                          iconSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Text(
                  "EcoConnect",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
                ),
                Text(
                  "Bio Data: Recycle, Reuse, Reduce",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 30),
                const Divider(),
                SizedBox(height: 10),
                FadeInUp(
                  delay: Duration(milliseconds: 800),
                  duration: Duration(milliseconds: 1500),
                  child: TextField(
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                      labelText: "Username",
                      hintText: "Username",
                      hintStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                      labelStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w400),
                      prefixIcon: Icon(
                        Iconsax.user,
                        color: Colors.black,
                        size: 18,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                        BorderSide(color: Colors.grey.shade200, width: 2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      floatingLabelStyle:
                      TextStyle(color: Colors.black, fontSize: 18),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                        BorderSide(color: Colors.black, width: 1.5),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                FadeInUp(
                  delay: Duration(milliseconds: 800),
                  duration: Duration(milliseconds: 1500),
                  child: TextField(
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                      labelText: "Email",
                      hintText: "Email",
                      hintStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                      labelStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w400),
                      prefixIcon: Icon(
                        Iconsax.sms,
                        color: Colors.black,
                        size: 18,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                        BorderSide(color: Colors.grey.shade200, width: 2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      floatingLabelStyle:
                      TextStyle(color: Colors.black, fontSize: 18),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                        BorderSide(color: Colors.black, width: 1.5),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                FadeInUp(
                  delay: Duration(milliseconds: 800),
                  duration: Duration(milliseconds: 1500),
                  child: TextField(
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                      labelText: "Phone Number",
                      hintText: "Phone Number without -",
                      hintStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                      labelStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w400),
                      prefixIcon: Icon(
                        Iconsax.call,
                        color: Colors.black,
                        size: 18,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                        BorderSide(color: Colors.grey.shade200, width: 2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      floatingLabelStyle:
                      TextStyle(color: Colors.black, fontSize: 18),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                        BorderSide(color: Colors.black, width: 1.5),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: MaterialButton(
                    onPressed: () {
                      // Save profile changes
                    },
                    color: button,
                    padding:
                    EdgeInsets.symmetric(vertical: 12, horizontal: 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      "Edit Profile",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
