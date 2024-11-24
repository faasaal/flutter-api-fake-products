import 'package:flutter/material.dart';
import 'package:your_app_name/homescreen.dart';
import 'package:your_app_name/splash.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'API',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: SplashScreen(),
    );
  }
}
