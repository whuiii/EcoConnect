import 'dart:convert';

import 'package:flutter/material.dart';
ForgotPasswordModel forgotPasswordModel(String str) =>
    ForgotPasswordModel.fromJson(json.decode(str),
    );

class ForgotPasswordModel{
  ForgotPasswordModel({
    required this.message,
    this.data,
  });
  late final String message;
  late final String? data;

  ForgotPasswordModel.fromJson(Map<String, dynamic>json){
    message = json['message'];
    data = json['data'];
  }
  String? toJson(){
    final _data = <String, dynamic>{};
    _data["message"] = message;
    _data["data"] = data;

    return data;
  }

}