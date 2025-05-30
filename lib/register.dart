import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:animate_do/animate_do.dart';
import 'package:navigate/login.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  int activateIndex = 0;
  bool securePassword = true;

  // condition of Password
  bool _isPasswordEightCharacters = false;
  bool _hasPasswordOneNumber = false;

  onPasswordChanged(String password) {
    final numericRegex = RegExp(r'[0-9]');
    setState(() {
      _isPasswordEightCharacters = false;
      _hasPasswordOneNumber = false;
      if(password.length >= 8){
        _isPasswordEightCharacters = true;
      }

      if(numericRegex.hasMatch(password)){
        _hasPasswordOneNumber = true;
      }
    });

  }

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
                      "Welcome New User",
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
                    "Sign up to create account",
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
                    onChanged: (password) => onPasswordChanged(password),
                    obscureText: securePassword,
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                        labelText: "Password",
                        hintText: "Password",
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                        suffixIcon: togglePassword(),
                        labelStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w400),
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
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  AnimatedContainer(duration: Duration(milliseconds: 500),
                  width: 15,
                  height: 15,
                  decoration: BoxDecoration(
                    color: _isPasswordEightCharacters ? Colors.green : Colors.transparent,
                    border: _isPasswordEightCharacters ? Border.all(color: Colors.transparent) :
                    Border.all(color: Colors.grey.shade400),
                    borderRadius: BorderRadius.circular(50),
                  ),
                    child: Center(child: Icon(Icons.check, color: Colors.white, size: 15,),),
                  ),
                  SizedBox(width: 10,),
                  Text("Contains at least 8 characters")
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  AnimatedContainer(duration: Duration(milliseconds: 500),
                    width: 15,
                    height: 15,
                    decoration: BoxDecoration(
                      color: _hasPasswordOneNumber ? Colors.green : Colors.transparent,
                      border: _hasPasswordOneNumber ? Border.all(color: Colors.transparent) :
                      Border.all(color: Colors.grey.shade400),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Center(child: Icon(Icons.check, color: Colors.white, size: 15,),),
                  ),
                  SizedBox(width: 10,),
                  Text("Contains at least 1 number")
                ],
              ),
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
                        labelText: "Confirm Password",
                        hintText: "Confirm Password",
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                        suffixIcon: togglePassword(),
                        labelStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w400),
                        prefixIcon: Icon(
                          Iconsax.lock,
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
                height: 30,
              ),
              FadeInUp(
                  duration: Duration(milliseconds: 1300),
                  delay: Duration(milliseconds: 800),
                  child: MaterialButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(
                          context, '/home'); // link to the home page
                    },
                    height: 45,
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    color: Colors.black,
                    child: Text(
                      "Register",
                      style: TextStyle(
                        color: Colors.white,
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
                      "Already have an account?",
                      style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 15,
                          fontWeight: FontWeight.w400),
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed('/1');
                        },
                        child: Text(
                          "Login",
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
