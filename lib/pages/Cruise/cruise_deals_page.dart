import 'package:HolidayMakers/pages/Cruise/booking_summary.dart';
import 'package:HolidayMakers/pages/Cruise/pax_details.dart';
import 'package:HolidayMakers/widgets/dropdownwidget.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:HolidayMakers/utils/api_handler.dart';
import 'package:HolidayMakers/widgets/responciveButton.dart';
import 'package:shimmer/shimmer.dart';

class CruiseDealsPage extends StatefulWidget {
  final String packageid;
  const CruiseDealsPage({super.key, required this.packageid});

  @override
  // ignore: library_private_types_in_public_api
  _CruiseDealsPageState createState() => _CruiseDealsPageState();
}

class _CruiseDealsPageState extends State<CruiseDealsPage> {
  bool isLoading = true;
  Map<String, dynamic> packageData = {};
  Map<String, dynamic> cruiseCards = {};
  String cruiseId = "";
  int selectedOption = 0;
  Map<String, dynamic>? selectedCruiseData;
  String depDate = "";

  List<Map<String, String>> cruiseCabins = [];
  Map<String, String>? selectedCabin;
  String? selectedRoom = "1";
  String? totalPaxCount = "2";
  List<String>? paxAges = ["21", "21"];

  List<dynamic> totalRoomsdata = [
    {
      "paxCount": 2,
      "paxAges": [21, 21]
    }
  ];

  String? cabinError;

  @override
  void initState() {
    super.initState();
    _fetchPackageDetails();
    _fetchCruiseCards();
  }

  Future<void> _fetchPackageDetails() async {
    try {
      final response = await APIHandler.getCruiseDeal(widget.packageid);
      setState(() {
        packageData = response;
      });
      depDate = packageData['cruise_details']['dep_date'];
      if (packageData['cruise_details']?['cruise_id'] != null) {
        cruiseId = packageData['cruise_details']['cruise_id'];
        await _fetchCruiseCards();
      }
      _fetchCabins();
    } catch (error) {
      print("Error fetching package details: $error");
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _fetchCruiseCards() async {
    try {
      final response = await APIHandler.getCruiseCards(widget.packageid);
      setState(() {
        cruiseCards = response;
        if (cruiseCards['data'] != null && cruiseCards['data'].isNotEmpty) {
          selectedCruiseData = cruiseCards['data'][0];
        }
        isLoading = false;
      });
    } catch (error) {
      print("Error fetching cruise cards: $error");
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _fetchCabins() async {
    try {
      final response = await APIHandler.getCruiseCabin(
        depDate: depDate,
        cruiseId: cruiseId,
      );

      if (response.isEmpty || response['data'] == null) {
        throw Exception("No data found");
      }

      final List<dynamic> cabinList = response['data'];
      if (cabinList.isEmpty) {
        throw Exception("No cruise cabins available");
      }

      if (!mounted) return;

      setState(() {
        cruiseCabins = cabinList.map((item) {
          return {
            'origin': (item['origin'] ?? "N/A").toString(),
            'cabin_type': (item['cabin_type'] ?? "Unknown").toString(),
            'is_selected': (item['is_selected'] ?? "0").toString(),
          };
        }).toList();

        selectedCabin = null; // No default selection
      });
      print(cruiseCabins);
    } catch (e) {
      if (!mounted) return;

      setState(() {
        cruiseCabins = [];
        selectedCabin = null;
      });

      print("Error fetching cruise cabins: $e");
    }
  }

  void _validateAndProceed() {
    

    if (selectedCabin != null) {
      
      // print("@@@@@@@@@@@@@NitisH@@@@@@@@@@@@@@@@@@@@@");
      // print(totalRoomsdata);
      // print("@@@@@@@@@@@@@NitisH@@@@@@@@@@@@@@@@@@@@@");
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BookingSummaryPage(
            selectedCabin: selectedCabin,
            selectedCruiseData: selectedCruiseData,
            totalRoomdata: totalRoomsdata,
          ),
        ),
      );
    }
    else{
      Fluttertoast.showToast(msg: "Please select a cabin type");
    }
  }

  // Widget buildInclusionCard(String iconClass, String label) {
  //   // Default icon in case no match is found
  //   IconData icon = FontAwesomeIcons.circleQuestion;
  //
  //   // Map FontAwesome icon classes to Flutter icon
  //   if (iconClass == "fa fa-plane") {
  //     icon = FontAwesomeIcons.plane;
  //   } else if (iconClass.contains("fa-bed")) {
  //     icon = FontAwesomeIcons.bed;
  //   } else if (iconClass.contains("fa-theater")) {
  //     icon = FontAwesomeIcons.film;
  //   } else if (iconClass.contains("fa-kids")) {
  //     icon = FontAwesomeIcons.children;
  //   } else if (iconClass.contains("fa-pool")) {
  //     icon = FontAwesomeIcons.personSwimming;
  //   } else if (iconClass.contains("fa-meals")) {
  //     icon = FontAwesomeIcons.utensils;
  //   } else if (iconClass.contains("fa-shows")) {
  //     icon = FontAwesomeIcons.masksTheater;
  //   }
  //
  //   return Container(
  //     width: 75,
  //     height: 70,
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //       borderRadius: BorderRadius.circular(10),
  //     ),
  //     child: Column(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: [
  //         Icon(icon, size: 30, color: Colors.blue),
  //         const SizedBox(height: 2),
  //         Text(
  //           label,
  //           textAlign: TextAlign.center,
  //           style: TextStyle(
  //               fontSize: MediaQuery.of(context).size.width * 0.02,
  //               color: Colors.black),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    // final inclusionList = (packageData['inclusion_list'] as List<dynamic>?) ?? [];

    return Container(
      decoration: BoxDecoration(
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
        // ),
        body: SingleChildScrollView(
          child: isLoading
              ? Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: _buildShimmerEffect(),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 70),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: CircleAvatar(
                            backgroundColor: Colors.grey.withOpacity(
                                0.6), // Transparent grey background
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
                        Text('DEP DATE DETAILS',
                            style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: Colors.white))
                      ],
                    ),
                    SizedBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: [
                          ...(cruiseCards['data'] as List<dynamic>? ?? [])
                              .asMap()
                              .entries
                              .map((entry) {
                            int index = entry.key;
                            var cruise = entry.value;

                            return Column(
                              children: [
                                CruiseOption(
                                  title: cruise['cruise_name'] ?? '',
                                  checkIn: "${cruise['dep_date'] ?? '00'}",
                                  checkOut: "${cruise['arrival_date'] ?? '00'}",
                                  duration: '${cruise['duration']}',
                                  price:
                                      '${cruise['currency']} ${cruise['price']}',
                                  isSelected: selectedOption == index,
                                  onSelect: () {
                                    setState(() {
                                      selectedOption = index;
                                      selectedCruiseData = cruise;
                                    });
                                  },
                                ),
                                SizedBox(height: 15),
                              ],
                            );
                          }).toList(),
                        ],
                      ),
                    ),
                    SizedBox(height: 12),
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
                    //           spacing: 10,
                    //           runSpacing: 10,
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
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // const SizedBox(height: 10),
                          Text('Select Travellers',
                              style: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                          PaxDetails(
                            onSelectionChanged:
                                (Map<String, dynamic> selection) {
                              setState(() {
                                selectedRoom =
                                    selection['totalRooms']?.toString() ?? "1";
                                totalPaxCount =
                                    selection['totalPaxCount']?.toString() ??
                                        "2";
                                paxAges = selection['paxAges'] ?? ["21", "21"];

                                totalRoomsdata = selection["totalData"] ??
                                    [
                                      {
                                        "paxCount": 2,
                                        "paxAges": [21, 21]
                                      }
                                    ];
                              });
                            },
                          ),
                          const SizedBox(height: 20),

                          Dropdownwidget(  txtcolor: Colors.white,
                            selectedValue: selectedCabin?['cabin_type'],
                            items: cruiseCabins
                                .map((item) => {
                                      'id': item['cabin_type']!,
                                      'name': item['cabin_type']!,
                                    })
                                .toList(),
                            hintText: 'Select Cabin Type',
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedCabin = cruiseCabins.firstWhere(
                                  (item) => item['cabin_type'] == newValue,
                                  orElse: () => {
                                    'origin': "N/A",
                                    'cabin_type': "Unknown",
                                    'is_selected': "0"
                                  },
                                );
                                cabinError = null; // Clear error
                              });
                            },
                          ),
                          if (cabinError != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                cabinError!,
                                style: const TextStyle(
                                    color: Colors.red, fontSize: 14),
                              ),
                            ),
                        ],
                      ),
                    )
                  ],
                ),
        ),

        // Placing the button at the bottom using bottomNavigationBar
        bottomNavigationBar: isLoading
            ? null
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  width: double.infinity,
                  child: IconButton(
                    onPressed: _validateAndProceed,
                    icon: responciveButton(text: 'SELECT'),
                  ),
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

