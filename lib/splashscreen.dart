import 'dart:async';

import 'package:flutter/material.dart';
import 'package:holdidaymakers/pages/FullyIndependentTraveler/mainPage.dart';
import 'package:holdidaymakers/pages/introPage.dart';
import 'package:holdidaymakers/pages/onboardPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
_checkFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    bool? isOnboardingComplete = prefs.getBool('isOnboardingComplete') ?? false;
    bool? isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (isOnboardingComplete && isLoggedIn) {
      // Navigate to Home Page if onboarding is done and user is logged in
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Mainpage()),
      );
    } else if (isOnboardingComplete) {
      // Navigate to Login Page if onboarding is done but user is not logged in
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const IntroPage()),
      );
    } else {
      // Navigate to Intro Page if onboarding is not done
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const OnboardPage()),
      );
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(Duration(milliseconds: 1500), _checkFirstLaunch);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Image.asset("img/splashLogo.png"),)
    );
  }
}
