import 'package:flutter/material.dart';
import 'package:HolidayMakers/pages/FixedDeparturesPages/hotelsAccommodation.dart';
import 'package:HolidayMakers/utils/api_handler.dart';
import 'package:HolidayMakers/widgets/responciveButton.dart';
import 'package:HolidayMakers/widgets/travelerDrawer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shimmer/shimmer.dart';

class DepartureDeals extends StatefulWidget {
  final String? packageId;
  const DepartureDeals({super.key, this.packageId});

  @override
  // ignore: library_private_types_in_public_api
  _DepartureDealsState createState() => _DepartureDealsState();
}

class _DepartureDealsState extends State<DepartureDeals> {
  Map<String, dynamic> packageData = {};
  List<dynamic> inclusionList = [];
  List<dynamic> activityList = [];
  List<dynamic> packageList = [];
  bool isLoading = true;
  int selectedOption = 0;
  String? selectedRoom = "1";
  String? selectedAdult = "2";
  String? selectedChild = "0";
  List<String>? childrenAge;
  Map<String, dynamic>? selectedPackageData;
  List<dynamic> totalRoomsdata = [
    {"adults": "2", "children": "0", "childrenAges": []}
  ];
  String showTourPage = "";
  int showFlightPage=0;
  int isMulticity = 0;

  @override
  void initState() {
    super.initState();
    _fetchPackageDetails();
    _fetchPackageCards();
  }

  Future<void> _fetchPackageDetails() async {
    try {
      final response = await APIHandler.getDepartureDeal(widget.packageId ?? "");
      setState(() {
        packageData = response;
        inclusionList = response["inclusion_list"]??[];
        activityList = response["activity_list"]??[];
        showTourPage = response['package_details']['tour_section_status'];
        showFlightPage = response["without_flight"];
        isLoading = false;
        isMulticity = response['package_multi_city'];
      });
    } catch (error) {
      print("Error fetching package details: $error");
      setState(() {
        isLoading = false; // Ensures loading state is updated even if an error occurs
      });
    }
  }

  Future<void> _fetchPackageCards() async {
    try {
      final response = await APIHandler.getFDCards(widget.packageId ?? "");
      setState(() {
        packageList = response['data'] ?? [];
        isLoading = false;
        selectedPackageData = packageList[0];
        selectedOption = 0;
      });
    } catch (e) {
      print("Error fetching package cards: $e");
    }
  }

