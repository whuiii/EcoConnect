// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:pin_code_fields/pin_code_fields.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:email_auth/email_auth.dart';
//
// class ForgotPassword extends StatefulWidget {
//   const ForgotPassword({super.key});
//
//   @override
//   State<ForgotPassword> createState() => _ForgotPasswordState();
// }
//
// class _ForgotPasswordState extends State<ForgotPassword> {
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController otpController = TextEditingController();
//
//   bool _isMounted = true; // Flag to avoid setState on disposed
//   EmailAuth emailAuth =  new EmailAuth(sessionName: "Test session");
//   void sendOTP()async{
//     var res = await emailAuth.sendOtp(
//         recipientMail: emailController.text,
//     otpLength: 4);
//     if(res){
//       print("OTP Send");
//     }else{
//       print("We could not send the OTP");
//     }
//   }
//
//   void verifyOTP()async{
//     var res = emailAuth.validateOtp(
//         recipientMail: emailController.text,
//         userOtp: otpController.text);
//     if (res){
//       print("OTP verified");
//     }else{
//       print("Invalid OTP");
//     }
//   }
//
//   @override
//   void dispose() {
//     _isMounted = false; // mark as disposed
//     emailController.dispose();
//     otpController.dispose();
//     super.dispose();
//   }
//
//   Future<void> sendPasswordResetEmail() async {
//     final email = emailController.text.trim();
//
//     if (email.isEmpty) {
//       if (_isMounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Please enter your email")),
//         );
//       }
//       return;
//     }
//
//     try {
//       await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
//       if (_isMounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Check your email for the reset link.")),
//         );
//       }
//     } catch (e) {
//       if (_isMounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("Error: ${e.toString()}")),
//         );
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text("Forgot Password"),
//         ),
//         body: SingleChildScrollView(
//           child: Column(
//             children: [
//               Padding(
//                 padding: const EdgeInsets.all(15),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Image.network(
//                         "https://img.freepik.com/free-vector/emails-concept-illustration_114360-1355.jpg?w=1380&t=st=1673699432~exp=1673700032~hmac=d65454eb5c72e8310209bf8ae770f849ea388f318dc6b9b1300b24b03e8886ca",
//                         height: 250,
//                       ),
//                     ),
//                     Container(
//                       padding: const EdgeInsetsDirectional.fromSTEB(16, 30, 16, 20),
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(25),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.grey.withOpacity(0.3),
//                             blurRadius: 10,
//                             offset: const Offset(0, 4),
//                           )
//                         ],
//                       ),
//                       child: Column(
//                         children: [
//                           const Text(
//                             "Please enter your email address. You will receive a password reset link.",
//                             style: TextStyle(
//                               color: Colors.grey,
//                               fontSize: 13.5,
//                             ),
//                             textAlign: TextAlign.center,
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.only(top: 30, bottom: 25),
//                             child: TextField(
//                               controller: emailController, // email controller text
//                               cursorColor: Colors.black,
//                               decoration: InputDecoration(
//                                 labelText: "Email",
//                                 hintText: "Email",
//                                 hintStyle: const TextStyle(
//                                   color: Colors.grey,
//                                   fontSize: 14,
//                                 ),
//                                 labelStyle: const TextStyle(
//                                   color: Colors.black,
//                                   fontSize: 14,
//                                   fontWeight: FontWeight.w400,
//                                 ),
//                                 prefixIcon: const Icon(
//                                   Icons.mail,
//                                   color: Colors.black,
//                                   size: 18,
//                                 ),
//                                 suffixIcon: IconButton(
//                                   onPressed: () => sendOTP(),
//                                   //onPressed: sendPasswordResetEmail,
//                                   icon: const Icon(
//                                     Icons.send_rounded,
//                                     color: Colors.teal,
//                                   ),
//                                 ),
//                                 enabledBorder: OutlineInputBorder(
//                                   borderSide: BorderSide(
//                                     color: Colors.grey.shade200,
//                                     width: 2,
//                                   ),
//                                   borderRadius: BorderRadius.circular(10),
//                                 ),
//                                 floatingLabelStyle: const TextStyle(
//                                   color: Colors.black,
//                                   fontSize: 18,
//                                 ),
//                                 focusedBorder: OutlineInputBorder(
//                                   borderSide: const BorderSide(
//                                     color: Colors.black,
//                                     width: 1.5,
//                                   ),
//                                   borderRadius: BorderRadius.circular(10),
//                                 ),
//                               ),
//                             ),
//                           ),
//
//                           // Still decorative, no OTP is sent by Firebase
//                           pinCodeTextField(context),
//
//                           ElevatedButton(
//                             onPressed: () => verifyOTP(),
//                             //onPressed: sendPasswordResetEmail,
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.teal,
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(10),
//                               ),
//                               padding: const EdgeInsets.symmetric(
//                                   horizontal: 40, vertical: 15),
//                             ),
//                             child: const Text(
//                               "Send Reset Link",
//                               style: TextStyle(fontSize: 14, color: Colors.white),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget pinCodeTextField(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
//       child: PinCodeTextField(
//         controller: otpController,
//         appContext: context,
//         length: 4,
//         keyboardType: TextInputType.number,
//         animationType: AnimationType.fade,
//         animationDuration: const Duration(milliseconds: 300),
//         enableActiveFill: true,
//         pinTheme: PinTheme(
//           shape: PinCodeFieldShape.box,
//           borderRadius: BorderRadius.circular(10),
//           fieldHeight: 60,
//           fieldWidth: MediaQuery.of(context).size.width * 0.18,
//           inactiveColor: Colors.grey,
//           activeColor: Colors.black,
//           activeFillColor: Colors.white,
//           inactiveFillColor: Colors.grey.shade300,
//           selectedFillColor: Colors.grey.shade300,
//         ),
//       ),
//     );
//   }
// }





