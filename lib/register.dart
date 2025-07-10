//import 'dart:nativewrappers/_internal/vm/lib/typed_data_patch.dart';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:navigate/services/user_service.dart';
import 'package:navigate/utilis.dart';

import 'color.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  Uint8List? _image;

  void selectImage() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      _image = img;
    });
  }

  int activateIndex = 0;
  bool securePassword = true;
  bool? isChecked = false;

  // Controllers to get input values
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  // Password conditionss
  bool _isPasswordEightCharacters = false;
  bool _hasPasswordOneNumber = false;

  onPasswordChanged(String password) {
    final numericRegex = RegExp(r'[0-9]');
    setState(() {
      _isPasswordEightCharacters = password.length >= 8;
      _hasPasswordOneNumber = numericRegex.hasMatch(password);
    });
  }

  final List<String> _images = [
    'assets/images/1.gif',
    'assets/images/2.gif',
    'assets/images/3.gif',
  ];

  //Upload to Storage
  Future<String> uploadImageToStorage(Uint8List image) async {
    final ref = FirebaseStorage.instance
        .ref()
        .child('profileImages')
        .child('${DateTime.now().millisecondsSinceEpoch}.jpg');

    UploadTask uploadTask = ref.putData(image); // ✅ Correct for Uint8List
    TaskSnapshot snap = await uploadTask;

    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }

  @override
  void initState() {
    super.initState();
    Future.doWhile(() async {
      await Future.delayed(Duration(seconds: 3));
      if (!mounted) return false;
      setState(() {
        activateIndex = (activateIndex + 1) % _images.length;
      });
      return true;
    });
  }

  final userService = UserService();
  void handleRegister() async {
    String imageUrl = '';

    if (_image != null) {
      imageUrl = await uploadImageToStorage(_image!);
    }
    String? result = await userService.registerUser(
      email: emailController.text.trim(),
      password: passwordController.text,
      confirmPassword: confirmPasswordController.text,
      username: usernameController.text.trim(),
      phone: phoneController.text.trim(),
      profileImage: imageUrl,
    );

    if (result == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Registration successful!")));
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(result)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              SizedBox(height: 40),
              FadeInUp(
                duration: Duration(milliseconds: 800),
                child: Container(
                  padding: const EdgeInsets.all(30),
                  //height: ,
                  child: Stack(
                    children: [
                      _image != null
                          ? CircleAvatar(
                              radius: 60,
                              backgroundImage: MemoryImage(_image!),
                            )
                          : CircleAvatar(
                              radius: 60,
                              backgroundImage: AssetImage(
                                  'assets/images/EcoConnect_Logo.png'),
                              //backgroundColor: Colors.transparent,
                              backgroundColor: Colors.grey.shade200,
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
                  // Stack(
                  //   children: _images.asMap().entries.map((e) {
                  //     return Positioned.fill(
                  //       child: AnimatedOpacity(
                  //         duration: Duration(seconds: 1),
                  //         opacity: activateIndex == e.key ? 1 : 0,
                  //         child: Image.asset(
                  //           e.value,
                  //           fit: BoxFit.cover,
                  //         ),
                  //       ),
                  //     );
                  //   }).toList(),
                  // ),
                ),
              ),
              SizedBox(height: 5),
              FadeInUp(
                child: Text("Welcome New User",
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w800,
                        color: Colors.black)),
              ),
              SizedBox(height: 5),
              FadeInUp(
                  child: Text("Sign up to create account",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey))),
              SizedBox(height: 30),
              FadeInUp(
                delay: Duration(milliseconds: 800),
                duration: Duration(milliseconds: 1500),
                child: TextField(
                  controller: usernameController,
                  cursorColor: Colors.black,
                  decoration: inputDecoration("Username", Iconsax.user),
                ),
              ),
              SizedBox(height: 20),
              FadeInUp(
                delay: Duration(milliseconds: 800),
                duration: Duration(milliseconds: 1500),
                child: TextField(
                  controller: emailController,
                  cursorColor: Colors.black,
                  decoration: inputDecoration("Email", Iconsax.sms),
                ),
              ),
              SizedBox(height: 20),
              FadeInUp(
                delay: Duration(milliseconds: 800),
                duration: Duration(milliseconds: 1500),
                child: TextField(
                  controller: phoneController,
                  cursorColor: Colors.black,
                  decoration: inputDecoration("Phone Number", Iconsax.call),
                ),
              ),
              SizedBox(height: 20),
              FadeInUp(
                delay: Duration(milliseconds: 800),
                duration: Duration(milliseconds: 1500),
                child: TextField(
                  controller: passwordController,
                  onChanged: onPasswordChanged,
                  obscureText: securePassword,
                  cursorColor: Colors.black,
                  decoration: inputDecoration("Password", Iconsax.key)
                      .copyWith(suffixIcon: togglePassword()),
                ),
              ),
              SizedBox(height: 10),
              FadeInUp(
                  delay: Duration(milliseconds: 800),
                  duration: Duration(milliseconds: 1500),
                  child: Row(
                    children: [
                      passwordRequirementCheck(
                          _isPasswordEightCharacters, "At least 8 characters"),
                    ],
                  )),
              SizedBox(height: 10),
              FadeInUp(
                  delay: Duration(milliseconds: 800),
                  duration: Duration(milliseconds: 1500),
                  child: Row(
                    children: [
                      passwordRequirementCheck(
                          _hasPasswordOneNumber, "At least 1 number"),
                    ],
                  )),
              SizedBox(height: 20),
              FadeInUp(
                delay: Duration(milliseconds: 800),
                duration: Duration(milliseconds: 1500),
                child: TextField(
                  controller: confirmPasswordController,
                  obscureText: securePassword,
                  cursorColor: Colors.black,
                  decoration: inputDecoration("Confirm Password", Iconsax.lock)
                      .copyWith(suffixIcon: togglePassword()),
                ),
              ),
              SizedBox(height: 20),
              FadeInUp(
                delay: Duration(milliseconds: 800),
                duration: Duration(milliseconds: 1500),
                child: Row(
                  children: [
                    Checkbox(
                        value: isChecked,
                        onChanged: (val) {
                          setState(() {
                            isChecked = val;
                          });
                        }),
                    Text("I agree to the Terms and Privacy Policy")
                  ],
                ),
              ),
              FadeInUp(
                duration: Duration(milliseconds: 1300),
                delay: Duration(milliseconds: 800),
                child: MaterialButton(
                  onPressed: handleRegister,
                  height: 45,
                  minWidth: double.infinity,
                  color: button,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: Text("SIGN UP",
                      style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
              ),
              SizedBox(height: 10),
              FadeInUp(
                delay: Duration(milliseconds: 800),
                duration: Duration(milliseconds: 1500),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already have an account?",
                        style: TextStyle(color: Colors.grey)),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed('/1');
                        },
                        child: Text("Login",
                            style: TextStyle(color: Colors.blue))),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      hintText: label,
      hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
      labelStyle: TextStyle(
          color: Colors.black, fontSize: 14, fontWeight: FontWeight.w400),
      prefixIcon: Icon(icon, color: Colors.black, size: 18),
      enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade200, width: 2),
          borderRadius: BorderRadius.circular(10)),
      floatingLabelStyle: TextStyle(color: Colors.black, fontSize: 18),
      focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black, width: 1.5),
          borderRadius: BorderRadius.circular(10)),
    );
  }

  Widget passwordRequirementCheck(bool condition, String text) {
    return Row(
      children: [
        AnimatedContainer(
          duration: Duration(milliseconds: 500),
          width: 15,
          height: 15,
          decoration: BoxDecoration(
            color: condition ? Colors.green : Colors.transparent,
            border: Border.all(
                color: condition ? Colors.transparent : Colors.grey.shade400),
            borderRadius: BorderRadius.circular(50),
          ),
          child: condition
              ? Icon(Icons.check, color: Colors.white, size: 15)
              : SizedBox(),
        ),
        SizedBox(width: 10),
        Text(text),
      ],
    );
  }

  Widget togglePassword() {
    return IconButton(
      onPressed: () {
        setState(() {
          securePassword = !securePassword;
        });
      },
      icon: Icon(securePassword ? Icons.visibility : Icons.visibility_off,
          color: Colors.grey),
    );
  }
}
