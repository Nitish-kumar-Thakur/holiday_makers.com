import 'package:flutter/material.dart';
import 'package:HolidayMakers/pages/FixedDeparturesPages/departurePackagedetails.dart';
import 'package:HolidayMakers/utils/api_handler.dart';
import 'package:HolidayMakers/widgets/appText.dart';
import 'package:HolidayMakers/widgets/drawerPage.dart';
import 'package:HolidayMakers/widgets/mainCarousel.dart';
import 'package:HolidayMakers/widgets/responcive_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Departurespackages extends StatefulWidget {
  const Departurespackages({super.key});

  @override
  State<Departurespackages> createState() => _DeparturespackagesState();
}

class _DeparturespackagesState extends State<Departurespackages> {
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

  List<Map<String, dynamic>> banner_list = [];
  @override
  void initState() {
    super.initState();
    _loadProfileDetails();
    _fetchHomePageData(); // Fetch data on initialization
  }

  String profileImg = '';
  bool isLoading = true;

  Future<void> _loadProfileDetails() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        profileImg = prefs.getString("profileImg") ?? "";
      });
    } catch (error) {
      print("Error loading profile details: $error");
    }
  }

  Future<void> _fetchHomePageData() async {
    try {
      final data = await APIHandler.HomePageData();

      setState(() {
        banner_list = List<Map<String, dynamic>>.from(
          data['data']['banner_list'].map((item) => {
                'img': item['img'],
                'mobile_img': item['mobile_img'],
                'link': item['link'],
              }),
        );
        isLoading = false; // Data fetched, set loading to false
      });
    } catch (e) {
      setState(() {
        isLoading = false; // If error occurs, also stop loading
      });
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      drawer: Drawerpage(),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: Colors.red,
              ), // Show loader until data is fetched
            )
          : SingleChildScrollView(
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
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: CircleAvatar(
                            backgroundImage: profileImg.isNotEmpty
                                ? NetworkImage(profileImg)
                                : const AssetImage('img/placeholder.png')
                                    as ImageProvider,
                            minRadius: 22,
                            maxRadius: 22,
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
                  Maincarousel(banner_list: banner_list),
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
                                builder: (context) => DeparturePackageDetails(),
                              ),
                            );
                          },
                          child: ResponsiveCard2(
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
