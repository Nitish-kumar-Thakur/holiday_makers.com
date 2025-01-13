import 'package:flutter/material.dart';
import 'package:holdidaymakers/pages/login&signup/loginPage.dart';
import 'package:holdidaymakers/pages/login&signup/signupPage.dart';
import 'package:holdidaymakers/widgets/appLargetext.dart';
import 'package:holdidaymakers/widgets/appText.dart';
import 'package:holdidaymakers/widgets/responciveButton.dart';
import 'dart:async';

class IntroPage extends StatefulWidget {
  const IntroPage({super.key});

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage>
    with SingleTickerProviderStateMixin {
  int currentPage = 0; // Track current page index
  late PageController _pageController;
  late AnimationController _controller;
  late Animation<double> _animation;
  late Timer _timer; // Timer to change pages automatically

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    _pageController.addListener(() {
      setState(() {
        currentPage = _pageController.page!.round();
      });
    });
    _controller = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    )..repeat(reverse: true); // Repeats the animation back and forth
    _animation = Tween(begin: 0.0, end: 10.0).animate(CurvedAnimation(
        parent: _controller, curve: Curves.easeInOut)); // Vertical jump effect

    // Timer for automatic page change
    _timer = Timer.periodic(Duration(seconds: 3), (timer) {
      if (currentPage < 2) {
        _pageController.nextPage(
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      } else {
        _pageController.jumpToPage(0); // Reset to first page after last
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
                    height: screenHeight *
                        0.45, // Dynamic height based on screen size
                    child: Center(
                      child: Image.asset(
                        'img/traveller1.png',
                        fit: BoxFit
                            .contain, // Ensures the image scales without distortion
                      ),
                    ),
                  ),
                  // Title & Description (optional, can be added if required)
                ],
              );
            },
          ),

          // Fixed Button at the bottom
          Positioned(
            bottom: screenHeight * 0.05, // Dynamic bottom positioning
            left: 0,
            right: 0,
            child: Column(
              children: [
                // Jumping dots indicator for page navigation
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    3,
                    (indexDots) {
                      return AnimatedBuilder(
                        animation: _controller,
                        builder: (context, child) {
                          return AnimatedContainer(
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                            margin: EdgeInsets.only(right: 5),
                            width:
                                screenWidth * 0.025, // Relative width for dots
                            height: screenHeight *
                                0.015, // Relative height for dots
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: currentPage == indexDots
                                  ? Color(0xFF00CEC9)
                                  : Color(0xFFDFE6E9),
                            ),
                            transform: Matrix4.translationValues(
                                0,
                                _animation.value,
                                0), // Vertical jumping movement
                          );
                        },
                      );
                    },
                  ),
                ),
                SizedBox(height: screenHeight * 0.02), // Dynamic spacing
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.1), // Responsive padding
                  child: Column(
                    children: [
                      AppLargeText(text: 'Plan Your Trip'),
                      SizedBox(
                        height: screenHeight * 0.04,
                      ), // Dynamic spacing
                      SizedBox(
                        width: MediaQuery.of(context).size.width *
                            0.6, // 60% of screen width for responsiveness
                        child: AppText(
                          text: 'Custom and fast planning with a low price',
                          color: Colors.black,
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                    height:
                        screenHeight * 0.1), // Dynamic spacing between sections
                GestureDetector(
                  onTap: () => {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginPage()))
                  },
                  child: Column(
                    children: [
                      responciveButton(
                        text: 'Log in',
                      ),
                    ],
                  ),
                ),
                SizedBox(height: screenHeight * 0.025), // Dynamic spacing
                GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Signuppage()));
                  },
                  child: Column(
                    children: [
                      responciveButton(
                        text: 'Create account',
                        color: Colors.white,
                        textColor: Colors.black54,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer.cancel(); // Cancel the timer to avoid memory leaks
    super.dispose();
  }
}
