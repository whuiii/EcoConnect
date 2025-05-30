import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:iconsax/iconsax.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});


  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  bool securePassword = true;
  // condition of Password
  bool _isPasswordEightCharacters = false;
  bool _hasPasswordOneNumber = false;

  onPasswordChanged(String NewPasword) {
    final numericRegex = RegExp(r'[0-9]');
    setState(() {
      _isPasswordEightCharacters = false;
      _hasPasswordOneNumber = false;
      if(NewPasword.length >= 8){
        _isPasswordEightCharacters = true;
      }

      if(numericRegex.hasMatch(NewPasword)){
        _hasPasswordOneNumber = true;
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              topContainer(context),
              Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.network(
                        "https://img.freepik.com/free-vector/emails-concept-illustration_114360-1355.jpg?w=1380&t=st=1673699432~exp=1673700032~hmac=d65454eb5c72e8310209bf8ae770f849ea388f318dc6b9b1300b24b03e8886ca",
                        height: 250,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsetsDirectional.fromSTEB(16, 30, 16, 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          )
                        ],
                      ),
                      child: Column(
                        children: [
                          const Text(
                            "Reset your password. Your new password must be unique from previous",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 13.5,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 30),
                          TextField(
                            onChanged: (NewPassword) => onPasswordChanged(NewPassword),
                            cursorColor: Colors.black,
                            obscureText: securePassword,
                            decoration: InputDecoration(
                              labelText: "New Password",
                              hintText: "New Password",
                              prefixIcon: const Icon(Iconsax.key),
                              suffixIcon: togglePassword(),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.grey.shade200,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Colors.black,
                                  width: 1.5,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
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
                          const SizedBox(height: 20),
                          TextField(
                            cursorColor: Colors.black,
                            obscureText: securePassword,
                            decoration: InputDecoration(
                              labelText: "Confirm Password",
                              hintText: "Confirm Password",
                              prefixIcon: const Icon(Iconsax.key1),
                              suffixIcon: togglePassword(),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.grey.shade200,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Colors.black,
                                  width: 1.5,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          MaterialButton(
                            onPressed: () {
                              // condition check before reset password
                              // Reset view
                            },
                            height: 45,
                            minWidth: double.infinity,
                            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 70),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            color: Colors.black,
                            child: Text(
                              "Reset",
                              style: TextStyle(
                                fontSize: 16,
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
      icon: Icon(
        securePassword ? Icons.visibility : Icons.visibility_off,
        color: Colors.grey,
      ),
    );
  }
}

// AppBar container
Widget topContainer(BuildContext context) {
  return Container(
    width: double.infinity,
    height: MediaQuery.of(context).size.height * 0.20,
    padding: const EdgeInsets.only(left: 16, bottom: 15, top: 20),
    color: Colors.green.shade200,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {
            Get.back();
          },
          child: const Icon(Icons.arrow_back),
        ),
        const Spacer(),
        const Text(
          "Reset Password",
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 32,
          ),
        ),
      ],
    ),
  );
}
