import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:navigate/forgotPassword2.dart';

import '../models/forgotpassword_model.dart';

class APIService{
  static var client = http.Client();

  static Future<ForgotPasswordModel> otpLogin(String email) async{
    var url = Uri.http("127.0.0.1:4500", "emailjs/otp-login");

    var response = await client.post(
        url,
        headers: {'Content-type': "application/json"},
      body: jsonEncode({
          {"email": email

          }
        })
    );
    return forgotPasswordModel(response.body);
  }

  static Future<ForgotPasswordModel> verifyOTP(
      String email,
      String otpHash,
      String otpCode,
      ) async{
    var url = Uri.http("127.0.0.1:4500", "emailjs/otp-verify");

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