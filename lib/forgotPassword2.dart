import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
                }else if(!EmailValidator(onValidateVal.toString()).isValidEmail()){
                  return 'Invalid Email Id';
                }
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
                print("Send OTP to: $email");

                APIService.otpLogin(email).then((response){
                setState(() {
                  isApiCallProcess = false;
                });

                if (response.data != null){
                  Navigator.pushAndRemoveUntil(context,
                      MaterialPageRoute(
                          builder: (context) => OtpVerification(
                            otpHash: response.data,
                            email: email,
                  )), (route)=> false);

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






  //   return SafeArea(
  //     child: Scaffold(
  //       appBar: AppBar(
  //         title: Text("Forgot Password"),
  //       ),
  //       body: SingleChildScrollView(
  //         child: Column(
  //           children: [
  //             //topContainer(),
  //             Padding(
  //               padding: const EdgeInsets.all(15),
  //               child: Column(
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //                 children: [
  //                   Padding(
  //                     padding: const EdgeInsets.all(8.0),
  //                     child: Image.network(
  //                       "https://img.freepik.com/free-vector/emails-concept-illustration_114360-1355.jpg?w=1380&t=st=1673699432~exp=1673700032~hmac=d65454eb5c72e8310209bf8ae770f849ea388f318dc6b9b1300b24b03e8886ca",
  //                       height: 250,
  //                     ),
  //                   ),
  //                   Container(
  //                     padding: EdgeInsetsDirectional.fromSTEB(16, 30, 16, 20),
  //                     decoration: BoxDecoration(
  //                       color: Colors.white,
  //                       borderRadius: BorderRadius.circular(25),
  //                       boxShadow: [
  //                         BoxShadow(
  //                           color: Colors.grey.withOpacity(0.3),
  //                           blurRadius: 10,
  //                           offset: Offset(0, 4),
  //                         )
  //                       ],
  //                     ),
  //                     child: Column(
  //                       children: [
  //                         Text(
  //                           "Please enter your email address. You will receive an OTP for verification.",
  //                           style: TextStyle(
  //                             color: Colors.grey,
  //                             fontSize: 13.5,
  //                           ),
  //                           textAlign: TextAlign.center,
  //                         ),
  //                         Padding(
  //                           padding: EdgeInsets.only(top: 30, bottom: 25),
  //                           child: TextField(
  //                             controller: emailController,
  //                             cursorColor: Colors.black,
  //                             decoration: InputDecoration(
  //                               labelText: "Email",
  //                               hintText: "Email",
  //                               hintStyle: TextStyle(
  //                                 color: Colors.grey,
  //                                 fontSize: 14,
  //                               ),
  //                               labelStyle: TextStyle(
  //                                 color: Colors.black,
  //                                 fontSize: 14,
  //                                 fontWeight: FontWeight.w400,
  //                               ),
  //                               prefixIcon: Icon(
  //                                 Icons.mail,
  //                                 color: Colors.black,
  //                                 size: 18,
  //                               ),
  //                               suffixIcon: IconButton(
  //                                 onPressed: () {
  //                                   ScaffoldMessenger.of(context).showSnackBar(
  //                                     SnackBar(content: Text("OTP sent successfully")),
  //                                   );
  //                                 },
  //                                 icon: const Icon(
  //                                   Icons.send_rounded,
  //                                   color: Colors.teal,
  //                                 ),
  //                               ),
  //                               enabledBorder: OutlineInputBorder(
  //                                 borderSide: BorderSide(
  //                                   color: Colors.grey.shade200,
  //                                   width: 2,
  //                                 ),
  //                                 borderRadius: BorderRadius.circular(10),
  //                               ),
  //                               floatingLabelStyle: TextStyle(
  //                                 color: Colors.black,
  //                                 fontSize: 18,
  //                               ),
  //                               focusedBorder: OutlineInputBorder(
  //                                 borderSide: BorderSide(
  //                                   color: Colors.black,
  //                                   width: 1.5,
  //                                 ),
  //                                 borderRadius: BorderRadius.circular(10),
  //                               ),
  //                             ),
  //                           ),
  //                         ),
  //                         pinCodeTextField(context, otpController),
  //                         ElevatedButton(
  //                           onPressed: () {
  //                             print("Email: ${emailController.text}");
  //                             print("OTP: ${otpController.text}");
  //                             Navigator.push(context, MaterialPageRoute(builder: (context)=> ResetPassword()));
  //                           },
  //                           style: ElevatedButton.styleFrom(
  //                             backgroundColor: Colors.purple,
  //                             shape: RoundedRectangleBorder(
  //                               borderRadius: BorderRadius.circular(10),
  //                             ),
  //                             padding: EdgeInsets.symmetric(
  //                                 horizontal: 40, vertical: 15),
  //                           ),
  //                           child: Text(
  //                             "Verify",
  //                             style: TextStyle(fontSize: 14, color: Colors.white),
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }
// }


// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:pin_code_fields/pin_code_fields.dart';
//
// class Forgotpassword2 extends StatefulWidget {
//   const Forgotpassword2({super.key});
//
//   @override
//   State<Forgotpassword2> createState() => _Forgotpassword2State();
// }
//
// class _Forgotpassword2State extends State<Forgotpassword2> {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//
//   final TextEditingController phoneController = TextEditingController();
//   final TextEditingController otpController = TextEditingController();
//
//   String? verificationId;
//
//   // Send OTP
//   Future<void> sendOTP() async {
//     await _auth.verifyPhoneNumber(
//       phoneNumber: phoneController.text.trim(),
//       timeout: const Duration(seconds: 60),
//       verificationCompleted: (PhoneAuthCredential credential) async {
//         // Automatic handling if Google Play Services can auto-detect
//         await _auth.signInWithCredential(credential);
//         print('Auto-verification completed!');
//       },
//       verificationFailed: (FirebaseAuthException e) {
//         print('Verification failed: ${e.message}');
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Verification failed: ${e.message}')),
//         );
//       },
//       codeSent: (String verId, int? resendToken) {
//         setState(() {
//           verificationId = verId;
//         });
//         print('OTP sent to ${phoneController.text}');
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('OTP sent!')),
//         );
//       },
//       codeAutoRetrievalTimeout: (String verId) {
//         verificationId = verId;
//       },
//     );
//   }
//
//   // Verify OTP
//   Future<void> verifyOTP() async {
//     try {
//       final credential = PhoneAuthProvider.credential(
//         verificationId: verificationId!,
//         smsCode: otpController.text.trim(),
//       );
//
//       await _auth.signInWithCredential(credential);
//       print('Phone number verified and user signed in!');
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Phone number verified!')),
//       );
//
//       // You can navigate the user to a different page here
//     } catch (e) {
//       print('Error verifying OTP: $e');
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error verifying OTP: $e')),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.all(24),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             // Phone Number Input
//             TextField(
//               controller: phoneController,
//               decoration: const InputDecoration(
//                 labelText: 'Phone Number',
//                 hintText: '+1234567890',
//                 border: OutlineInputBorder(),
//               ),
//               keyboardType: TextInputType.phone,
//             ),
//             const SizedBox(height: 20),
//
//             // Send OTP button
//             ElevatedButton(
//               onPressed: sendOTP,
//               child: const Text('Send OTP'),
//             ),
//
//             const SizedBox(height: 20),
//
//             // OTP input
//             PinCodeTextField(
//               appContext: context,
//               length: 6,
//               controller: otpController,
//               onChanged: (value) {},
//               pinTheme: PinTheme(
//                 shape: PinCodeFieldShape.box,
//                 borderRadius: BorderRadius.circular(5),
//                 fieldHeight: 50,
//                 fieldWidth: 40,
//               ),
//             ),
//
//             const SizedBox(height: 20),
//
//             // Verify OTP button
//             ElevatedButton(
//               onPressed: () {
//                 if (verificationId != null) {
//                   verifyOTP();
//                 } else {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(content: Text('Please send OTP first')),
//                   );
//                 }
//               },
//               child: const Text('Verify OTP'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
