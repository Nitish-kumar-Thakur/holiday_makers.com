import 'package:flutter/material.dart';
import 'package:holdidaymakers/pages/introPage.dart';
import 'package:holdidaymakers/widgets/appText.dart';
import 'package:holdidaymakers/widgets/responciveButton.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Onboardpage2 extends StatefulWidget {
  const Onboardpage2({super.key});

  @override
  State<Onboardpage2> createState() => _Onboardpage2State();
}

class _Onboardpage2State extends State<Onboardpage2> {
  void _completeOnboarding() async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isOnboardingComplete', true);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const IntroPage()),
    );
  }

  final List<Map<String, String>> onboardingData = [
    {
      "image": "img/onboard1.png",
      "title1": "Life is short and the world is ",
      "title2": "wide",
      "description":
          "At Friends tours and travel, we customize reliable and trustworthy educational tours to destinations all over the world.",
      "button": "Get Started"
    },
    {
      "image": "img/onboard2.png",
      "title1": "It’s a big world out there, go ",
      "title2": "explore",
      "description":
          "To get the best of your adventure you just need to leave and go where you like. We are waiting for you.",
      "button": "Next"
    },
    {
      "image": "img/onboard3.png",
      "title1": "People don’t take trips, trips take ",
      "title2": "people",
      "description":
          "To get the best of your adventure you just need to leave and go where you like. We are waiting for you.",
      "button": "Next"
    },
  ];

  int currentPage = 0;
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
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          double screenHeight = constraints.maxHeight;
          double screenWidth = constraints.maxWidth;

          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  scrollDirection: Axis.horizontal,
                  itemCount: onboardingData.length,
                  itemBuilder: (_, index) {
                    return Column(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(40),
                            bottomRight: Radius.circular(40),
                          ),
                          child: Image.asset(
                            onboardingData[index]["image"]!,
                            width: screenWidth,
                            height: screenHeight * 0.55,  // Adjusted for better fit
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.06, // Reduced padding
                              vertical: screenHeight * 0.04),
                          child: Column(
                            children: [
                              SizedBox(
                                width: screenWidth * 0.8, // Slightly reduced width for better balance
                                child: Column(
                                  children: [
                                    RichText(
                                      textAlign: TextAlign.center,
                                      text: TextSpan(
                                        style: TextStyle(
                                          fontSize: screenHeight * 0.03,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                        children: [
                                          TextSpan(
                                              text: onboardingData[index]
                                                  ["title1"]!),
                                          TextSpan(
                                            text: onboardingData[index]
                                                ["title2"]!,
                                            style: const TextStyle(
                                              color: Color(0xFFFF7029),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: screenHeight * 0.02),
                                    AppText(
                                      text: onboardingData[index]["description"]!,
                                      size: screenHeight * 0.02,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  onboardingData.length,
                  (indexDots) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    margin: const EdgeInsets.only(right: 5),
                    width: currentPage == indexDots ? screenWidth * 0.07 : screenWidth * 0.02,
                    height: screenHeight * 0.01,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: currentPage == indexDots
                          ? const Color(0xFF0D6EFD)
                          : const Color(0xFF0D6EFD).withOpacity(0.3),
                    ),
                  ),
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
                      duration: const Duration(milliseconds: 600),
                      curve: Curves.easeInOut,
                    );
                  }
                },
                child: responciveButton(
                  text: onboardingData[currentPage]["button"]!,
                  border: screenHeight * 0.03,
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
            ],
          );
        },
      ),
    );
  }
}
