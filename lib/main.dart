import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:navigate/color.dart';
import 'package:navigate/providers/user_provider.dart';
import 'package:navigate/route_generator.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider.fetchUser(); // Load Firebase user data into model
      _isInitialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: '/',
      debugShowCheckedModeBanner: false,
      onGenerateRoute: RouteGenerator.generateRoute,
      theme: ThemeData(
        primaryColor: green3,
        scaffoldBackgroundColor: back1,
        appBarTheme: AppBarTheme(
          backgroundColor: green3,
          foregroundColor: green1,
          elevation: 0,
        ),
        snackBarTheme: SnackBarThemeData(
          backgroundColor: green2,
          contentTextStyle: TextStyle(color: Colors.white),
          actionTextColor: Colors.orange,
        ),
        textTheme: TextTheme(
          headlineLarge: TextStyle(
              fontSize: 32, fontWeight: FontWeight.bold, color: green1),
          titleMedium: TextStyle(
              fontSize: 20, fontWeight: FontWeight.w600, color: green1),
          bodyMedium: TextStyle(fontSize: 16, color: green1),
        ),
        colorScheme:
            ColorScheme.fromSwatch().copyWith(secondary: Colors.orange),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: green2,
            foregroundColor: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          ),
        ),
      ),
    );
  }
}