class CruiseOption extends StatelessWidget {
  final String title;
  final String checkIn;
  final String checkOut;
  final String duration;
  final String price;
  final bool isSelected;
  final VoidCallback onSelect;

  CruiseOption({
    required this.title,
    required this.checkIn,
    required this.checkOut,
    required this.duration,
    required this.price,
    required this.isSelected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Color(0XFFF6F6F6),
          borderRadius: BorderRadius.circular(8),
          // border: Border.all(
          //     color: isSelected ? Color(0XFF0071BC) : Colors.grey[300]!),
        ),
        child: Column(
          children: [
            // First Row: Title (Package Name) on the left, Price and Selection Dot on the right
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Left side: Title (Package Name)
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                // Right side: Price and Selection Dot
                Row(
                  children: [
                    Text(
                      price,
                      style: TextStyle(
                        color: Color(0xFF0071BC),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    // SizedBox(width: 8),
                    // Container(
                    //   height: 10,
                    //   width: 10,
                    //   decoration: BoxDecoration(
                    //     shape: BoxShape.circle,
                    //     color:
                    //         isSelected ? Color(0xFF0071BC) : Colors.transparent,
                    //     border: Border.all(color: Color(0xFF0071BC)),
                    //   ),
                    // ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 8),

            // Second Row: Travel Date on the left and Duration on the right
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Left side: Travel Date and dates below it
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Travel Date',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 22),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${checkIn} - ${checkOut}',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                        // Text(
                        //   checkOut,
                        //   style: TextStyle(
                        //     color: Colors.grey[600],
                        //     fontSize: 14,
                        //   ),
                        // ),
                      ],
                    ),
                  ],
                ),
                // Right side: Duration
                Column(
                  children: [
                    Container(
                  decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(width: 1, color: Colors.grey)),
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(5),
                      child: Text(
                        duration,
                        style: TextStyle(
                          color: Colors.grey.shade700,
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
                            onPressed: onSelect,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isSelected
                                  ? Color(0xFF0071BC)
                                  : Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              side: BorderSide(color: Color(0xFF0071BC)),
                            ),
                            child: Text(
                              isSelected ? 'SELECTED' : 'SELECT',
                              style: TextStyle(
                                color: isSelected
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
            ),
          ],
        ),
      );
  }
}
