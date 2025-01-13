import 'package:flutter/material.dart';
import 'package:holdidaymakers/pages/introPage.dart';
import 'package:holdidaymakers/widgets/appText.dart';
import 'package:holdidaymakers/widgets/responciveButton.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardPage extends StatefulWidget {
  const OnboardPage({super.key});

  @override
  State<OnboardPage> createState() => _OnboardPageState();
}

class _OnboardPageState extends State<OnboardPage> {
  void _completeOnboarding() async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isOnboardingComplete', true);

    // Navigate to Home Page after setting the flag
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const IntroPage()),
    );
  }

  List<Map<String, String>> onboardingData = [
    {
      "image": "img/onboard1.png",
      "title1": "Life is short and the world is ",
      "title2": "wide",
      "description":
          "At Friends tours and travel, we customize reliable and trustworthy educational tours to destinations all over the world",
      "button": "Get Started"
    },
    {
      "image": "img/onboard2.png",
      "title1": "It’s a big world out there, go ",
      "title2": "explore",
      "description":
          "To get the best of your adventure you just need to leave and go where you like. We are waiting for you",
      "button": "Next"
    },
    {
      "image": "img/onboard3.png",
      "title1": "People don’t take trips, trips take ",
      "title2": "people",
      "description":
          "To get the best of your adventure you just need to leave and go where you like. We are waiting for you",
      "button": "Next"
    },
  ];

  int currentPage = 0; // Track current page index
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    _pageController.addListener(() {
      setState(() {
        currentPage = _pageController.page!.round();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions for responsiveness
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
            itemCount: onboardingData.length,
            itemBuilder: (_, index) {
              return Column(
                children: [
                  // Image Container
                  Container(
                    width: double.infinity,
                    height: screenHeight * 0.6, // Dynamic height for image
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(onboardingData[index]["image"]!),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(40),
                        bottomRight: Radius.circular(40),
                      ),
                    ),
                  ),
                  // Title & Description
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.08, // Responsive padding
                        vertical: screenHeight * 0.04),
                    child: Column(
                      children: [
                        SizedBox(
                          width: screenWidth * 0.7, // Responsive width for text
                          child: Column(
                            children: [
                              RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  style: TextStyle(
                                    fontSize: screenHeight * 0.030, // Dynamic font size
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: onboardingData[index]["title1"]!,
                                    ),
                                    TextSpan(
                                      text: onboardingData[index]["title2"]!,
                                      style: TextStyle(
                                        color: Color(0xFFFF7029),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: screenHeight * 0.03),
                              AppText(
                                text: onboardingData[index]["description"]!,
                                size: screenHeight * 0.02, // Dynamic text size
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Dots Indicator (optional)
                ],
              );
            },
          ),
          // Fixed Button at the bottom
          Positioned(
            bottom: screenHeight * 0.04, // Dynamic position based on screen height
            left: 0,
            right: 0,
            child: Center(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      onboardingData.length,
                      (indexDots) {
                        return AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          margin: EdgeInsets.only(right: 5),
                          width: currentPage == indexDots ? screenWidth * 0.06 : screenWidth * 0.02,
                          height: screenHeight * 0.01,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: currentPage == indexDots
                                ? Color(0xFF0D6EFD)
                                : Color(0xFF0D6EFD).withOpacity(0.3),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  GestureDetector(
                    onTap: () async {
                      if (currentPage == onboardingData.length - 1) {
                        _completeOnboarding();
                      } else {
                        _pageController.animateToPage(
                          currentPage + 1,
                          duration: Duration(milliseconds: 600),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                    child: responciveButton(
                      text: onboardingData[currentPage]["button"]!,
                      border: screenHeight * 0.03, // Dynamic button border radius
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
