import 'package:flutter/material.dart';
import 'package:holdidaymakers/pages/Cruise/CurisesPackage.dart';
import 'package:holdidaymakers/widgets/responcive_card.dart';
import 'package:shimmer/shimmer.dart';
import 'package:holdidaymakers/pages/FullyIndependentTraveler/trip_details_page.dart';
import 'package:holdidaymakers/utils/api_handler.dart';
import 'package:holdidaymakers/widgets/appText.dart';
import 'package:holdidaymakers/widgets/drawerPage.dart';
import 'package:holdidaymakers/widgets/mainCarousel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Homepage2 extends StatefulWidget {
  final List<Map<String, dynamic>> packageList; // ✅ Accept package list

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
        banner_list = List<Map<String, dynamic>>.from(data['data']['banner_list']);
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
          ? _buildShimmerEffect()
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
      child: GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        children: widget.packageList.map((package) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TripDetailsPage()),
              );
            },
            child: ResponsiveCard(
              image: package['image'] ?? 'img/placeholder.png',
              title: package['name'] ?? 'Package Name',
              subtitle: package['country'] ?? 'Location',
              price: "${package['currency']} ${package['price'] ?? 'N/A'}",
              screenWidth: screenWidth,
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildShimmerEffect() {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              height: 120,
              color: Colors.white,
            ),
          ),
        );
      },
    );
  }
}



