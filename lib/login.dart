import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:animate_do/animate_do.dart';
import 'package:navigate/forgotPassword.dart';
import 'package:navigate/register.dart';

import 'color.dart';
import 'forgotPassword2.dart';
import 'navigate.dart'; // this is only for testing

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  int activateIndex = 0;
  bool securePassword = true;

  final List<String> _images = [
    'assets/images/1.gif',
    'assets/images/2.gif',
    'assets/images/3.gif',
  ];

  @override
  void initState() {
    super.initState();
    // Automatically cycle through images every 3 seconds
    Future.doWhile(() async {
      await Future.delayed(Duration(seconds: 3));
      if (!mounted) return false;
      setState(() {
        activateIndex = (activateIndex + 1) % _images.length;
      });
      return true;
    });
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
                  height: 300,
                  child: Stack(
                    children: _images.asMap().entries.map((e) {
                      return Positioned.fill(
                        child: AnimatedOpacity(
                          duration: Duration(seconds: 1),
                          opacity: activateIndex == e.key ? 1 : 0,
                          child: Image.asset(
                            e.value,
                            fit: BoxFit.cover, // Auto scales the image
                            //width: double.infinity,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              FadeInUp(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Welcome Back",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w800,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 5,
              ),
              FadeInUp(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Please log in to access your account",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                    ),
                  ),
                ],
              )),
              SizedBox(
                height: 30,
              ),
              FadeInUp(
                  delay: Duration(milliseconds: 800),
                  duration: Duration(milliseconds: 1500),
                  child: TextField(
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                        labelText: "Email",
                        hintText: "Username or email",
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
                            borderSide: BorderSide(
                                color: Colors.grey.shade200, width: 2),
                            borderRadius: BorderRadius.circular(10)),
                        floatingLabelStyle:
                            TextStyle(color: Colors.black, fontSize: 18),
                        focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black, width: 1.5),
                            borderRadius: BorderRadius.circular(10))),
                  )),
              SizedBox(
                height: 20,
              ),
              FadeInUp(
                  delay: Duration(milliseconds: 800),
                  duration: Duration(milliseconds: 1500),
                  child: TextField(
                    obscureText: securePassword,
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                        labelText: "Password",
                        hintText: "Password",
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                        labelStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w400),
                        suffixIcon: togglePassword(),
                        prefixIcon: Icon(
                          Iconsax.key,
                          color: Colors.black,
                          size: 18,
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.grey.shade200, width: 2),
                            borderRadius: BorderRadius.circular(10)),
                        floatingLabelStyle:
                            TextStyle(color: Colors.black, fontSize: 18),
                        focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black, width: 1.5),
                            borderRadius: BorderRadius.circular(10))),
                  )),
              FadeInUp(
                  duration: Duration(milliseconds: 1300),
                  delay: Duration(milliseconds: 800),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ForgotPassword()));
                          },
                          child: Text(
                            "Forgot Password?",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w400),
                          ))
                    ],
                  )),
              SizedBox(
                height: 15,
              ),
              FadeInUp(
                  duration: Duration(milliseconds: 1300),
                  delay: Duration(milliseconds: 800),
                  child: MaterialButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed('/3');
                    },
                    height: 45,
                    minWidth: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    color: button,
                    child: Text(
                      "SIGN IN",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  )),
              SizedBox(
                height: 8,
              ),
              FadeInUp(
                delay: Duration(milliseconds: 800),
                duration: Duration(milliseconds: 1500),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don\'t have an account?",
                      style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 15,
                          fontWeight: FontWeight.w400),
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed('/2');
                        },
                        child: Text(
                          "Register",
                          style: TextStyle(
                              color: Colors.blue,
                              fontSize: 15,
                              fontWeight: FontWeight.w400),
                        ))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget togglePassword() {
    return IconButton(
      onPressed: () {
        setState(() {
          securePassword = !securePassword;
        });
      },
      icon:
          securePassword ? Icon(Icons.visibility) : Icon(Icons.visibility_off),
      color: Colors.grey,
    );
  }
}
