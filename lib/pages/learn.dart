import 'package:flutter/material.dart';

class Learn extends StatefulWidget {
  const Learn({super.key});

  @override
  State<Learn> createState() => _LearnState();
}

class _LearnState extends State<Learn> {
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
    return Scaffold(body: PageView(
      children: [
        Center(
          child: Image.asset('img/onboard1.png'),
        ),
        Center(
          child: Image.asset('img/onboard2.png'),
        ),
        Center(
          child: Image.asset('img/onboard3.png'),
        )
      ],
    ));
  }
}
