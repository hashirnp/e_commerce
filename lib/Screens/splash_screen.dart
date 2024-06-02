import 'dart:async';

import 'package:e_commerce/Screens/Auth/signin_screen.dart';
import 'package:e_commerce/Screens/home_screen.dart';
import 'package:e_commerce/Widgets/connectivity_wrapper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController animationController;

  @override
  void dispose() {
    super.dispose();
    animationController.dispose();
  }

  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(duration: const Duration(seconds: 1), vsync: this);
    animationController.repeat();
    Timer.periodic(const Duration(seconds: 4), (timer) {
      if (FirebaseAuth.instance.currentUser != null) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (ctx) => const ConnectivityWrapper(child: HomeScreen())));
      } else {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (ctx) => const SignInScreen()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Center(
        child: Hero(
          tag: 'logo',
          child: Container(
            padding: const EdgeInsets.all(10),
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  // height: 250,
                  width: 250,
                ),
                CircularProgressIndicator(
                  // valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                  valueColor: animationController
                      .drive(ColorTween(begin: Colors.black, end: Colors.red)),
                )
              ],
            ),
            
          ),
        ),
      )),
    );
  }
}
