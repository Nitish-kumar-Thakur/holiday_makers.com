import 'package:flutter/material.dart';
import 'package:holdidaymakers/pages/Cruise/cruise_deals_page.dart';
import 'package:holdidaymakers/pages/FixedDeparturesPages/departureDeals.dart';
import 'package:holdidaymakers/widgets/responcive_card.dart';
import 'package:shimmer/shimmer.dart';
import 'package:holdidaymakers/utils/api_handler.dart';
import 'package:holdidaymakers/widgets/drawerPage.dart';
import 'package:holdidaymakers/widgets/mainCarousel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Homepage2 extends StatefulWidget {
  final List<Map<String, dynamic>> packageList;

  const Homepage2({Key? key, required this.packageList}) : super(key: key);

  @override
  State<Homepage2> createState() => _Homepage2State();
}

class _Homepage2State extends State<Homepage2> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String profileImg = '';
  bool isLoading = true;
  List<Map<String, dynamic>> banner_list = [];

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
        banner_list =
            List<Map<String, dynamic>>.from(data['data']['banner_list']);
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
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
          ? _buildLoadingSkeleton(screenWidth)
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  _buildProfileSection(),
                  Maincarousel(banner_list: banner_list),
                  
                  _buildPackageSection(screenWidth),
                ],
              ),
            ),
    );
  }

  Widget _buildHeader() {
    return Container(
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
    );
  }

  Widget _buildPackageSection(double screenWidth) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.packageList.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              // childAspectRatio: 0.75,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemBuilder: (context, index) {
              final package = widget.packageList[index];
              return GestureDetector(
                onTap: () {
                print(package["id"].toString());
                if (package["id"] == "cruise") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CruiseDealsPage(packageid: package["packageId"])),
                  );
                } else if (package["id"] == "") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DepartureDeals()),
                  );
                }
              },
                child: ResponsiveCard(
                  image: package['image'] ?? 'img/placeholder.png',
                  title: package['name'] ?? 'Package Name',
                  subtitle: package['country'] ?? 'Location',
                  price: "${package['currency']} ${package['price'] ?? 'N/A'}",
                  screenWidth: screenWidth,
                ),
              );
            },
          ),
    );
  }

  Widget _buildLoadingSkeleton(final double screenWidth) {
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
