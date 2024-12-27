import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:holdidaymakers/pages/introPage.dart';
import 'package:holdidaymakers/widgets/appLargetext.dart';
import 'package:holdidaymakers/widgets/appText.dart';
import 'package:holdidaymakers/widgets/responciveButton.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardPage2 extends StatefulWidget {
  const OnboardPage2({super.key});

  @override
  State<OnboardPage2> createState() => _OnboardPage2State();
}

class _OnboardPage2State extends State<OnboardPage2> {
  List<Map<String, String>> onboardingData = [
    {
      "image": "img/onboard1.png",
      "title": "Life is short and the world is wide",
      "description":
          "At Friends tours and travel, we customize reliable and trustworthy educational tours to destinations all over the world",
      "button": "Get Started"
    },
    {
      "image": "img/onboard2.png",
      "title": "It’s a big world out there, go explore",
      "description":
          "To get the best of your adventure you just need to leave and go where you like. We are waiting for you",
      "button": "Next"
    },
    {
      "image": "img/onboard3.png",
      "title": "People don’t take trips, trips take people",
      "description":
          "To get the best of your adventure you just need to leave and go where you like. We are waiting for you",
      "button": "Next"
    },
  ];
  int currentPage = 0; // Track current page index

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
        children: [
          // PageView with onboarding content
          CarouselSlider.builder(
                  itemCount: onboardingData.length,
                  itemBuilder: (context, index, realIndex) {
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
                        Container( width: 280,
                          child: Column(
                            children: [
                              AppLargeText(
                          text: onboardingData[index]["title"]!,
                          size: 24,
                        ),
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
                  options: CarouselOptions(
                      height: 200.0,
                      autoPlay: true,
                      autoPlayInterval: Duration(seconds: 3),
                      autoPlayAnimationDuration: Duration(milliseconds: 800),
                      enlargeCenterPage: true,
                      viewportFraction: 1.0,
                      aspectRatio: 16 / 9,
                      onPageChanged: (index, carouselPageChangedReason) {
                        setState(() {
                          currentPage = index;
                        });
                      }
                      // scrollPhysics: BouncingScrollPhysics()
                      )),
                      Row( mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AnimatedSmoothIndicator(activeIndex: currentPage, count: onboardingData.length,
                          effect: JumpingDotEffect(
                            dotHeight: 10,
                            dotWidth: 10,
                            activeDotColor: Colors.red,
                            dotColor: Colors.blue.shade200,
                            
                          ),)
                        ],
                      ),SizedBox(height: 50,),
                      Center(
              child: GestureDetector(
                onTap: () {
                  if (currentPage == onboardingData.length - 1) {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => IntroPage())
                        );
                    // Action when the user finishes onboarding
                  } 
                },
                child:Column(
                  children: [
                  SizedBox(height: 35,),
                  responciveButton(
                  text: onboardingData[currentPage]["button"]!,border: 20,
                ),
                  ],
                ) 
              ),
            ),
          // Fixed Button at the botto
        ],
      ),
      )
    );
  }
}
