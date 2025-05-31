import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:iconsax/iconsax.dart';

import 'color.dart';
import 'mainpage.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  //const EditProfile({super.key});
  int activateIndex = 0;
  bool securePassword = true;
  bool? isChecked = false;

  // condition of Password
  bool _isPasswordEightCharacters = false;
  bool _hasPasswordOneNumber = false;

  onPasswordChanged(String password) {
    final numericRegex = RegExp(r'[0-9]');
    setState(() {
      _isPasswordEightCharacters = false;
      _hasPasswordOneNumber = false;
      if (password.length >= 8) {
        _isPasswordEightCharacters = true;
      }

      if (numericRegex.hasMatch(password)) {
        _hasPasswordOneNumber = true;
      }
    });

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

  @override
  Widget build(BuildContext context) {
    return  SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: Text("Edit Profile",
              style: TextStyle(color: Colors.white),),
            backgroundColor: button,) ,
          body: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(30),
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                      SizedBox(
                        width: 120,
                        height: 120,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Image.asset('assets/images/EcoConnect_Logo.png'),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child:Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: Colors.grey.shade300, // color of the circle
                          ),
                          child: Icon(Icons.edit, size: 18, color: Colors.grey.shade800,),
                        ),),

                    ],
                  ),
                  SizedBox(height: 10,),
                  Text("EcoConnect",
                    style: TextStyle(fontSize: 30,fontWeight: FontWeight.w700),),
                  Text("Bio Data: Recycle, Reuse, Reduce",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),),
                  SizedBox(height: 20,),
                  SizedBox(width: 200,
                    child: MaterialButton(onPressed: (){
                      // Edit Profile
                      Get.to(EditProfile());
                    },
                      color: button,
                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text("Edit Profile",
                        style: TextStyle(fontSize: 16, color: Colors.white),),),),
                  SizedBox(height: 30,),
                  const Divider(), // a line of divider
                  SizedBox(height: 10,),
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

                ],
              ),
            ),
          )

      ),
    );
  }

  //
  Widget topContainer(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.20,
      padding: EdgeInsets.only(left: 16, bottom: 15, top: 20),
      color: Colors.green.shade200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              Get.back();
            },
            child: Icon(Icons.arrow_back),
          ),
          Spacer(),
          Text(
            "Profile",
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 32,
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileMenuWidget extends StatelessWidget {
  const ProfileMenuWidget({
    Key? key,
    //super.key,
    required this.title,
    required this.icon,
    required this.onPress,
    this.endIcon = true,
    this.textColor,
  }): super(key: key);

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
        width: 40,height: 40, // size of the circle
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: button, // not sure function
        ),
        child: Icon(icon, color: Colors.white,size: 30,), //size of the icon
      ),
      title: Text(title,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500,color: textColor),),
      trailing: endIcon? Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: Colors.grey.shade300, // color of the circle
        ),
        child: Icon(Icons.keyboard_arrow_right, size: 18, color: Colors.grey.shade800,),
      ): null,
    );
  }
}



