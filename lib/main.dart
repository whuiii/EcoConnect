//import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:navigate/color.dart';
import 'package:navigate/route_generator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(GetMaterialApp(
      initialRoute: '/',
      debugShowCheckedModeBanner: false,
      onGenerateRoute: RouteGenerator.generateRoute,
      theme: ThemeData(
        primaryColor: green3, // from your color.dart
        scaffoldBackgroundColor: back1,
        appBarTheme: AppBarTheme(
          backgroundColor: green3,
          foregroundColor: green1,
          elevation: 0,
        ),
        textTheme: TextTheme(
          headlineLarge: TextStyle(
              fontSize: 32, fontWeight: FontWeight.bold, color: green1),
          titleMedium: TextStyle(
              fontSize: 20, fontWeight: FontWeight.w600, color: green1),
          bodyMedium: TextStyle(fontSize: 16, color: green1),
        ),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: Colors.orange, // for accent color
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: green2,
            foregroundColor: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          ),
        ),
      )));
}
