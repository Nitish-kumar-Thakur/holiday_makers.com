// import 'dart:async';
// import 'package:HolidayMakers/pages/OnboardingPage/OnboardingScreen.dart';
// import 'package:HolidayMakers/pages/homePages/no_internet_page.dart';
// import 'package:HolidayMakers/pages/login&signup/Test.dart';
// import 'package:flutter/material.dart';
// import 'package:HolidayMakers/pages/homePages/mainPage.dart';
// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:shared_preferences/shared_preferences.dart'; // Create this page

// class Splashscreen extends StatefulWidget {
//   const Splashscreen({super.key});

//   @override
//   State<Splashscreen> createState() => _SplashscreenState();
// }

// class _SplashscreenState extends State<Splashscreen> {
//   Future<void> _checkFirstLaunch() async {
//     final prefs = await SharedPreferences.getInstance();
//     bool? isOnboardingComplete = prefs.getBool('isOnboardingComplete') ?? false;
//     bool? isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

//     // Check internet connectivity
//     var connectivityResult = await Connectivity().checkConnectivity();

//     if (connectivityResult == ConnectivityResult.none) {
//       // No internet, navigate to NoInternetPage
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => NoInternetPage()),
//       );
//       return;
//     }

//     if (isOnboardingComplete) {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => const Mainpage()),
//       );
//     } else if (isOnboardingComplete) {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => const LoginPage()),
//       );
//     } else {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => OnboardingScreen()),
//       );
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     Timer(Duration(milliseconds: 1500), _checkFirstLaunch);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: BoxDecoration(
//           image: DecorationImage(
//             image: AssetImage("img/splashbg.png"),
//             fit: BoxFit.fill,
//           ),
//         ),
//         child: Stack(
//           alignment: Alignment.center,
//           children: [
//             Positioned(
//               bottom: 345,
//               child: Image.asset("img/splashLogo.png"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:get/get.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:HolidayMakers/pages/OnboardingPage/OnboardingScreen.dart';
import 'package:HolidayMakers/pages/homePages/no_internet_page.dart';
import 'package:HolidayMakers/pages/homePages/mainPage.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset("img/SplashGif.mp4")
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
        _controller.addListener(_onVideoEnd);
      });
  }

  void _onVideoEnd() {
    if (_controller.value.position >= _controller.value.duration) {
      _controller.removeListener(_onVideoEnd);
      _checkConnectivity();
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onVideoEnd);
    _controller.dispose();
    super.dispose();
  }

  Future<void> _checkConnectivity() async {
    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult.contains(ConnectivityResult.none)) {
      Get.offAll(() => NoInternetPage());
      return;
    }

    _checkFirstLaunch();
  }

  Future<void> _checkFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    bool isOnboardingComplete = prefs.getBool('isOnboardingComplete') ?? false;

    if (isOnboardingComplete) {
      Get.offAll(() => const Mainpage());
    } else {
      Get.offAll(() => OnboardingScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor:  Colors.white,
      body: SizedBox( height: double.infinity, width: double.infinity, 
        child: _controller.value.isInitialized
            ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              )
            : Container(),
      ),
    );
  }
}









// import 'dart:async';
// import 'package:HolidayMakers/pages/OnboardingPage/OnboardingScreen.dart';
// import 'package:HolidayMakers/pages/login&signup/Test.dart';
// import 'package:flutter/material.dart';
// import 'package:HolidayMakers/pages/homePages/mainPage.dart';
// import 'package:HolidayMakers/pages/homePages/introPage.dart';
// import 'package:HolidayMakers/pages/homePages/onboardPage.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class Splashscreen extends StatefulWidget {
//   const Splashscreen({super.key});

//   @override
//   State<Splashscreen> createState() => _SplashscreenState();
// }

// class _SplashscreenState extends State<Splashscreen> {
//   _checkFirstLaunch() async {
//     final prefs = await SharedPreferences.getInstance();
//     bool? isOnboardingComplete = prefs.getBool('isOnboardingComplete') ?? false;
//     bool? isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

//     if (isOnboardingComplete) { //isOnboardingComplete && isLoggedIn)
//       // Navigate to Home Page if onboarding is done and user is logged in
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => const Mainpage()),
//       );
//     }
//      else if (isOnboardingComplete) {
//       // Navigate to Login Page if onboarding is done but user is not logged in
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => const LoginPage()),
//       );
//     } 
//     else {
//       // Navigate to Intro Page if onboarding is not done
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => OnboardingScreen()),
//       );
//     }
//   }

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     Timer(Duration(milliseconds: 1500), _checkFirstLaunch);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: Container(
//   decoration: BoxDecoration(
//     image: DecorationImage(
//       image: AssetImage("img/splashbg.png"),
//       fit: BoxFit.fill,
//     ),
//   ),
//   child: Stack(
//     alignment: Alignment.center,
//     children: [
//       Positioned(
//         bottom: 345,
//         child: Image.asset("img/splashLogo.png"),
//       ),
//     ],
//   ),
// )
// );
//   }
// }
