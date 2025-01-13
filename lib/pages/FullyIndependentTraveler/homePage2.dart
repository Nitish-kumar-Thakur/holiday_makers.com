import 'package:flutter/material.dart';
import 'package:holdidaymakers/pages/FullyIndependentTraveler/trip_details_page.dart';
import 'package:holdidaymakers/widgets/appLargetext.dart';
import 'package:holdidaymakers/widgets/appText.dart';
import 'package:holdidaymakers/widgets/drawerPage.dart';
import 'package:holdidaymakers/widgets/mainCarousel.dart';

class Homepage2 extends StatefulWidget {
  const Homepage2({super.key});

  @override
  State<Homepage2> createState() => _Homepage2State();
}

class _Homepage2State extends State<Homepage2> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
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

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      key: _scaffoldKey,
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
              decoration: BoxDecoration(
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
                    decoration: BoxDecoration(
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
                      image: AssetImage('img/brandLogo.png'),
                    ),
                  ),
                ),
              ],
            ),
            Maincarousel(imgList: offers),
            Container(
              margin: EdgeInsets.only(left: 15),
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
                    ],
                  ),
                  Container(
                    width: double.infinity,
                    height: 1,
                    color: Colors.grey,
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: picture.map((pic) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TripDetailsPage(),
                        ),
                      );
                    },
                    child: ResponsiveCard(
                      image: pic['image']!,
                      title: 'North East India Tour Packages',
                      subtitle: 'HOLIDAY • 6D 5N',
                      price: '700 onwards',
                      screenWidth: screenWidth,
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ResponsiveCard extends StatelessWidget {
  final String image;
  final String title;
  final String subtitle;
  final String price;
  final double screenWidth;

  const ResponsiveCard({
    Key? key,
    required this.image,
    required this.title,
    required this.subtitle,
    required this.price,
    required this.screenWidth
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 120,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              image: DecorationImage(
                image: AssetImage(image),
                fit: BoxFit.fill,
              ),
            ),
          ),
          SizedBox(height: 4),
          Padding(
            padding: EdgeInsets.only(left: screenWidth * 0.01),
            child: Text(
              subtitle,
              style: TextStyle(
                color: Color(0xFF0775BD),
                fontSize: screenWidth * 0.020,
              ),
            ),
          ),
          Padding(
              padding: EdgeInsets.only(left: screenWidth * 0.01),
              child: Text(
                title,
                style: TextStyle(fontSize: screenWidth * 0.022, fontWeight: FontWeight.bold),
              )),
          Padding(
            padding: EdgeInsets.only(left: screenWidth * 0.01),
            child: Text(
              price,
              style: TextStyle(fontSize:screenWidth * 0.020,),
            ),
          ),
        ],
      ),
    );
  }
}