import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:navigate/resetPassword.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController otpController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Forgot Password"),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              //topContainer(),
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
                      padding: EdgeInsetsDirectional.fromSTEB(16, 30, 16, 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          )
                        ],
                      ),
                      child: Column(
                        children: [
                          Text(
                            "Please enter your email address. You will receive an OTP for verification.",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 13.5,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 30, bottom: 25),
                            child: TextField(
                              controller: emailController,
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
                                  fontWeight: FontWeight.w400,
                                ),
                                prefixIcon: Icon(
                                  Icons.mail,
                                  color: Colors.black,
                                  size: 18,
                                ),
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text("OTP sent successfully")),
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.send_rounded,
                                    color: Colors.teal,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey.shade200,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                floatingLabelStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                    width: 1.5,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                          pinCodeTextField(context, otpController),
                          ElevatedButton(
                            onPressed: () {
                              print("Email: ${emailController.text}");
                              print("OTP: ${otpController.text}");
                              Navigator.push(context, MaterialPageRoute(builder: (context)=> ResetPassword()));
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.purple,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 40, vertical: 15),
                            ),
                            child: Text(
                              "Verify",
                              style: TextStyle(fontSize: 14, color: Colors.white),
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

  // customize appbar
  Widget topContainer() {
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
            "Forgot Password",
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 32,
            ),
          ),
        ],
      ),
    );
  }

  Widget pinCodeTextField(BuildContext context, TextEditingController controller) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: PinCodeTextField(
        controller: controller,
        appContext: context,
        length: 4,
        keyboardType: TextInputType.number,
        animationType: AnimationType.fade,
        animationDuration: Duration(milliseconds: 300),
        enableActiveFill: true,
        pinTheme: PinTheme(
          shape: PinCodeFieldShape.box,
          borderRadius: BorderRadius.circular(10),
          fieldHeight: 60,
          fieldWidth: MediaQuery.of(context).size.width * 0.18,
          inactiveColor: Colors.grey,
          activeColor: Colors.black,
          activeFillColor: Colors.white,
          inactiveFillColor: Colors.grey.shade300,
          selectedFillColor: Colors.grey.shade300,
        ),
      ),
    );
  }
}
