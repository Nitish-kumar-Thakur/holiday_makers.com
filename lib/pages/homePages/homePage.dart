import 'package:HolidayMakers/pages/Cruise/CurisesHome.dart';
import 'package:HolidayMakers/pages/FixedDeparturesPages/departuresHome.dart';
import 'package:HolidayMakers/pages/FullyIndependentTraveler/independentTravelerPage.dart';
import 'package:HolidayMakers/pages/homePages/homePageCategory.dart';
import 'package:flutter/material.dart';
import 'package:HolidayMakers/pages/homePages/homePage2.dart';
import 'package:HolidayMakers/utils/api_handler.dart';
import 'package:HolidayMakers/widgets/appText.dart';
import 'package:HolidayMakers/widgets/drawerPage.dart';
import 'package:HolidayMakers/widgets/mainCarousel.dart';
import 'package:HolidayMakers/widgets/subCarousel.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

class HomePage extends StatefulWidget {
  final Function(bool)? onDrawerToggle;
  const HomePage({super.key, this.onDrawerToggle});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String profileImg = '';
  bool isLoading = true;
  List<Map<String, dynamic>> bannerList = [];
  List<Map<String, dynamic>> sections = [];
  List<Map<String, dynamic>> categoryList = [];

  @override
  void initState() {
    super.initState();
    _loadProfileDetails();
    _fetchHomePageData();
  }

