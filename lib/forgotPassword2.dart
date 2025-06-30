import 'package:flutter/material.dart';
import 'package:navigate/otp_verify.dart';
import 'package:navigate/services/api_service.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:snippet_coder_utils/ProgressHUD.dart';

class Forgotpassword2 extends StatefulWidget {
  const Forgotpassword2({super.key});

  @override
  State<Forgotpassword2> createState() => _Forgotpassword2State();
}

class _Forgotpassword2State extends State<Forgotpassword2> {
  String email = '';
  bool isApiCallProcess = false;
  GlobalKey<FormState> globalKey = GlobalKey<FormState>();

  bool validateAndSave() {
    final form = globalKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ProgressHUD(
          opacity: .3,
          inAsyncCall: isApiCallProcess,
          key: UniqueKey(),
          child: Form(
            key: globalKey,
            child: _buildForgotPasswordUI(context),
          ),
        ),
      ),
    );
  }

  Widget _buildForgotPasswordUI(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              "https://img.freepik.com/free-vector/emails-concept-illustration_114360-1355.jpg?w=1380&t=st=1673699432~exp=1673700032~hmac=d65454eb5c72e8310209bf8ae770f849ea388f318dc6b9b1300b24b03e8886ca",
              height: 180,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 10),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "Please enter your email address. You will receive an OTP for verification.",
                style: TextStyle(color: Colors.grey, fontSize: 13.5),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 10),
            FormHelper.inputFieldWidget(
              context,
              "email",
              "Email Id",
                  (onValidateVal) {
                if (onValidateVal.isEmpty) {
                  return 'Email is required';
                }
                return null;
              },
                  (onSavedVal) {
                email = onSavedVal;
              },
              borderRadius: 10,
              borderColor: Colors.grey,
              prefixIcon: const Icon(Icons.email),
              showPrefixIcon: true,
            ),
            const SizedBox(height: 20),
            FormHelper.submitButton("Continue", () {
              if (validateAndSave()) {
                setState(() {
                  isApiCallProcess = true;
                });

                // Simulate API call or call your actual method
                //print("Send OTP to: $email");

                APIService.otpLogin(
                    email).then((response){
                  setState(() {
                    isApiCallProcess = false;
                  });

                  if (response.data != null){
                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>
                    OtpVerification(
                      otpHash: response.data,
                      email: email,
                    )), (route)=> false,);
                  }
                },
                );

                // Call your API service here, e.g.:
                // APIService.sendOtpToEmail(email).then((response) {
                //   setState(() {
                //     isApiCallProcess = false;
                //   });
                //   // Navigate to OTP screen or show success
                // });
              };
            }),
          ],
        ),
      ),
    );
  }
}

extension EmailValidator on String {
  bool isValidEmail() {
    return RegExp(
      r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
    ).hasMatch(this);
  }

}

