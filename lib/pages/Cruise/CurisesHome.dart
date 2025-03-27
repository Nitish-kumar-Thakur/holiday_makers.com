import 'package:HolidayMakers/widgets/mainCarousel.dart';
import 'package:flutter/material.dart';
import 'package:HolidayMakers/pages/Cruise/cruisePackagedetails.dart';
import 'package:HolidayMakers/utils/api_handler.dart';
import 'package:HolidayMakers/widgets/appLargetext.dart';
import 'package:HolidayMakers/widgets/drawerPage.dart';
import 'package:HolidayMakers/widgets/dropdownWidget.dart';
import 'package:HolidayMakers/widgets/responcive_card.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

class CurisesHome extends StatefulWidget {
  const CurisesHome({Key? key}) : super(key: key);

  @override
  State<CurisesHome> createState() => _CurisesHomeState();
}

class _CurisesHomeState extends State<CurisesHome> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String? selectedCountry; // Nullable for dropdown selection.
  String? selectedMonth; // Nullable for dropdown selection.

  List<Map<String, String>> countryList = []; // Country list from API.
  List<Map<String, String>> monthList = []; // Month list from API.
  List<Map<String, dynamic>> cruisePackages = []; // Package data for cruises.
  List<Map<String, dynamic>> bannerList = [];

  String profileImg = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfileDetails();
    _fetchCountryAndMonthLists(); // Fetch dropdown data.
    _fetchCruisePackages('', ''); // Fetch cruise package data.
    _fetchHomePageData();
  }

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

  Future<void> _fetchCountryAndMonthLists() async {
    try {
      final response = await APIHandler.fetchCruiseCountryMonthList("");
      debugPrint('Country and Month Data: $response');

      setState(() {
        // Add "All" option to both lists
        countryList = [
          {'name': 'All', 'code': ''}, // "All" option for countries
          ...response['countryList']!,
        ];
        monthList = [
          {'name': 'All', 'code': ''}, // "All" option for months
          ...response['monthList']!,
        ];
      });
    } catch (error) {
      debugPrint('Error fetching country and month lists: $error');
    }
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

  Future<void> _fetchCruisePackages(String country, String month) async {
    print(country);
    print(month);
    try {
      final data =
          await APIHandler.getNewPackagesData("cruise", country, month);
      setState(() {
        if (data['status'] == true) {
          cruisePackages = (data['data']['package_list'] as List)
              .map<Map<String, dynamic>>((package) => {
                    'image': package['package_homepage_image'],
                    'name': package['package_name'],
                    'price': package['discounted_price'],
                    'currency': package['currency'],
                    'country': package['country_name'],
                    "packageid": package["package_id"]
                  })
              .toList();
        } else {
          cruisePackages = []; // Empty list if no packages are found
        }
        isLoading = false;
      });
    } catch (error) {
      debugPrint('Error fetching cruise packages: $error');
      setState(() {
        isLoading = false;
        cruisePackages = []; // Empty list in case of error
      });
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
          ? _buildLoadingState()
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // _buildHeader(),
                  // _buildProfileSection(),
                  CustomPaint(
                    size: Size(double.infinity, 80),
                    painter: CirclePainter(radius: 200),
                  ),
                  Maincarousel(banner_list: bannerList),
                  _buildDropdownSection(),
                  _buildPackageGrid(screenWidth),
                ],
              ),
            ),
    );
  }

  Widget _buildLoadingState() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeaderShimmer(),
          _buildProfileSectionShimmer(),
          _buildDropdownSectionShimmer(),
          _buildPackageGridShimmer(),
        ],
      ),
    );
  }

  // Shimmer Effect for Header
  Widget _buildHeaderShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: double.infinity,
        height: 120,
        color: Colors.white,
      ),
    );
  }

  // Shimmer Effect for Profile Section
  Widget _buildProfileSectionShimmer() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: CircleAvatar(
              backgroundColor: Colors.white,
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
            color: Colors.white,
          ),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(color: Colors.white),
          ),
        ),
      ],
    );
  }

  // Shimmer Effect for Dropdown Section
  Widget _buildDropdownSectionShimmer() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              width: 200,
              height: 30,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              width: double.infinity,
              height: 50,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 15),
          Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              width: double.infinity,
              height: 50,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  // Shimmer Effect for Package Grid
  Widget _buildPackageGridShimmer() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 6, // Show 6 shimmer items
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemBuilder: (context, index) {
          return Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              width: 150,
              height: 250,
              color: Colors.white,
            ),
          );
        },
      ),
    );
  }

  // Normal Header
  Widget _buildHeader() {
    return Container(
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
    );
  }

  // Normal Profile Section
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
            image: DecorationImage(
              image: AssetImage('img/brandLogo.png'),
            ),
          ),
        ),
      ],
    );
  }

  // Normal Dropdown Section
  Widget _buildDropdownSection() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          AppLargeText(
            text: 'CRUISE DEALS',
            color: Color(0xFF009EE2),
            size: 24,
          ),
          const SizedBox(height: 20),
          Dropdownwidget(
            selectedValue: selectedCountry,
            items: countryList,
            hintText: "Select Country",
            onChanged: (value) {
              setState(() {
                selectedCountry = value;
                _fetchCruisePackages(
                    selectedCountry ?? '', selectedMonth ?? '');
              });
            },
          ),
          const SizedBox(height: 15),
          Dropdownwidget(
            selectedValue: selectedMonth,
            items: monthList,
            hintText: "Select Month",
            onChanged: (value) {
              setState(() {
                selectedMonth = value;
                _fetchCruisePackages(
                    selectedCountry ?? '', selectedMonth ?? '');
              });
            },
          ),
          const SizedBox(height: 30),
          AppLargeText(
            text: 'PACKAGES',
            color: Color(0xFF009EE2),
            size: 24,
          ),
          const Divider(
            color: Color(0xFF007A8C),
            thickness: 1,
          ),
        ],
      ),
    );
  }

  // Normal Package Grid
  Widget _buildPackageGrid(double screenWidth) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: cruisePackages.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  'No Compatible Packages Available',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            )
          : GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: cruisePackages.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                // childAspectRatio: 0.75,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemBuilder: (context, index) {
                final package = cruisePackages[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CruisePackageDetails(
                                packageId: package["packageid"],
                              )),
                    );
                  },
                  child: ResponsiveCard(
                    image: package['image'] ?? 'img/placeholder.png',
                    title: package['name'] ?? 'Package Name',
                    subtitle: package['country'] ?? 'Location',
                    price:
                        "${package['currency']} ${package['price'] ?? 'N/A'}",
                    screenWidth: screenWidth,
                  ),
                );
              },
            ),
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
    paint.color = Color(0xFFEDF2F4); // Light blue
    canvas.drawCircle(Offset(centerX, radius - 230), radius + 100, paint);

    // Draw the medium circle (medium blue)
    paint.color = Color(0xFF4AA9BC); // Medium blue
    canvas.drawCircle(Offset(centerX, radius - 400), radius + 200, paint);

    // Draw the largest circle (dark blue)
    paint.color = Color(0xFF007A8C); // Dark blue
    canvas.drawCircle(Offset(centerX, radius - 600), radius + 300, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}