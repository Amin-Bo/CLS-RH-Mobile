import 'package:cls_rh/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';

class ClsScreen extends StatefulWidget {
  const ClsScreen({Key? key}) : super(key: key);

  @override
  State<ClsScreen> createState() => _ClsScreenState();
}

class _ClsScreenState extends State<ClsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSplashScreen(
        splashTransition: SplashTransition.slideTransition,
        splash: Image.asset("assets/logo.png", fit: BoxFit.cover),
        duration: 1000,
        curve: Curves.easeInExpo,
        nextScreen: const LoginScreen(),
      ),
    );
  }
}
