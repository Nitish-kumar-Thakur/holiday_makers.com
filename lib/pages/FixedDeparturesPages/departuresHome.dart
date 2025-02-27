import 'package:flutter/material.dart';
import 'package:holdidaymakers/pages/Cruise/cruisePackagedetails.dart';
import 'package:holdidaymakers/pages/Cruise/cruise_deals_page.dart';
import 'package:holdidaymakers/pages/FixedDeparturesPages/departureDeals.dart';
import 'package:holdidaymakers/pages/FixedDeparturesPages/departurePackagedetails.dart';
import 'package:holdidaymakers/pages/FixedDeparturesPages/departuresPackages.dart';
import 'package:holdidaymakers/utils/api_handler.dart';
import 'package:holdidaymakers/widgets/appLargetext.dart';
import 'package:holdidaymakers/widgets/drawerPage.dart';
import 'package:holdidaymakers/widgets/dropdownWidget.dart';
import 'package:holdidaymakers/widgets/responcive_card.dart';
import 'package:shared_preferences/shared_preferences.dart'; // For date formatting
import 'package:shimmer/shimmer.dart'; // For shimmer effect

class DeparturesHome extends StatefulWidget {
  const DeparturesHome({super.key});

  @override
  State<DeparturesHome> createState() => _DeparturesHomeState();
}

class _DeparturesHomeState extends State<DeparturesHome> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String? selectedCountry; // Nullable for dropdown selection.
  String? selectedMonth; // Nullable for dropdown selection.

  List<Map<String, String>> countryList = []; // Country list from API.
  List<Map<String, String>> monthList = []; // Month list from API.

  String profileImg = '';
  bool isLoading = true; // Loading flag
  List<Map<String, dynamic>> fdPackages = [];

  @override
  void initState() {
    super.initState();
    _loadProfileDetails();
    _fetchCountryAndMonthLists(); // Fetch dropdown data.
    _fetchFDPackages('', ''); // Fetch cruise package data.
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
      final response = await APIHandler.fetchFDCountryMonthList("");
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

Future<void> _fetchFDPackages(String country, String month) async {
  try {
    final data = await APIHandler.getNewPackagesData("", country, month);
    setState(() {
      if (data['status'] == true) {
        fdPackages = (data['data']['package_list'] as List)
            .map<Map<String, dynamic>>((package) => {
                  'image': package['package_homepage_image'],
                  'name': package['package_name'],
                  'price': package['discounted_price'],
                  'currency': package['currency'],
                  'country': package['country_name'],
                  "id": package["package_type"],
                  "packageId": package["package_id"]
                })
            .toList();
      } else {
        fdPackages = []; // No packages found
      }
      isLoading = false;
    });
  } catch (error) {
    debugPrint('Error fetching fixed departure packages: $error');
    setState(() {
      isLoading = false;
      fdPackages = []; // No packages found in case of error
    });
  }
}


  void navigateToSeeAll() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const Departurespackages()));
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      drawer: Drawerpage(),
      body: isLoading
          ? SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeaderShimmer(),
                  _buildProfileSectionShimmer(),
                  _buildDropdownSectionShimmer(),
                  _buildPackageGridShimmer(screenWidth),
                ],
              ),
            )
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  _buildProfileSection(),
                  _buildDropdownSection(),
                  _buildPackageGrid(screenWidth),
                ],
              ),
            ),
    );
  }

  // Shimmer for Header
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

  // Profile Section with Shimmer
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

  // Shimmer for Dropdown Section
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

  // Shimmer for Package Grid
  Widget _buildPackageGridShimmer(double screenWidth) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 15),
    child: GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 6, // Set number of shimmer items
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
            width: screenWidth / 2 - 20,
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
          AppLargeText(
            text: 'Fixed Departure Deals',
            color: Colors.black,
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
                _fetchFDPackages(selectedCountry ?? '', selectedMonth ?? '');
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
                _fetchFDPackages(selectedCountry ?? '', selectedMonth ?? '');
              });
            },
          ),
          const SizedBox(height: 30),
          AppLargeText(
            text: 'Packages',
            color: Colors.black,
            size: 18,
          ),
          const Divider(
            color: Colors.black38,
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
    child: fdPackages.isEmpty
        ? Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                "No Compatible Packages Available",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          )
        : GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: fdPackages.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              // childAspectRatio: 0.75,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemBuilder: (context, index) {
              final package = fdPackages[index];
              return GestureDetector(
                onTap: () {
                print(package["id"].toString());
                if (package["id"] == "cruise") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CruisePackageDetails(packageId: package["packageId"],)),
                  );
                } else if (package["id"] == "") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DeparturePackageDetails(packageId: package["packageId"])),
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
}
