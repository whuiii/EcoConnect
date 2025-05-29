import 'package:flutter/material.dart';
import 'package:navigate/home.dart';
import 'package:navigate/mainpage.dart';
import 'package:navigate/login.dart';
import 'package:navigate/main.dart';
import 'package:navigate/menu.dart';
import 'package:navigate/navigate.dart';
import 'package:navigate/register.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => MainPage());
      case '/1':
        return MaterialPageRoute(builder: (_) => LoginPage());
      case '/2':
        return MaterialPageRoute(builder: (_) => RegisterPage());
      case '/3':
        return MaterialPageRoute(builder: (_) => ProviderPage());
      case '/4':
        return MaterialPageRoute(builder: (_) => Navigate());

      default:
        return MaterialPageRoute(builder: (_) => MainPage());
    }
  }
}
