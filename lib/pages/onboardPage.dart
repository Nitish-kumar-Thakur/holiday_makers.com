import 'package:flutter/material.dart';
import 'package:holdidaymakers/pages/introPage.dart';
import 'package:holdidaymakers/widgets/appText.dart';
import 'package:holdidaymakers/widgets/responciveButton.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class OnboardPage extends StatefulWidget {
  const OnboardPage({super.key});

  @override
  State<OnboardPage> createState() => _OnboardPageState();
}

class _OnboardPageState extends State<OnboardPage> {
  List<Map<String, String>> onboardingData = [
    {
      "image": "img/onboard1.png",
      "title1": "Life is short and the world is ",
      "title2":"wide",
      "description":
          "At Friends tours and travel, we customize reliable and trustworthy educational tours to destinations all over the world",
      "button": "Get Started"
    },
    {
      "image": "img/onboard2.png",
      "title1": "It’s a big world out there, go ",
      "title2":"explore",
      "description":
          "To get the best of your adventure you just need to leave and go where you like. We are waiting for you",
      "button": "Next"
    },
    {
      "image": "img/onboard3.png",
      "title1": "People don’t take trips, trips take ",
      "title2":"people",
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
                    height: MediaQuery.of(context).size.height * 0.6,
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
                    padding: const EdgeInsets.all(30.0),
                    child: Column(
                      children: [
                        SizedBox(
                          width: 280,
                          child: Column( 
                            children: [
                              RichText(textAlign: TextAlign.center,
                                text: TextSpan(
                                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold,color: Colors.black,),
                                children: [
                                  TextSpan(text:onboardingData[index]["title1"]!),
                                  TextSpan( 
                                    children: []),
                                  TextSpan(text: onboardingData[index]["title2"]!, style: TextStyle(color: Color(0xFFFF7029),
                                )),
                                ]
                              )),
                              
                              SizedBox(height: 10),
                              AppText(
                                text: onboardingData[index]["description"]!,
                                size: 16,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  // Dots Indicator
                ],
              );
            },
          ),
          // Fixed Button at the bottom
          Positioned(
            bottom: 40, // Adjust this value to position the button
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
                        width: currentPage == indexDots ? 25 : 8,
                        height: 8,
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
                SizedBox(
                  height: 35,
                ),
                GestureDetector(
                  onTap: () async {
                    // final prefs = await SharedPreferences.getInstance();
                    if (currentPage == onboardingData.length - 1) {
                      // prefs.setBool('onBoardScreen', true);
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => IntroPage()));
                      // Action when the user finishes onboarding
                    } else {
                      // Move to the next page
                      _pageController.animateToPage(
                        currentPage + 1,
                        duration: Duration(milliseconds: 600),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                  child: responciveButton(
                    text: onboardingData[currentPage]["button"]!,
                    border: 20,
                  ),
                ),
              ],
            )),
          ),
        ],
      ),
    );
  }
}
