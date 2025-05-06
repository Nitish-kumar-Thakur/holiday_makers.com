import 'package:HolidayMakers/pages/Cruise/cruisePackagedetails.dart';
import 'package:HolidayMakers/pages/FixedDeparturesPages/departurePackagedetails.dart';
import 'package:flutter/material.dart';
import 'package:HolidayMakers/widgets/responcive_card.dart';
import 'package:shimmer/shimmer.dart';
import 'package:HolidayMakers/utils/api_handler.dart';
import 'package:HolidayMakers/widgets/drawerPage.dart';
import 'package:HolidayMakers/widgets/mainCarousel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePageCategory extends StatefulWidget {
  final List<Map<String, dynamic>> banner_list;
  final String categoryId;

  const HomePageCategory({Key? key, required this.categoryId, required this.banner_list})
      : super(key: key);

  @override
  State<HomePageCategory> createState() => _HomePageCategoryState();
}

class _HomePageCategoryState extends State<HomePageCategory> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String profileImg = '';
  bool isLoading = true;
  // List<Map<String, dynamic>> banner_list = widget.banner_list;
  List<dynamic> packageList = [];
  String title = "";
  @override
  void initState() {
    super.initState();
    _loadProfileDetails();
    // _fetchHomePageData();
    _fetchPackageDetails();
  }

  Future<void> _loadProfileDetails() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      profileImg = prefs.getString("profileImg") ?? "";
    });
  }

  // Future<void> _fetchHomePageData() async {
  //   try {
  //     final data = await APIHandler.HomePageData();
  //     setState(() {
  //       banner_list =
  //           List<Map<String, dynamic>>.from(data['data']['banner_list']);
  //     });
  //     _fetchPackageDetails();
  //   } catch (e) {
  //     setState(() {
  //       isLoading = false;
  //     });
  //     print('Error: $e');
  //   }
  // }

  Future<void> _fetchPackageDetails() async {
    Map<String, dynamic> body = {"category_id": widget.categoryId};
    try {
      final data = await APIHandler.categoryIdWisePackageList(body);
      setState(() {
        title = data['data'][0]['category_name'];
        packageList = data['data'][0]['package_list'];
        isLoading = false;
      });
    } catch (error) {
      print("Error fetching category ID wise packages: $error");
      setState(() {
        isLoading = false;
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
            ? _buildLoadingSkeleton(screenWidth)
            : Column(
                children: [
                  _buildTopCurve(),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: CircleAvatar(
                          backgroundColor: Colors.grey
                              .withOpacity(0.6), // Transparent grey background
                          child: Text(
                            '<', // Use "<" symbol
                            style: TextStyle(
                              color: Colors.white, // White text color
                              fontSize: 24, // Adjust font size as needed
                              fontWeight: FontWeight
                                  .bold, // Make the "<" bold if needed
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Maincarousel(banner_list: widget.banner_list),
                  SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: _buildPackageSection(screenWidth),
                    ),
                  )
                ],
              ));
  }

  Widget _buildTopCurve() {
    return Padding(
      padding: const EdgeInsets.only(top: 50), // 20% of the screen height
      child: CustomPaint(
        size: Size(double.infinity, 20), // Height of the curved area
        painter: CirclePainter(radius: 200),
      ),
    );
  }

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
        // Container(
        //   height: 40,
        //   width: 200,
        //   margin: EdgeInsets.all(15),
        //   decoration: BoxDecoration(
        //     image: DecorationImage(
        //       image: AssetImage('img/brandLogo.png'),
        //     ),
        //   ),
        // ),
      ],
    );
  }

  Widget _buildPackageSection(double screenWidth) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Align text to the left
        children: [
          // Title above the section
          Text(
            title.toUpperCase(), // Title text
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.blueAccent,
            ),
          ),

          // Divider line
          Divider(
            color: Colors.grey, // Divider color
            thickness: 1, // Divider thickness
          ),

          // GridView.builder for packages
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: packageList.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemBuilder: (context, index) {
              final package = packageList[index];
              return GestureDetector(
                onTap: () {
                  if (package["package_type"] == "cruise") {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CruisePackageDetails(
                            packageId: package["package_id"]),
                      ),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DeparturePackageDetails(
                              packageId: package["package_id"])),
                    );
                  }
                },
                child: ResponsiveCard(
                  image: package['package_homepage_image'] ??
                      'img/placeholder.png',
                  title: package['package_name'] ?? 'Package Name',
                  subtitle: package['country_name'] ?? 'Location',
                  price:
                      "${package['currency']} ${package['discounted_price'] ?? 'N/A'}",
                  screenWidth: screenWidth,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingSkeleton(final double screenWidth) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 40,
          ), // Header Placeholder
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
            _buildShimmerSection(screenWidth), // Sample Sections
        ],
      ),
    );
  }

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

  Widget _buildShimmerSection(double screenWidth) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: GridView.builder(
        itemCount: 4, // Number of skeleton items to display
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.8, // Adjust based on your card aspect ratio
        ),
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Card(
              color: Colors.white,
              child: Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 120,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 4),
                    Padding(
                      padding: EdgeInsets.only(left: screenWidth * 0.01),
                      child: Container(
                        height: 16,
                        width: screenWidth * 0.5,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 4),
                    Padding(
                      padding: EdgeInsets.only(left: screenWidth * 0.01),
                      child: Container(
                        height: 16,
                        width: screenWidth * 0.3,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 4),
                    Padding(
                      padding: EdgeInsets.only(left: screenWidth * 0.01),
                      child: Container(
                        height: 16,
                        width: screenWidth * 0.2,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
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
