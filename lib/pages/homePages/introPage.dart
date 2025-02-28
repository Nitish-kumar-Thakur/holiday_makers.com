import 'package:flutter/material.dart';
import 'package:holdidaymakers/pages/login&signup/loginPage.dart';
import 'package:holdidaymakers/pages/login&signup/signupPage.dart';
import 'package:holdidaymakers/widgets/appLargetext.dart';
import 'package:holdidaymakers/widgets/appText.dart';
import 'package:holdidaymakers/widgets/responciveButton.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'dart:async';

class IntroPage extends StatefulWidget {
  const IntroPage({super.key});

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  int currentPage = 0;
  late PageController _pageController;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    _pageController.addListener(() {
      setState(() {
        currentPage = _pageController.page!.round();
      });
    });

    // Auto-slide pages every 3 seconds
    _timer = Timer.periodic(Duration(seconds: 3), (timer) {
      if (_pageController.page == 2) {
        _pageController.jumpToPage(0); // Reset to first page
      } else {
        _pageController.nextPage(
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // PageView with onboarding content
          PageView.builder(
            controller: _pageController,
            scrollDirection: Axis.horizontal,
            itemCount: 3,
            itemBuilder: (_, index) {
              return Column(
                children: [
                  // Image Container
                  Container(
                    width: double.infinity,
                    height: screenHeight * 0.45,
                    child: Center(
                      child: Image.asset(
                        'img/traveller1.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),

          // Fixed Button at the bottom
          Positioned(
            bottom: screenHeight * 0.05,
            left: 0,
            right: 0,
            child: Column(
              children: [
                // Smooth Page Indicator
                SmoothPageIndicator(
                  controller: _pageController,
                  count: 3,
                  effect: WormEffect(
                    dotHeight: 13,
                    dotWidth: 13,
                    spacing: 8,
                    activeDotColor: Color(0xFF00CEC9),
                    dotColor: Color(0xFF00CEC9).withOpacity(0.5),
                    type: WormType.thin
                    
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),

                // Title & Description
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                  child: Column(
                    children: [
                      AppLargeText(text: 'Plan Your Trip'),
                      SizedBox(height: screenHeight * 0.04),
                      SizedBox(
                        width: screenWidth * 0.6,
                        child: AppText(
                          text: 'Custom and fast planning with a low price',
                          color: Colors.black,
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: screenHeight * 0.1),

                // Login Button
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => LoginPage()));
                  },
                  child: responciveButton(text: 'Log in'),
                ),
                SizedBox(height: screenHeight * 0.025),

                // Create Account Button
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => Signuppage()));
                  },
                  child: responciveButton(
                    text: 'Create account',
                    color: Colors.white,
                    textColor: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer.cancel();
    super.dispose();
  }
}