  Widget buildInclusionCard(String iconClass, String label) {
    // Default icon in case no match is found
    IconData icon = FontAwesomeIcons.circleQuestion;

    // Map FontAwesome icon classes to Flutter icon
    if (iconClass == "fa fa-plane") {
      icon = FontAwesomeIcons.plane;
    } else if (iconClass == "fa fa-bed") {
      icon = FontAwesomeIcons.bed;
    } else if (iconClass == "fa fa-car") {
      icon = FontAwesomeIcons.car;
    } else if (iconClass == "fa fa-shield") {
      icon = FontAwesomeIcons.shieldHalved;
    } else if (iconClass == "fa fa-binoculars") {
      icon = FontAwesomeIcons.binoculars;
    } else if (iconClass == "far fa-daily-breakfast") {
      icon = FontAwesomeIcons.utensils;
    } else if (iconClass == "fa fa-user") {
      icon = FontAwesomeIcons.user;
    }

    return Container(
      width: 75,
      height: 70,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 30, color: Colors.red),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
                fontSize: MediaQuery.of(context).size.width * 0.02,
                color: Colors.black),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage('img/departureDealsBG.png'), fit: BoxFit.fill)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        // appBar: AppBar(
        //   backgroundColor: Colors.white,
        //   leading: IconButton(
        //     icon: Icon(Icons.arrow_back, color: Colors.black),
        //     onPressed: () {
        //       Navigator.pop(context);
        //     },
        //   ),
        //   title: Text(
        //     'Fixed Departures',
        //     style: TextStyle(
        //       fontSize: 24,
        //       fontWeight: FontWeight.bold,
        //       color: Colors.black,
        //     ),
        //   ),
        // ),
        body: SingleChildScrollView(
          child: isLoading
              ? Padding(
            padding: const EdgeInsets.all(16),
            child: _buildShimmerEffect(),
          )
              : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 60),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: CircleAvatar(
                      backgroundColor: Colors.grey.withOpacity(0.6), // Transparent grey background
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
                  const SizedBox(width: 10),
                  Text('Departure Details'.toUpperCase(),
                      style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.white))
                ],
              ),
              SizedBox(height: 30),
              // Package Selection Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Select Departure',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 10),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: packageList.asMap().entries.map((entry) {
                    int index = entry.key;
                    var package = entry.value;

                    return Column(
                      children: [
                        PackageCard(
                          title: package['package_name'] ?? '',
                          departureDate: "${package['dep_date']}",
                          arrivalDate: "${package['arrival_date']}",
                          duration: '${package['duration']}',
                          price:
                          '${package['currency']} ${package['price']}',
                          isSelected: selectedOption == index,
                          onSelect: () {
                            setState(() {
                              selectedOption = index;
                              selectedPackageData =
                                  package; // Store selected package data
                            });
                          },
                        ),
                        SizedBox(height: 10),
                      ],
                    );
                  }).toList(),
                ),
              ),
              SizedBox(height: 24),

              // Inclusion Section
              // Container(
              //   width: double.infinity,
              //   decoration: BoxDecoration(color: Colors.grey.shade200),
              //   padding: const EdgeInsets.all(10),
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       AppLargeText(
              //         text: 'INCLUSION',
              //         size: 25,
              //       ),
              //       const SizedBox(height: 10),
              //       Center(
              //         child: Wrap(
              //           spacing: 10, // Horizontal space between items
              //           runSpacing: 10, // Vertical space between rows
              //           alignment: WrapAlignment.spaceEvenly,
              //           children: inclusionList.map<Widget>((inclusion) {
              //             return buildInclusionCard(
              //                 inclusion['class'], inclusion['name']);
              //           }).toList(),
              //         ),
              //       ),
              //       const SizedBox(height: 10),
              //     ],
              //   ),
              // ),
              // SizedBox(height: 24),

              // Traveler Selection
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'SELECT TRAVELLERS',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Travelerdrawer(
                  onSelectionChanged: (Map<String, dynamic> selection) {
                    setState(() {
                      selectedRoom = selection['totalRooms'].toString();
                      selectedAdult = selection['totalAdults'].toString();
                      selectedChild = selection['totalChildren'].toString();
                      childrenAge = selection['childrenAges'];
                      totalRoomsdata = selection["totalData"];
                      // print("@@@@@@@@@@@@@@@@@@@@@@@@");
                      // print(selectedAdult);
                      // print("@@@@@@@@@@@@@@@@@@@@@@@@@@");
                    });
                  },
                ),
              ),
              SizedBox(height: 30),
            ],
          ),
        ),

        // Bottom Navigation Button
        bottomNavigationBar: isLoading
            ? null
            : Padding(
          padding: EdgeInsets.only(bottom: 15),
          child: IconButton(
            onPressed: () {
              if (selectedPackageData != null) {
                print("@@@@@@@@@@@@@@@@@@@@@@@@");
                print(totalRoomsdata);
                print("@@@@@@@@@@@@@@@@@@@@@@@@@@");
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HotelsAccommodation(
                      activityList: activityList,
                      packageData: selectedPackageData!,
                      totalRoomsdata: totalRoomsdata,
                      showTourPage: showTourPage,
                      showFlightPage: showFlightPage,
                      isMulticity: isMulticity,
                    ),
                  ),
                );
              }
            },
            icon: responciveButton(text: 'SELECT'),
          ),
        ),
      ),
    );
  }

  Widget _buildShimmerEffect() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 70,),
        Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            height: 30,
            width: 200,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 20),

        // Cruise Option Shimmer
        Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            height: 100,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        SizedBox(height: 24),

        // Inclusion Section Shimmer
        Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            height: 150,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        SizedBox(height: 24),

        // Travelers Selection Shimmer
        Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            height: 50,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        SizedBox(height: 30),

        // Button Shimmer
        Align(
          alignment: Alignment.center,
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              height: 50,
              width: 150,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class PackageCard extends StatefulWidget {
  final String title;
  final String departureDate;
  final String arrivalDate;
  final String duration;
  final String price;
  final bool isSelected;
  final VoidCallback onSelect;

  const PackageCard({
    super.key,
    required this.title,
    required this.departureDate,
    required this.arrivalDate,
    required this.duration,
    required this.price,
    required this.isSelected,
    required this.onSelect,
  });

  @override
  State<PackageCard> createState() => _PackageCardState();
}

class _PackageCardState extends State<PackageCard> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 25),
        decoration: BoxDecoration(
          color: Colors.grey[200]!,
          borderRadius: BorderRadius.circular(20),
          //  border: Border.all(
          //   color: widget.isSelected ? Color(0xFF0071BC) : Colors.grey.shade200,
          //   width: 2
          // ),
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: Text(
                        widget.title.toUpperCase(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Text(
                      widget.price,
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Travel Details",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 25),
                        Text(
                          '${widget.departureDate} - ${widget.arrivalDate}',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(50),
                            border: Border.all(width: 1, color: Colors.grey),
                          ),
                          child: Center(
                            child: Padding(
                              padding: EdgeInsets.all(5),
                              child: Text(
                                widget.duration,
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: MediaQuery.of(context).size.width * 0.03,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 5,),
                        SizedBox(
                          width: screenWidth * 0.3,
                          child: ElevatedButton(
                            onPressed: widget.onSelect,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: widget.isSelected
                                  ? Color(0xFF0071BC)
                                  : Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              side: BorderSide(color: Color(0xFF0071BC)),
                            ),
                            child: Text(
                              widget.isSelected ? 'SELECTED' : 'SELECT',
                              style: TextStyle(
                                color: widget.isSelected
                                    ? Colors.white
                                    : Color(0xFF0071BC),
                                fontSize: screenWidth * 0.030,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),

                      ],
                    )
                  ],
                )
              ],
            ),
            // 🔵 Circle in top-right
            // Positioned(
            //   top: 0,
            //   right: 0,
            //   child: Container(
            //     height: 10,
            //     width: 10,
            //     decoration: BoxDecoration(
            //       shape: BoxShape.circle,
            //       color: widget.isSelected ? Colors.blue : Colors.transparent,
            //       border: Border.all(color: Colors.blue),
            //     ),
            //   ),
            // ),
          ],
        )

    );
  }
}