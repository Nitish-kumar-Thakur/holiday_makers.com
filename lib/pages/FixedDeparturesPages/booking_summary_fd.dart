import 'package:flutter/material.dart';
import 'package:holdidaymakers/pages/FixedDeparturesPages/traveler_details_fd.dart';
import 'package:holdidaymakers/utils/api_handler.dart';
import 'package:holdidaymakers/widgets/responciveButton.dart';
import 'package:shimmer/shimmer.dart';

class BookingSummaryFD extends StatefulWidget {
  final Map<String, dynamic> packageDetails;
  final Map<String, dynamic> selectedHotel;
  final List<Map<String, dynamic>> flightDetails;
  final List<dynamic> totalRoomsdata;
  final String searchId;
  final String destination;
  final List<Map<String, dynamic>> activityList;

  const BookingSummaryFD(
      {super.key,
      required this.packageDetails,
      required this.selectedHotel,
      required this.flightDetails,
      required this.totalRoomsdata,
      required this.searchId,
      required this.activityList,
      required this.destination});

  @override
  State<BookingSummaryFD> createState() => _BookingSummaryFDState();
}

class _BookingSummaryFDState extends State<BookingSummaryFD> {
  Map<String, dynamic> BSData = {};
  List<Map<String, String>> packageDetails = [];
  List<Map<String, String>> flightDetails = [];
  List<Map<String, String>> hotelDetails = [];
  List<Map<String, String>> transferDetails = [];
  List<Map<String, String>> priceDetails = [];
  List<Map<String, String>> insuranceDetails = [];
  List<Map<String, dynamic>> tourList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    // Future.delayed(const Duration(milliseconds: 800), () {
    //   if (mounted) {
    //     setState(() {
    //       isLoading = false;
    //     });
    //   }
    // });
    // print('&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&');
    // print(widget.packageDetails);
    // print(widget.selectedHotel);
    // print(widget.flightDetails);
    // print(widget.totalRoomsdata);
    // print(widget.searchId);
    // print(widget.activityList);
    // print('&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&');
    _fetchFDBSDetails();
  }

  Future<void> _fetchFDBSDetails() async {
    // print(widget.searchId);
    Map<dynamic, dynamic> apiBody = {
      "search_id": widget.searchId,
      "activity_list": [
        {"destination": widget.destination, "activity": widget.activityList}
      ]
    };
    try {
      final response =
          await APIHandler.getFDBSDetails(apiBody); //widget.searchId

      // Ensure response contains expected keys and types
      if (response.containsKey('data') &&
          response['data'] is Map<String, dynamic>) {
        setState(() {
          BSData = response['data'];
          _PackageData();
        });

        // print('Fetched Data: $BSData');
      } else {
        throw Exception("Invalid data structure: ${response.toString()}");
      }
    } catch (e) {
      print("Error fetching package cards: $e");
    }
  }

  void _PackageData() {
    setState(() {
      packageDetails = [
        {
          'title': 'PACKAGE',
          'value':
              BSData['package_details']['package_name']?.toString() ?? "N/A"
        },
        {
          'title': 'DURATION',
          'value': BSData['package_details']['duration']?.toString() ?? "N/A"
        },
        {
          'title': 'DEPARTURE DATE',
          'value': BSData['package_details']['dep_date']?.toString() ?? "N/A"
        },
      ];

      flightDetails = [
        {
          // 'flight': 'Emirates EK 567',
          // 'type': 'Departure',
          // 'icon': 'takeoff',
          // 'airport': 'Bangalore (BLR), India',
          // 'date': '11-Dec-2024',
          // 'terminal': 'T1',
          'flight':
              BSData['flight_details'][0]['airline_name']?.toString() ?? "N/A",
          'type':
              BSData['flight_details'][0]['flight_type']?.toString() ?? "N/A",
          'icon': 'takeoff',
          'airport':
              BSData['flight_details'][0]['from_city']?.toString() ?? "N/A",
          'date':
              BSData['flight_details'][0]['travel_date']?.toString() ?? "N/A",
          'terminal':
              BSData['flight_details'][0]['depart_terminal']?.toString() ??
                  "N/A"
        },
        {
          'flight':
              BSData['flight_details'][1]['airline_name']?.toString() ?? "N/A",
          'type':
              BSData['flight_details'][1]['flight_type']?.toString() ?? "N/A",
          'icon': 'landing',
          'airport':
              BSData['flight_details'][1]['from_city']?.toString() ?? "N/A",
          'date':
              BSData['flight_details'][1]['travel_date']?.toString() ?? "N/A",
          'terminal':
              BSData['flight_details'][1]['depart_terminal']?.toString() ??
                  "N/A"
        },
      ];

      hotelDetails = [
        {
          'title': 'HOTEL NAME',
          'value': BSData['hotel_details'][0]['hotel']?.toString() ?? "N/A"
        },
        {
          'title': 'ROOM TYPE',
          'value':
              BSData['hotel_details'][0]['room_category']?.toString() ?? "N/A"
        },
        // {'title': 'CHECK IN DATE', 'value': BSData['hotel_details'][0]['hotel']?.toString() ?? "N/A"},
        // {'title': 'CHECK OUT DATE', 'value': BSData['hotel_details'][0]['hotel']?.toString() ?? "N/A"},
        {
          'title': 'DURATION',
          'value': BSData['hotel_details'][0]['duration']?.toString() ?? "N/A"
        },
        // {'title': 'NO. OF NIGHTS', 'value': BSData['hotel_details'][0]['hotel']?.toString() ?? "N/A"},
        // {'title': 'NO. OF ROOMS', 'value': BSData['hotel_details'][0]['hotel']?.toString() ?? "N/A"},
        {
          'title': 'MEAL PLAN',
          'value': BSData['hotel_details'][0]['meal_plan']?.toString() ?? "N/A"
        },
        {
          'title': 'CITY',
          'value': BSData['hotel_details'][0]['city']?.toString() ?? "N/A"
        },
        {
          'title': 'OCCUPANCY',
          'value': BSData['hotel_details'][0]['occupacy']?.toString() ?? "N/A"
        },
      ];

      transferDetails = [
        {
          'title': 'ARRIVAL TRANSFER',
          'value': BSData['transfer_details']['arrival_transfer']?.toString() ??
              "N/A"
        },
        {
          'title': 'RETURN TRANSFER',
          'value':
              BSData['transfer_details']['return_transfer']?.toString() ?? "N/A"
        },
      ];

      insuranceDetails = [
        {'title': 'Travel Insurance in accordance to standards', 'value': ''},
      ];

      // final List<Map<String, String>> priceDetails = [
      //   {'title': 'TOTAL (1 ADULT)', 'value': 'AED 1,310'},
      //   {'title': 'TOTAL', 'value': BSData['package_price']['total']?.toString() ?? "N/A"},
      // ];

      priceDetails = [
        {
          "title": "Prices",
          "value": [
            if ((BSData['package_price']['adult_count'] ?? 0) > 0)
              "${BSData['package_price']['adult_count']} Adult(s) ${BSData['package_price']['currency']} ${BSData['package_price']['adult_price']}",
            if ((BSData['package_price']['cwb_count'] ?? 0) > 0)
              "${BSData['package_price']['cwb_count']} Child(ren) ${BSData['package_price']['currency']} ${BSData['package_price']['cwb_price']}",
            if ((BSData['package_price']['infant_count'] ?? 0) > 0)
              "${BSData['package_price']['infant_count']} Infant(s) ${BSData['package_price']['currency']}  ${BSData['package_price']['infant_price']}",
          ]
              .where((element) => element.isNotEmpty)
              .join("\n"), // Join all valid values with line breaks
        },
        {
          "title": "Total",
          "value":
              "${BSData['package_price']['currency']} ${BSData['package_price']['total'].toString()}"
        },
      ];
      tourList = (BSData["activities_list"] as List).map((activity) {
        // Extract duration in hours from the "duration" string
        RegExp regExp = RegExp(r'(\d+) Hours'); // Regex to extract hours
        var match = regExp.firstMatch(activity["duration"] ?? "");

        // Default to 0 if no match is found
        int hours =
            match != null ? int.tryParse(match.group(1) ?? "0") ?? 0 : 0;

        // Return the mapped result
        return {
          "day": activity["day"] ?? "",
          "title": activity["service"] ?? "",
          "duration":
              "$hours Hours", // You can adjust this if you want a different format
        };
      }).toList();

      // [
      //   {"day": "1", "title": "Adventure Trip, City Tour and Resort Visit", "duration": "1"},
      //   {"day": "2", "title": "", "duration": ""},
      //   {"day": "3", "title": "", "duration": ""}
      // ];
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double fontSize = screenWidth * 0.035;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Booking Summary',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: isLoading
            ? _buildShimmerEffect()
            : Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSection('PACKAGE DETAILS', packageDetails, fontSize),
                    _buildFlightDetailsSection(
                        'FLIGHT DETAILS', flightDetails, fontSize),
                    tourList.isEmpty? SizedBox():_buildtourDetailsSection(
                        "TOUR DETAILS", tourList, fontSize),
                    _buildSection('HOTEL DETAILS', hotelDetails, fontSize),
                    _buildSection(
                        'TRANSFER DETAILS', transferDetails, fontSize),
                    _buildSection(
                        'TRAVEL INSURANCE DETAILS', insuranceDetails, fontSize),
                    _buildPriceSection('PRICE DETAILS', priceDetails, fontSize),
                  ],
                ),
              ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(left: 16.0,right: 16.0,bottom: 16.0,top: 7),
        child: SizedBox(
          width: double.infinity,
          child: IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TravelersDetailsFD(
                        flightDetails: widget.flightDetails,
                        selectedHotel: widget.selectedHotel,
                        packageDetails: widget.packageDetails,
                        totalRoomsdata: widget.totalRoomsdata,
                        searchId: widget.searchId,
                        activityList: widget.activityList,
                        destination: widget.destination),
                  ));
            },
            icon: responciveButton(text: 'SELECT'),
          ),
        ),
      ),
    );
  }

  Widget _buildSection(
      String title, List<Map<String, String>> details, double fontSize) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: fontSize * 1.3,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 10),
        Column(
          children: List.generate(
            (details.length / 2).ceil(), // Divide into rows
            (index) {
              bool isLastOdd =
                  details.length % 2 != 0 && index == details.length ~/ 2;
              return Column(
                children: [
                  IntrinsicHeight(
                    // This ensures both boxes in the row will have equal height
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildPriceDetailBox(
                            details[index * 2]['title']!,
                            details[index * 2]['value']!,
                            fontSize,
                          ),
                        ),
                        if (!isLastOdd) ...[
                          const SizedBox(width: 10),
                          Expanded(
                            child: _buildPriceDetailBox(
                              details[index * 2 + 1]['title']!,
                              details[index * 2 + 1]['value']!,
                              fontSize,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 10), // Space after each row
                ],
              );
            },
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildFlightDetailsSection(
      String title, List<Map<String, String>> details, double fontSize) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: fontSize * 1.3,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 10),
        Column(
          children: details.map((flight) {
            return _buildFlightCard(flight, fontSize);
          }).toList(),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildFlightCard(Map<String, String> flight, double fontSize) {
    return Container(
      padding: EdgeInsets.all(fontSize * 0.7),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                flight['type'] == 'Departure'
                    ? Icons.flight_takeoff
                    : Icons.flight_land,
                color: Colors.black54,
              ),
              const SizedBox(width: 5),
              Text(
                flight['type']!,
                style: TextStyle(
                    fontSize: fontSize * 1.2, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 5),

          // Flight Name
          Text(
            flight['flight']!,
            style: TextStyle(
                fontSize: fontSize * 1.1,
                fontWeight: FontWeight.bold,
                color: Colors.blue),
          ),
          const SizedBox(height: 5),

          // Airport Name
          Row(
            children: [
              const Icon(Icons.location_on, color: Colors.black54),
              const SizedBox(width: 5),
              Text(flight['airport']!, style: TextStyle(fontSize: fontSize)),
            ],
          ),
          const SizedBox(height: 5),

          // Date
          Row(
            children: [
              const Icon(Icons.date_range, color: Colors.black54),
              const SizedBox(width: 5),
              Text("Date: ${flight['date']}",
                  style: TextStyle(fontSize: fontSize)),
            ],
          ),
          const SizedBox(height: 5),

          // Terminal
          Row(
            children: [
              const Icon(Icons.directions_transit, color: Colors.black54),
              const SizedBox(width: 5),
              Text("Terminal: ${flight['terminal']}",
                  style: TextStyle(fontSize: fontSize)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPriceSection(
      String title, List<Map<String, dynamic>> details, double fontSize) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: fontSize * 1.3,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 10),
        Column(
          children: List.generate(
            (details.length / 2).ceil(), // Divide into rows
            (index) {
              bool isLastOdd =
                  details.length % 2 != 0 && index == details.length ~/ 2;
              return Column(
                children: [
                  IntrinsicHeight(
                    // This ensures both boxes in the row will have equal height
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildPriceDetailBox(
                            details[index * 2]['title']!,
                            details[index * 2]['value']!,
                            fontSize,
                          ),
                        ),
                        if (!isLastOdd) ...[
                          const SizedBox(width: 10),
                          Expanded(
                            child: _buildPriceDetailBox(
                              details[index * 2 + 1]['title']!,
                              details[index * 2 + 1]['value']!,
                              fontSize,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 10), // Space after each row
                ],
              );
            },
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildPriceDetailBox(String title, String value, double fontSize) {
    return Container(
      padding: EdgeInsets.all(fontSize * 0.7),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: fontSize * 1.2,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: fontSize * 0.3),
          Text(
            value,
            style: TextStyle(
              fontSize: fontSize * 0.95,
              fontWeight: FontWeight.normal,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildtourDetailsSection(
      String title, List<Map<String, dynamic>> tour, double fontSize) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: fontSize * 1.3,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 10),
        Column(
          children: tour.map((tour) {
            return _buildTourCard(tour, fontSize);
          }).toList(),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildTourCard(Map<dynamic, dynamic> tour, double fontSize) {
    return Container(
      padding: EdgeInsets.all(fontSize * 0.7),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width:
                MediaQuery.of(context).size.width * 0.4, // 40% of screen width
            child: Text(
              "Day ${tour['day'] ?? 'N/A'}: ${tour['title'] ?? 'N/A'}",
              style: TextStyle(
                fontSize: fontSize,
              ),
            ),
          ),
          Text(
            "Duration ${tour['duration'] ?? "N/A"}",
            style: TextStyle(
              fontSize: fontSize,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerEffect() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title shimmer
                Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    height: 20,
                    width: 150,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),

                // Multiple shimmer rows for different sections
                _buildShimmerRow(),
                const SizedBox(height: 20),
                Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    height: 20,
                    width: 150,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                const SizedBox(height: 20),
                _buildShimmerRow(),
                const SizedBox(height: 20),

                Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    height: 20,
                    width: 150,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10), const SizedBox(height: 20),
                _buildShimmerRow(),
                const SizedBox(height: 20),
                Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    height: 20,
                    width: 150,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                const SizedBox(height: 20),
                _buildShimmerRow(),
                const SizedBox(height: 20),
                Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    height: 20,
                    width: 150,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                const SizedBox(height: 20),
                _buildShimmerRow(),
                const SizedBox(height: 20),
                Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    height: 20,
                    width: 150,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                const SizedBox(height: 20),
                _buildShimmerRow(),
              ],
            ),
          ),
        ),
      ],
    );
  }

// Function to build shimmer rows
  Widget _buildShimmerRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildShimmerBox(),
        _buildShimmerBox(),
      ],
    );
  }

// Function to create shimmer box for text placeholders
  Widget _buildShimmerBox() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: MediaQuery.of(context).size.width * (150 / 375),
        height: MediaQuery.of(context).size.width * (100 / 812),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
