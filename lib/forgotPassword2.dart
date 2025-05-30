import 'package:flutter/material.dart';


class Forgotpassword2 extends StatelessWidget {
  const Forgotpassword2({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.blue,
            title: Text("Forgot Password"),
          ),
          body:SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  color: Colors.grey,
                  child: Container(
                    padding: EdgeInsetsDirectional.fromSTEB(16, 30, 16, 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(25),
                        topLeft: Radius.circular(25),
                      )
                    ),
                    child: Column(
                      children: [
                        Text("Please enter your email address. You will receive a OTP for verification",
                          style: TextStyle(color: Colors.grey, fontSize: 13.5),)
                      ],
                    ),
                  ),
                )

              ],
            ),
          ),



    ),);
  }
}
