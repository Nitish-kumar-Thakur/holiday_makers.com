import 'package:flutter/material.dart';
import 'package:holdidaymakers/pages/FullyIndependentTraveler/trip_details_page.dart';
import 'package:holdidaymakers/pages/FullyIndependentTraveler/homePage2.dart';
import 'package:holdidaymakers/widgets/appText.dart';
import 'package:holdidaymakers/widgets/bottomNavigationBar.dart';
import 'package:holdidaymakers/widgets/drawerPage.dart';
import 'package:holdidaymakers/widgets/mainCarousel.dart';
import 'package:holdidaymakers/widgets/subCarousel.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<String> offers = ['img/image1.png', 'img/image1.png','img/image1.png','img/image1.png'];

  // List of dynamic sections
  final List<Map<String, dynamic>> sections = [
    {
      'title': 'Recommended',
      'list': ['img/recomended1.png', 'img/recomended2.png','img/recomended3.png'],
    },
    {
      'title': 'Winter Holidays',
      'list': ['img/winter1.png', 'img/winter2.png','img/winter2.png'],
    },
    {
      'title': 'Eid',
      'list': ['img/winter1.png', 'img/winter2.png','img/winter2.png'],
    },
  ];

  void navigateToSeeAll() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => const Homepage2()));
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
            // Header Section
            Container(
              width: double.infinity,
              height: 120,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('img/homeBg.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    height: 45,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white70,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(100),
                        topRight: Radius.circular(100),
                      ),
                    ),
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
                  child: Padding(padding: EdgeInsets.only(left: 20,),
                  child: CircleAvatar(
                        backgroundImage: NetworkImage(
                            'https://via.placeholder.com/150'), minRadius: 22, maxRadius: 22, // Placeholder image
                      ),
                      )
                ),
                Container(
                  height: 40,
                  width: 200,
                  margin: const EdgeInsets.all(15),
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('img/brandLogo.png'),
                    ),
                  ),
                ),
              ],
            ),

            // Main Carousel
            Maincarousel(imgList: offers),

            // Dynamic Sections using ListView.builder
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: sections.length,
              itemBuilder: (context, index) {
                final section = sections[index];
                return Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AppText(
                            text: section['title'],
                            color: Colors.black,
                            size: 16,
                          ),
                          GestureDetector(
                            onTap: navigateToSeeAll,
                            child: Padding(padding: EdgeInsets.only(right: 5),
                            child: Row(
                              children: [
                                AppText(
                                  text: 'See All',
                                  color: const Color(0xFF0775BD),
                                  size: 15,
                                ),
                                const SizedBox(width: 1),
                                Image.asset('img/seeAll.png', height: 16),
                              ],
                            ),)
                          ),
                        ],
                      ),
                    ),
                    Padding(padding: const EdgeInsets.only(left: 15), child: const Divider(color: Colors.grey)),
                    Padding( padding: const EdgeInsets.only(left: 15),child: IconButton(onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const TripDetailsPage()));
                    }, icon: Subcarousel(lists: section['list'])),),
                    const SizedBox(height: 20),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
