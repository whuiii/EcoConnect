import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:iconsax/iconsax.dart';
import 'package:animate_do/animate_do.dart';
import 'package:navigate/admin/admin_navigation_bar.dart';
import 'package:navigate/admin/admin_profile.dart';
import 'package:navigate/admin/dashboard.dart';
import 'package:navigate/services/auth.dart';
import 'package:navigate/forgotPassword.dart';
import 'package:navigate/register.dart';

import '../color.dart';
import 'admin_register.dart';



class AdminLoginPage extends StatefulWidget {
  @override
  _AdminLoginPageState createState() => _AdminLoginPageState();
}

class _AdminLoginPageState extends State<AdminLoginPage> {
  int activateIndex = 0;
  bool securePassword = true;
  bool loading = false;
  final List<String> _images = [
    'assets/images/1.gif',
    'assets/images/2.gif',
    'assets/images/3.gif',
  ];

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

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

  void _signIn() async {
    setState(() => loading = true);

    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showMessage("Please enter email and password");
      setState(() => loading = false);
      return;
    }

    final userCredential =
    await AuthService().signInWithEmailAndPassword(email, password);

    setState(() => loading = false);

    if (userCredential != null) {
      _showMessage("Login successful");
      Navigator.of(context).pushNamed('/3');
    } else {
      _showMessage("Invalid credentials. Please try again.");
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
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
                      "Company Login",
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
                  controller: emailController, // <-- Added controller
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                    labelText: "Email",
                    hintText: "Username or email",
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                    labelStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w400),
                    prefixIcon:
                    Icon(Iconsax.user, color: Colors.black, size: 18),
                    enabledBorder: OutlineInputBorder(
                        borderSide:
                        BorderSide(color: Colors.grey.shade200, width: 2),
                        borderRadius: BorderRadius.circular(10)),
                    floatingLabelStyle:
                    TextStyle(color: Colors.black, fontSize: 18),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 1.5),
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
              SizedBox(height: 20),
              FadeInUp(
                delay: Duration(milliseconds: 800),
                duration: Duration(milliseconds: 1500),
                child: TextField(
                  controller: passwordController, // <-- Added controller
                  obscureText: securePassword,
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                    labelText: "Password",
                    hintText: "Password",
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                    labelStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w400),
                    suffixIcon: togglePassword(),
                    prefixIcon:
                    Icon(Iconsax.key, color: Colors.black, size: 18),
                    enabledBorder: OutlineInputBorder(
                        borderSide:
                        BorderSide(color: Colors.grey.shade200, width: 2),
                        borderRadius: BorderRadius.circular(10)),
                    floatingLabelStyle:
                    TextStyle(color: Colors.black, fontSize: 18),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 1.5),
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
              FadeInUp(
                duration: Duration(milliseconds: 1300),
                delay: Duration(milliseconds: 800),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => Forgotpassword2()));
                      },
                      child: Text(
                        "Forgot Password?",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 13),
              FadeInUp(
                duration: Duration(milliseconds: 1300),
                delay: Duration(milliseconds: 800),
                child: MaterialButton(
                  onPressed: () {
                    Get.to(AdminNavigate());
                   // _signIn(); // <-- Call Firebase sign-in function
                  },
                  height: 45,
                  minWidth: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 50),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  color: button,
                  child: Text(
                    "SIGN IN",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
              // SizedBox(
              //   height: 20,
              // ),
              // FadeInUp(
              //     delay: Duration(milliseconds: 800),
              //     duration: Duration(milliseconds: 1500),
              //     child: Row(
              //       children: <Widget>[
              //         Expanded(
              //           child: Divider(
              //
              //             //color: Colors.grey,
              //             //thickness: 1,
              //           ),
              //         ),
              //         Padding(
              //           padding: const EdgeInsets.symmetric(horizontal: 10),
              //           child: Text(
              //             "or connected with",
              //             style: TextStyle(color: Colors.grey),
              //           ),
              //         ),
              //         Expanded(child: Divider()),
              //       ],
              //     )),
              // SizedBox(
              //   height: 20,
              // ),
              // FadeInUp(
              //   delay: Duration(milliseconds: 800),
              //   duration: Duration(milliseconds: 1500),
              //   child: MaterialButton(
              //     onPressed: () {
              //       Navigator.push(
              //         context,
              //         MaterialPageRoute(
              //           builder: (_) => const AdminNavigate(),
              //         ),
              //       );
              //     },
              //     color: Colors.grey.shade300,
              //     elevation: 0,
              //     minWidth: double.infinity,
              //     height: 45,
              //     shape: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.circular(8),
              //     ),
              //     child: Row(
              //       mainAxisSize: MainAxisSize.min,
              //       children: [
              //         Image.asset(
              //           "assets/images/google.png",
              //           height: 25,
              //         ),
              //         SizedBox(width: 10),
              //         Text(
              //           "Continue with Google",
              //           style: TextStyle(
              //             color: Colors.black,
              //             fontSize: 16,
              //             fontWeight: FontWeight.w400,
              //           ),
              //         )
              //       ],
              //     ),
              //   ),
              // ),
              // SizedBox(height: 10),
              // FadeInUp(
              //   delay: Duration(milliseconds: 800),
              //   duration: Duration(milliseconds: 1500),
              //   child: MaterialButton(
              //     onPressed: () {
              //       // function
              //     },
              //     color: Colors.grey.shade300,
              //     elevation: 0,
              //     minWidth: double.infinity,
              //     height: 45,
              //     shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(8)),
              //     child: Row(
              //       mainAxisSize: MainAxisSize.min,
              //       children: [
              //         Image.asset(
              //           "assets/images/apple.png",
              //           height: 25,
              //         ),
              //         SizedBox(width: 10),
              //         Text(
              //           "Continue with Apple",
              //           style: TextStyle(
              //               color: Colors.black,
              //               fontSize: 16,
              //               fontWeight: FontWeight.w400),
              //         )
              //       ],
              //     ),
              //   ),
              // ),
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
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> AdminRegister()));
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
