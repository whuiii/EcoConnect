//import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:navigate/route_generator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //await Firebase.initializeApp();
  runApp(MaterialApp(
    initialRoute: '/',
    debugShowCheckedModeBanner: false,
    onGenerateRoute: RouteGenerator.generateRoute,
  ));
}