  Future<void> _loadProfileDetails() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      profileImg = prefs.getString("profileImg") ?? "";
    });
  }

  Future<void> _fetchHomePageData() async {
    try {
      final data = await APIHandler.HomePageData();

      setState(() {
        bannerList = List<Map<String, dynamic>>.from(
          data['data']['banner_list'].map((item) => {
            'img': item['img'],
            'mobile_img': item['mobile_img'],
            'link': item['link'],
          }),
        );
        categoryList = List<Map<String, dynamic>>.from(
          data['data']['category_list'].map((item) => {
            'id': item['category_id'],
            'title': item['category_name'],
            'link': item['category_url'],
          }),
        );
        // isLoading = false;
        // print("Category List: $categoryList");
      });
      _fetchPackageData();
    } catch (e) {
      print('Error fetching homepage data: $e');
    }
  }

  Future<void> _fetchPackageData() async {
    try {
      final data = await APIHandler.getPackagesData();

      List<Map<String, dynamic>> fetchedSections = (data['data'] as List)
          .map((category) => {
        'title': category['category_name'],
        'list': List<Map<String, dynamic>>.from(
            category['package_list'].map((package) => {
              'image': package['package_homepage_image'],
              'name': package['package_name'],
              'price': package['discounted_price'] ??
                  package['starting_price'],
              'tempPrice': package['starting_price'] ??
                  package['discounted_price'],
              'currency': package['currency'],
              'country': package['country_name'],
              "id": package["package_type"],
              "packageId": package["package_id"],
              "dep_date": package["dep_date"]
            })),
      })
          .toList();

      setState(() {
        sections = fetchedSections;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching package data: $e');
    }
  }

  void navigateToSeeAll(List<Map<String, dynamic>> packageList, String title) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => Homepage2(
            packageList: packageList,
            title: title,
            banner_list: bannerList,
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      drawer: Drawerpage(),
      onDrawerChanged: widget.onDrawerToggle,
      body: isLoading ? _buildLoadingSkeleton() : _buildContent(),
    );
  }

  //  Loading Skeleton UI
  Widget _buildLoadingSkeleton() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 40,
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _shimmerContainer(
                    width: 50,
                    height: 50,
                    shape: BoxShape.circle), // Profile Placeholder
                _shimmerContainer(width: 150, height: 40), // Logo Placeholder
              ],
            ),
          ),
          _shimmerContainer(height: 200), // Carousel Placeholder
          for (var i = 0; i < 3; i++)
            _buildSectionSkeleton(), // Sample Sections
        ],
      ),
    );
  }

  //  Shimmer Container (for placeholders)
  Widget _shimmerContainer(
      {double width = double.infinity,
        double height = 20,
        BoxShape shape = BoxShape.rectangle}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: shape,
          borderRadius:
          shape == BoxShape.circle ? null : BorderRadius.circular(8),
        ),
      ),
    );
  }

  //  Section Skeleton
  Widget _buildSectionSkeleton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _shimmerContainer(width: 100, height: 20), // Title Placeholder
          const SizedBox(height: 5),
          _shimmerContainer(height: 120), // Carousel Placeholder
        ],
      ),
    );
  }

  //  Actual Content UI
  Widget _buildContent() {
    
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTopCurve(),
          _buildProfileSection(),
          Maincarousel(banner_list: bannerList),
          SizedBox(
            height: 10,
          ),
          _buildIconRowSection(),
          _buildCategorySection(),
          _buildDynamicSections(),
          SizedBox(height: 100,)
        ],
      ),
    );
  }

  // Curved Curtain Shape at the Top (with 20% margin)
  Widget _buildTopCurve() {
    return Padding(
      padding: const EdgeInsets.only(top: 30), // 20% of the screen height
      child: CustomPaint(
        size: Size(double.infinity, 20), // Height of the curved area
        painter: CirclePainter(radius: 200),
      ),
    );
  }

  //  Profile Avatar and Brand Logo
  Widget _buildProfileSection() {
    final screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => _scaffoldKey.currentState?.openDrawer(),
            child: CircleAvatar(
              backgroundImage: profileImg.isNotEmpty
                  ? NetworkImage(profileImg)
                  : const AssetImage('img/placeholder.png') as ImageProvider,
              minRadius: 22,
              maxRadius: 22,
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                height: 40,
                width: 180,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('img/brandLogo.png'),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(height: 0), // Optional: explicitly no space
              const Text(
                'Explore World with us!',
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySection() {
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        // border:
      ),
      padding: EdgeInsets.only(top: 10),
      child: Wrap(
        spacing: 5,
        runSpacing: 5,
        alignment: WrapAlignment.center,
        children: categoryList.map((category) {
          return ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => HomePageCategory(
                      categoryId: category["id"],
                      banner_list: bannerList,
                    )),
              );
            },
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.all(12),
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: const BorderSide(color: Colors.black, width: 0.5)),
            ),
            child: Text(
              category['title'].toString(),
              style: TextStyle(
                  color: Colors.black,
                  fontSize: screenWidth * 0.03,
                  fontWeight: FontWeight.bold),
            ),
          );
        }).toList(),
      ),
    );
  }

  //  Dynamic Sections
  Widget _buildDynamicSections() {
    return ListView.builder(
      padding: EdgeInsets.only(top: 10),

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
                  Text(
                    section['title'].toString().toUpperCase(),
                    style: TextStyle(
                      color: Color(0xFF009EE2),
                      fontSize: 22,
                      fontWeight: FontWeight.w900, // Apply bold style
                    ),
                  ),
                  GestureDetector(
                    onTap: () =>
                        navigateToSeeAll(section['list'], section['title']),
                    child: Padding(
                      padding: const EdgeInsets.only(right: 5),
                      child: Row(
                        children: [
                          AppText(
                              text: 'See All', color: Colors.black, size: 15),
                          const SizedBox(width: 1),
                          ColorFiltered(
                            colorFilter: ColorFilter.mode(
                              Colors.black,
                              BlendMode.srcIn,
                            ),
                            child: Image.asset(
                              'img/seeAll.png',
                              height: 16,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Padding(
                padding: EdgeInsets.only(left: 15),
                child: Divider(color: Colors.grey)),
            GestureDetector(
              child: Subcarousel(
                lists: section['list'],
                title: section['title'],
              ),
            ),
            const SizedBox(height: 20),
          ],
        );
      },
    );
  }

  Widget _buildIconRowSection() {
    final screenWidth = MediaQuery.of(context).size.width;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => const IndependentTravelerPage()),
            );
          },
          child: Container(
            width: screenWidth * 0.28,
            height: screenWidth * 0.28,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Color(0xFF009EE2).withOpacity(0.2),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: Color(0xFF009EE2), width: 1.5),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'img/fitHomeIcon.png',
                  width: 50,
                  height: 50,
                ),
                const SizedBox(height: 8),
                Text(
                  'FIT Holiday',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: screenWidth * 0.03,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => DeparturesHome(
                    banner_list: bannerList,
                  )),
            );
          },
          child: Container(
            width: screenWidth * 0.28,
            height: screenWidth * 0.28,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Color(0xFF009EE2).withOpacity(0.2),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: Color(0xFF009EE2), width: 1.5),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'img/fdHomeIcon.png',
                  width: 50,
                  height: 50,
                ),
                const SizedBox(height: 8),
                Text(
                  'FD Holiday',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: screenWidth * 0.03,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => CurisesHome(
                    banner_list: bannerList,
                  )),
            );
          },
          child: Container(
            width: screenWidth * 0.28,
            height: screenWidth * 0.28,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Color(0xFF009EE2).withOpacity(0.2),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: Color(0xFF009EE2), width: 1.5),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'img/cruiseHomeIcon.png',
                  width: 50,
                  height: 50,
                ),
                const SizedBox(height: 8),
                Text(
                  'Cruise',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: screenWidth * 0.03,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class CirclePainter extends CustomPainter {
  final double radius;

  CirclePainter({required this.radius});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..style = PaintingStyle.fill;

    // We can use FontAwesome icon positioning logic here.
    double centerX = size.width / 2;

    // Draw the smallest circle (light blue)
    // paint.color = Color(0xFFEDF2F4); // Light blue
    // canvas.drawCircle(Offset(centerX, radius - 150), radius + 100, paint);

    // // Draw the medium circle (medium blue)
    // paint.color = Color(0xFF4AA9BC); // Medium blue
    // canvas.drawCircle(Offset(centerX, radius - 300), radius + 200, paint);

    // Draw the largest circle (dark blue)
    paint.color = Color(0xFF009EE2).withOpacity(0.2); // Dark blue
    canvas.drawCircle(Offset(centerX, radius - 330), radius + 300, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
