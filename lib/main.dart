//import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:navigate/route_generator.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //await Firebase.initializeApp();
  runApp(GetMaterialApp(
    initialRoute: '/',
    debugShowCheckedModeBanner: false,
    onGenerateRoute: RouteGenerator.generateRoute,
  ));
}
