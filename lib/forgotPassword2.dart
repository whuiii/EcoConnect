import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class Forgotpassword2 extends StatefulWidget {
  const Forgotpassword2({super.key});

  @override
  State<Forgotpassword2> createState() => _Forgotpassword2State();
}

class _Forgotpassword2State extends State<Forgotpassword2> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final TextEditingController phoneController = TextEditingController();
  final TextEditingController otpController = TextEditingController();

  String? verificationId;

  // Send OTP
  Future<void> sendOTP() async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneController.text.trim(),
      timeout: const Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) async {
        // Automatic handling if Google Play Services can auto-detect
        await _auth.signInWithCredential(credential);
        print('Auto-verification completed!');
      },
      verificationFailed: (FirebaseAuthException e) {
        print('Verification failed: ${e.message}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Verification failed: ${e.message}')),
        );
      },
      codeSent: (String verId, int? resendToken) {
        setState(() {
          verificationId = verId;
        });
        print('OTP sent to ${phoneController.text}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('OTP sent!')),
        );
      },
      codeAutoRetrievalTimeout: (String verId) {
        verificationId = verId;
      },
    );
  }

  // Verify OTP
  Future<void> verifyOTP() async {
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId!,
        smsCode: otpController.text.trim(),
      );

      await _auth.signInWithCredential(credential);
      print('Phone number verified and user signed in!');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Phone number verified!')),
      );

      // You can navigate the user to a different page here
    } catch (e) {
      print('Error verifying OTP: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error verifying OTP: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Phone Number Input
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                hintText: '+1234567890',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 20),

            // Send OTP button
            ElevatedButton(
              onPressed: sendOTP,
              child: const Text('Send OTP'),
            ),

            const SizedBox(height: 20),

            // OTP input
            PinCodeTextField(
              appContext: context,
              length: 6,
              controller: otpController,
              onChanged: (value) {},
              pinTheme: PinTheme(
                shape: PinCodeFieldShape.box,
                borderRadius: BorderRadius.circular(5),
                fieldHeight: 50,
                fieldWidth: 40,
              ),
            ),

            const SizedBox(height: 20),

            // Verify OTP button
            ElevatedButton(
              onPressed: () {
                if (verificationId != null) {
                  verifyOTP();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please send OTP first')),
                  );
                }
              },
              child: const Text('Verify OTP'),
            ),
          ],
        ),
      ),
    );
  }
}
