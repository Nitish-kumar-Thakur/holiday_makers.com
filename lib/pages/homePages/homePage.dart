import 'package:flutter/material.dart';
import 'package:HolidayMakers/pages/homePages/homePage2.dart';
import 'package:HolidayMakers/utils/api_handler.dart';
import 'package:HolidayMakers/widgets/appText.dart';
import 'package:HolidayMakers/widgets/drawerPage.dart';
import 'package:HolidayMakers/widgets/mainCarousel.dart';
import 'package:HolidayMakers/widgets/subCarousel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String profileImg = '';
  bool isLoading = true;
  List<Map<String, dynamic>> bannerList = [];
  List<Map<String, dynamic>> sections = [];

  @override
  void initState() {
    super.initState();
    _loadProfileDetails();
    _fetchHomePageData();
    _fetchPackageData();
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
        isLoading = false;
      });
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
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching package data: $e');
    }
  }

  void navigateToSeeAll(List<Map<String, dynamic>> packageList) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => Homepage2(packageList: packageList)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      drawer: Drawerpage(),
      body: isLoading ? _buildLoadingSkeleton() : _buildContent(),
    );
  }

  //  Loading Skeleton UI
  Widget _buildLoadingSkeleton() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _shimmerContainer(height: 120), // Header Placeholder
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
          _buildHeader(),
          _buildProfileSection(),
          Maincarousel(banner_list: bannerList),
          _buildDynamicSections(),
        ],
      ),
    );
  }

  //  Header Section
  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      height: 120,
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage('img/homeBg.png'), fit: BoxFit.cover),
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
                  topRight: Radius.circular(100)),
            ),
          ),
        ],
      ),
    );
  }

  //  Profile Avatar and Brand Logo
  Widget _buildProfileSection() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () => _scaffoldKey.currentState?.openDrawer(),
          child: Padding(
            padding: const EdgeInsets.only(left: 20),
            child: CircleAvatar(
              backgroundImage: profileImg.isNotEmpty
                  ? NetworkImage(profileImg)
                  : const AssetImage('img/placeholder.png') as ImageProvider,
              minRadius: 22,
              maxRadius: 22,
            ),
          ),
        ),
        Container(
          height: 40,
          width: 200,
          margin: const EdgeInsets.all(15),
          decoration: const BoxDecoration(
              image: DecorationImage(image: AssetImage('img/brandLogo.png'))),
        ),
      ],
    );
  }

  //  Dynamic Sections
  Widget _buildDynamicSections() {
    return ListView.builder(
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
                      text: section['title'], color: Colors.black, size: 16),
                  GestureDetector(
                    onTap: () => navigateToSeeAll(section['list']),
                    child: Padding(
                      padding: const EdgeInsets.only(right: 5),
                      child: Row(
                        children: [
                          AppText(
                              text: 'See All',
                              color: const Color(0xFF0775BD),
                              size: 15),
                          const SizedBox(width: 1),
                          Image.asset('img/seeAll.png', height: 16),
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
              // onTap: () {
              //   print(section["list"]["package_type"]);
              //   if (section["list"]["package_type"] == "cruise") {
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(builder: (context) => CruiseDealsPage()),
              //     );
              //   } else {
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(builder: (context) => DepartureDeals()),
              //     );
              //   }
              // },
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
}
