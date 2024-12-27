import 'package:flutter/material.dart';
import 'package:holdidaymakers/pages/login&signup/loginPage.dart';
import 'package:holdidaymakers/pages/login&signup/signupPage.dart';
import 'package:holdidaymakers/widgets/appLargetext.dart';
import 'package:holdidaymakers/widgets/appText.dart';

import 'package:holdidaymakers/widgets/responciveButton.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({super.key});

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  
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
            itemCount: 3,
            itemBuilder: (_, index) {
              return Column(
                children: [
                  // Image Container
                  Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height *
                        0.5, // Adjust height as needed
                    child: Center(
                      child: Image.asset(
                        'img/traveller1.png',
                        fit: BoxFit
                            .contain, // Ensures the image scales without distortion
                      ),
                    ),
                  ),
                  // Title & Description
                ],
              );
            },
          ),

          // Fixed Button at the bottom
          Positioned(
            bottom: 55, // Adjust this value to position the button
            left: 0,
            right: 0,
            child: Column(
              children: [
                Container(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    3,
                    (indexDots) {
                      return AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        curve:Curves.easeInOut,
                        margin: EdgeInsets.only(right: 5),
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: currentPage == indexDots
                              ? Color(0xFF00CEC9)
                              : Color(0xFFDFE6E9),
                        ),
                      );
                    },
                  ),
                )),
                SizedBox(
                  height: 30,
                ),
                Container(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AppLargeText(text: 'Plan Your Trip'),
                          SizedBox(
                            height: 50,
                          ),
                            Container(
                              width: 200,
                              child: AppText(
                                text:
                                    'Custom and fast planning with a low price',
                                color: Colors.black,
                              )),
                        ],
                      ),
                    )
                  ],
                )),
                SizedBox(
                  height: 60,
                ),
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
                SizedBox(
                  height: 20,
                ),
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
                    
                      )
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
}
