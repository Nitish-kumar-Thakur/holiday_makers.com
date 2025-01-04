import 'package:flutter/material.dart';
import 'package:holdidaymakers/pages/homePage.dart';
import 'package:holdidaymakers/pages/searchBarpage.dart';
import 'package:holdidaymakers/widgets/appLargetext.dart';
import 'package:holdidaymakers/widgets/appText.dart';
import 'package:holdidaymakers/widgets/bottomNavigationBar.dart';
import 'package:holdidaymakers/widgets/drawerPage.dart';
import 'package:holdidaymakers/widgets/mainCarousel.dart';

class Homepage2 extends StatefulWidget {
  const Homepage2({super.key});

  @override
  State<Homepage2> createState() => _Homepage2State();
}

class _Homepage2State extends State<Homepage2> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List pages = [HomePage(), SearchPage()];
  final List<Color> colors = [
    Colors.amber,
    Colors.blue,
    Colors.purple,
    Colors.red,
    Colors.blueGrey,
    Colors.amber,
    Colors.blue,
    Colors.purple,
    Colors.red,
    Colors.blueGrey,
  ];
  final List<Map<String, String>> picture = [
    {'image': 'img/picture1.png'},
    {'image': 'img/picture2.png'},
    {'image': 'img/picture3.png'},
    {'image': 'img/picture4.png'},
    {'image': 'img/picture5.png'},
    {'image': 'img/picture6.png'},
    {'image': 'img/picture7.png'},
    {'image': 'img/picture8.png'},
  ];
  final List<String> offers = [
    'img/image1.png',
    'img/image1.png',
    'img/image1.png',
    'img/image1.png',
    'img/image1.png',
  ];
  int currentPage = 0; // Track current page index
  int _selectedIndex = 0; // Track selected bottom nav item index

  // Function to switch between pages based on the selected index
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      isSearching = true;
    });
  }

  bool isSearching = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      drawer: Drawerpage(),
      bottomNavigationBar: BottomNavigationBarPage(
          index: _selectedIndex, onTapped: _onItemTapped),
      body: isSearching
          ? pages[_selectedIndex]
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    height: 120,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('img/homeBg.png'),
                            fit: BoxFit.cover)),
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
                          margin:
                              EdgeInsets.only(top: 15, left: 30, bottom: 15),
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
                  Maincarousel(imgList: offers),
                  Container(
                    margin: EdgeInsetsDirectional.only(start: 30),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AppText(
                              text: 'Packages',
                              color: Colors.black,
                              size: 16,
                            ),
                            Row(
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
                            )
                          ],
                        ),
                        Container(
                          width: double.infinity,
                          height: 1,
                          decoration:
                              BoxDecoration(color: Colors.grey.shade300),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 15, right: 15),
                    child: GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap:
                          true, // Important for using GridView inside SingleChildScrollView
                      physics:
                          NeverScrollableScrollPhysics(), // Prevents nested scroll conflicts
                      children: picture.map((pic) {
                        return Container(
                            margin: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                // color: colors[0],
                                // borderRadius: BorderRadius.circular(20),
                                ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  height: 126,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      image: DecorationImage(
                                          image: AssetImage(pic['image']!),
                                          fit: BoxFit.cover)),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AppText(
                                      text: 'HOLIDAY • 6D 5N',
                                      size: 10,
                                      color: Color(0xFF0775BD),
                                    ),
                                    AppLargeText(
                                      text: 'North East India Tour Packages',
                                      size: 11,
                                    ),
                                    AppText(
                                      text: '700 onwards',
                                      size: 10,
                                    )
                                  ],
                                ),
                              ],
                            ));
                      }).toList(),
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
