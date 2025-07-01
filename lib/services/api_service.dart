import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:navigate/forgotPassword2.dart';

import '../models/forgotpassword_model.dart';

class APIService{
  static var client = http.Client();

  static Future<ForgotPasswordModel> otpLogin(String email) async {
    var url = Uri.http("0.0.0.0:4500", "/emailjs-backend/otp-login");

    var response = await client.post(
      url,
      headers: {'Content-type': "application/json"},
      body: jsonEncode({
        "email": email
      }),
    );
    return forgotPasswordModel(response.body);
  }

  static Future<ForgotPasswordModel> verifyOTP(
      String email,
      String otpHash,
      String otpCode,
      ) async{
    var url = Uri.http("0.0.0.0:4500", "/emailjs-backend/otp-verify"); //change the ip

    var response = await client.post(
        url,
        headers: {'Content-type': "application/json"},
        body: jsonEncode({
          {"email": email,
            "otp": otpCode,
            "otpHash": otpHash,

          }
        })
    );
    return forgotPasswordModel(response.body);
  }

}