import 'package:HolidayMakers/pages/homePages/mainPage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<String> images = [
    "img/onimag1.png",
    "img/onimag2.png",
    "img/onimag3.png"
  ];

  final List<String> titles = [
    "Discover hidden gems, plan seamless trips, and embark on unforgettable adventures.",
    "Discover hidden gems, plan seamless trips, and embark on unforgettable adventures.",
    "Discover hidden gems, plan seamless trips, and embark on unforgettable adventures."
  ];

  final List<String> descriptions = [
    "Whether you're craving a relaxing getaway or a thrilling expedition, we've got you covered!",
    "",
    ""
  ];

  final List<double> titleTopPositions = [
    100, 200, 50
  ];

  final List<double> descriptionBottomPositions = [
    150, 0, 0
  ];

  void _nextPage() async{
  if (_currentPage < images.length - 1) {
    _pageController.nextPage(duration: Duration(milliseconds: 300), curve: Curves.ease);
  } else {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isOnboardingComplete', true);
    // Navigate to the specific page (e.g., HomeScreen)
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Mainpage()), // Replace with your target screen
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: images.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              return Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(images[index], fit: BoxFit.cover),
                  Positioned(
                    top: titleTopPositions[index],
                    left: 20,
                    right: 20,
                    child: _buildTextContainer(titles[index]),
                  ),
                  if (descriptions[index].isNotEmpty)
                    Positioned(
                      bottom: descriptionBottomPositions[index],
                      left: 20,
                      right: 20,
                      child: _buildTextContainer(descriptions[index]),
                    ),
                ],
              );
            },
          ),
          Positioned(
            bottom: 80,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                images.length,
                (index) => Container(
                  margin: EdgeInsets.symmetric(horizontal: 4),
                  width: _currentPage == index ? 70 : 70,
                  height: 3,
                  decoration: BoxDecoration(
                    color: _currentPage == index ? Colors.blue : Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: ElevatedButton(
              onPressed: _nextPage,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                minimumSize: Size(double.infinity, 50),
              ),
              child: Text(
                _currentPage == images.length - 1 ? "Continue Without Sign Up" : "Continue",
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextContainer(String text) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
    );
  }
}
