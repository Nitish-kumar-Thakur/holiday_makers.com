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
  final List<Map<String, dynamic>> banner_list;
  const CurisesHome({Key? key, required this.banner_list}) : super(key: key);

  @override
  State<CurisesHome> createState() => _CurisesHomeState();
}

class _CurisesHomeState extends State<CurisesHome> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String? selectedCountry;
  String? selectedMonth;

  List<Map<String, String>> countryList = [];
  List<Map<String, String>> monthList = [];
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
    // _fetchHomePageData();
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

  // Future<void> _fetchHomePageData() async {
  //   try {
  //     final data = await APIHandler.HomePageData();

  //     setState(() {
  //       bannerList = List<Map<String, dynamic>>.from(
  //         data['data']['banner_list'].map((item) => {
  //           'img': item['img'],
  //           'mobile_img': item['mobile_img'],
  //           'link': item['link'],
  //         }),
  //       );
  //       isLoading = false;
  //     });
  //   } catch (e) {
  //     print('Error fetching homepage data: $e');
  //   }
  // }

  Future<void> _fetchCruisePackages(String country, String month) async {
    print(country);
    print(month);
    if(month == "All"){
      month = '';
    }
    if(country == "All"){
      country = '';
    }
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
                  // _buildDropdownSection(),
                  // _buildFilterSection(),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AppLargeText(
                          text: 'CRUISE DEALS',
                          color: Color(0xFF009EE2),
                          size: 24,
                        ),
                        IconButton(
                          onPressed: _openFilterBottomSheet,
                          icon: Icon(Icons.filter_list, color: Color(0xFF009EE2), size: 35),
                        ),
                      ],
                    ),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
                  //   child: AppLargeText(
                  //     text: 'PACKAGES',
                  //     color: Color(0xFF009EE2),
                  //     size: 24,
                  //   ),
                  // ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Divider(
                      color: Color(0xFF007A8C),
                      thickness: 1,
                    ),
                  ),
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

  // Widget _buildFilterSection() {
  //   return Padding(
  //     padding: const EdgeInsets.all(10),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       children: [
  //         AppLargeText(
  //           text: 'CRUISE DEALS',
  //           color: Color(0xFF009EE2),
  //           size: 24,
  //         ),
  //         IconButton(
  //           onPressed: _openFilterBottomSheet,
  //           icon: Icon(Icons.filter_list, color: Color(0xFF009EE2), size: 35),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  void _openFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: 0.6,
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setModalState) {
              return Column(
                children: [
                  SizedBox(height: 20),
                  // Fixed Drag Indicator
                  Center(
                    child: Container(
                      width: 50,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.grey[400],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  SizedBox(height: 10), // Spacing below the drag indicator

                  // Scrollable Content
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Country Section
                            Row(
                              children: [
                                Icon(Icons.location_on, color: Colors.black, size: 24),
                                SizedBox(width: 8),
                                Text("Select Country", style: TextStyle(fontSize: 20)),
                              ],
                            ),
                            SizedBox(height: 10),
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              padding: EdgeInsets.all(10),
                              child: Wrap(
                                spacing: 10,
                                runSpacing: 10,
                                alignment: WrapAlignment.center,
                                children: countryList.map((country) {
                                  return ElevatedButton(
                                    onPressed: () {
                                      setModalState(() {
                                        selectedCountry = country['id'];
                                      });
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: selectedCountry == country['id']
                                          ? Color(0xFF009EE2)
                                          : Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    child: Text(
                                      country['name'].toString(),
                                      style: TextStyle(
                                        color: selectedCountry == country['id']
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                            SizedBox(height: 20),

                            // Month Section
                            Row(
                              children: [
                                Icon(Icons.calendar_month, color: Colors.black, size: 24),
                                SizedBox(width: 8),
                                Text("Select Month", style: TextStyle(fontSize: 20)),
                              ],
                            ),
                            SizedBox(height: 10),
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              padding: EdgeInsets.all(10),
                              child: Wrap(
                                spacing: 10,
                                runSpacing: 10,
                                alignment: WrapAlignment.center,
                                children: monthList.map((month) {
                                  return ElevatedButton(
                                    onPressed: () {
                                      setModalState(() {
                                        selectedMonth = month['name'];
                                      });
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: selectedMonth == month['name']
                                          ? Color(0xFF009EE2)
                                          : Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    child: Text(
                                      month['name'].toString(),
                                      style: TextStyle(
                                        color: selectedMonth == month['name']
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                            // SizedBox(height: 80),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Apply Filters Button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _fetchCruisePackages(selectedCountry ?? '', selectedMonth ?? '');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF009EE2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text("Apply Filters", style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  // Normal Dropdown Section
  // Widget _buildDropdownSection() {
  //   return Padding(
  //     padding: const EdgeInsets.all(10),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         // const SizedBox(height: 10),
  //         // AppLargeText(
  //         //   text: 'CRUISE DEALS',
  //         //   color: Color(0xFF009EE2),
  //         //   size: 24,
  //         // ),
  //         _buildFilterSection(),
  //         const SizedBox(height: 20),
  //         Dropdownwidget(
  //           selectedValue: selectedCountry,
  //           items: countryList,
  //           hintText: "Select Country",
  //           onChanged: (value) {
  //             setState(() {
  //               selectedCountry = value;
  //               _fetchCruisePackages(
  //                   selectedCountry ?? '', selectedMonth ?? '');
  //             });
  //           },
  //         ),
  //         const SizedBox(height: 15),
  //         Dropdownwidget(
  //           selectedValue: selectedMonth,
  //           items: monthList,
  //           hintText: "Select Month",
  //           onChanged: (value) {
  //             setState(() {
  //               selectedMonth = value;
  //               _fetchCruisePackages(
  //                   selectedCountry ?? '', selectedMonth ?? '');
  //             });
  //           },
  //         ),
  //       ],
  //     ),
  //   );
  // }
  Widget _buildTopCurve() {
    return Padding(
      padding: const EdgeInsets.only(top: 50), // 20% of the screen height
      child: CustomPaint(
        size: Size(double.infinity, 20), // Height of the curved area
        painter: CirclePainter(radius: 200),
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
                  'Coming Soon...',
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