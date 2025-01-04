import 'package:flutter/material.dart';
import 'package:holdidaymakers/pages/homePage2.dart';
import 'package:holdidaymakers/widgets/appText.dart';
import 'package:holdidaymakers/widgets/bottomNavigationBar.dart';
import 'package:holdidaymakers/widgets/customizeSearch.dart';
import 'package:holdidaymakers/widgets/drawerPage.dart';
import 'package:holdidaymakers/widgets/mainCarousel.dart';
import 'package:holdidaymakers/widgets/subCarousel.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>(); // Define GlobalKey

  // List of images for the carousel
  final List<String> offers = [
    'img/image1.png',
    'img/image1.png',
    'img/image1.png',
    'img/image1.png',
    'img/image1.png',
  ];
  final List<String> recomended = [
    'img/recomended1.png',
    'img/recomended2.png',
    'img/recomended3.png',
    'img/recomended1.png',
    'img/recomended2.png',
  ];

  final List<String> winter = [
    'img/winter1.png',
    'img/winter2.png',
    'img/winter3.png',
    'img/winter1.png',
    'img/winter2.png',
  ];
  final List<String> eid = [
    'img/winter1.png',
    'img/winter2.png',
    'img/winter3.png',
    'img/winter1.png',
    'img/winter2.png',
  ];
  void navigateToSeeAll() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Homepage2()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      drawer: Drawerpage(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 120,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('img/homeBg.png'), fit: BoxFit.cover)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    height: 45,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.white70,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(100),
                            topRight: Radius.circular(100))),
                  )
                ],
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    _scaffoldKey.currentState?.openDrawer();
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    margin: EdgeInsets.only(top: 15, left: 30, bottom: 15),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Container(
                    height: 40,
                    width: 200,
                    margin: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                        image: DecorationImage(
                      image: AssetImage(
                        'img/brandLogo.png',
                      ),
                    ))),
              ],
            ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [Customizesearch()],
            // ),
            Maincarousel(imgList: offers),
            Container(
              margin: EdgeInsetsDirectional.only(start: 30),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AppText(
                        text: 'Recommended',
                        color: Colors.black,
                        size: 16,
                      ),
                      IconButton(
                          onPressed: navigateToSeeAll,
                          icon: Row(
                            children: [
                              AppText(
                                text: 'See All',
                                color: Color(0xFF0775BD),
                                size: 15,
                              ),
                              Image.asset('img/seeAll.png'),
                              SizedBox(
                                width: 5,
                              )
                            ],
                          ))
                    ],
                  ),
                  Container(
                    width: double.infinity,
                    height: 1,
                    decoration: BoxDecoration(color: Colors.grey.shade300),
                  )
                ],
              ),
            ),
            Subcarousel(lists: recomended),
            SizedBox(height: 20),
            Container(
              margin: EdgeInsetsDirectional.only(start: 30),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AppText(
                        text: 'Winters Holidays',
                        color: Colors.black,
                        size: 16,
                      ),
                      IconButton(
                          onPressed: navigateToSeeAll,
                          icon: Row(
                            children: [
                              AppText(
                                text: 'See All',
                                color: Color(0xFF0775BD),
                                size: 15,
                              ),
                              Image.asset('img/seeAll.png'),
                              SizedBox(
                                width: 5,
                              )
                            ],
                          ))
                    ],
                  ),
                  Container(
                    width: double.infinity,
                    height: 1,
                    decoration: BoxDecoration(color: Colors.grey.shade300),
                  )
                ],
              ),
            ),
            Subcarousel(lists: eid),
            SizedBox(height: 20),
            Container(
              margin: EdgeInsetsDirectional.only(start: 30),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AppText(
                        text: 'Eid',
                        color: Colors.black,
                        size: 16,
                      ),
                      IconButton(
                          onPressed: navigateToSeeAll,
                          icon: Row(
                            children: [
                              AppText(
                                text: 'See All',
                                color: Color(0xFF0775BD),
                                size: 15,
                              ),
                              Image.asset('img/seeAll.png'),
                              SizedBox(
                                width: 5,
                              )
                            ],
                          ))
                    ],
                  ),
                  Container(
                    width: double.infinity,
                    height: 1,
                    decoration: BoxDecoration(color: Colors.grey.shade300),
                  )
                ],
              ),
            ),
            Subcarousel(
              lists: winter,
            ),
          ],
        ),
      ),
      // Bottom Navigation Bar
      // bottomNavigationBar: BottomNavigationBarPage(index: _selectedIndex, onTapped: _onItemTapped),
    );
  }
}
