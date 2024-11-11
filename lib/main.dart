import 'package:animated_splash_screen/animated_splash_screen.dart';
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
      title: 'Flutter Api',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: AnimatedSplashScreen(
        splash: Icons.home,
        duration: 3000,
        splashTransition: SplashTransition.rotationTransition,
        backgroundColor: const Color.fromARGB(255, 33, 243, 163),
        nextScreen: const Homescreen(),
      ),
    );
  }
}
