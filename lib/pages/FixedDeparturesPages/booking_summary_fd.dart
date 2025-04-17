import 'package:HolidayMakers/pages/login&signup/Test.dart';
import 'package:flutter/material.dart';
import 'package:HolidayMakers/pages/FixedDeparturesPages/traveler_details_fd.dart';
import 'package:HolidayMakers/utils/api_handler.dart';
import 'package:HolidayMakers/widgets/responciveButton.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  bool isLoggedIn = false;

  TextEditingController _voucherController =
  TextEditingController(); // Voucher input
  Map<String, dynamic> voucherAPIResponse = {};
  String? finalPrice;
  String voucherMessage = "";
  bool isCodeApplied = false;
  String? voucherCode;
  String enteredCode = "";
  String? discountPrice;

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
    print('&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&');
    print(widget.packageDetails);
    print(widget.flightDetails);
    print('&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&');
  }

  Future<void> _loadLogedinDetails() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isLoggedIn = prefs.getBool("isLoggedIn") ?? false;
    });
  }

  Future<void> _fetchFDBSDetails() async {
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
          finalPrice = response['data']['package_price']['total'].toString();
          _PackageData();
        });
        print('fetched data: $BSData');
      } else {
        throw Exception("Invalid data structure: ${response.toString()}");
      }
    } catch (e) {
      print("Error fetching package cards: $e");
    }
  }

  Future<void> _applyVoucher() async {
    print('method_called');
    // print(BSData);
    try {
      enteredCode = _voucherController.text.trim();
      print('debug__1');
      // Map<String, dynamic> body = {
      //   "voucher_code": "SPIN50",
      //   "package_id": "75",
      //   "package_price": "5000",
      //   "package_type": "fd"
      // };

      Map<String, dynamic> body = {
        "voucher_code": enteredCode,
        "package_id": BSData['package_details']['package_id'],
        "package_price": BSData['package_price']['total'],
        "package_type": "fd"
      };

      final response = await APIHandler.validateVoucher(body);
      setState(() {
        voucherAPIResponse = response;
      });

      print('###########################################################');
      print(voucherAPIResponse);
      print('###########################################################');

      if (voucherAPIResponse['status'] == true) {
        finalPrice = voucherAPIResponse['final_price'];
        discountPrice = voucherAPIResponse['discount_price'];
        voucherCode = voucherAPIResponse['voucher_code'];
        Fluttertoast.showToast(msg: voucherAPIResponse['message']);
        isCodeApplied = true;
      } else {
        Fluttertoast.showToast(msg: voucherAPIResponse['message']);
      }
    } catch (e) {
      print(e);
      Fluttertoast.showToast(msg: e.toString());
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

      flightDetails = widget.flightDetails.isEmpty
          ? []
          : [
        {
          // 'flight': 'Emirates EK 567',
          // 'type': 'Departure',
          // 'icon': 'takeoff',
          // 'airport': 'Bangalore (BLR), India',
          // 'date': '11-Dec-2024',
          // 'terminal': 'T1',
          'flight': BSData['flight_details'][0]['airline_name']?.toString() ?? "N/A",
          'type': BSData['flight_details'][0]['flight_type']?.toString() ?? "N/A",
          'icon': 'takeoff',
          'from_city': BSData['flight_details'][0]['from_city']?.toString() ?? "N/A",
          'to_city': BSData['flight_details'][0]['to_city']?.toString() ?? "N/A",
          'date': BSData['flight_details'][0]['travel_date']?.toString() ?? "N/A",
          'dep_terminal': BSData['flight_details'][0]['depart_terminal']?.toString() ?? "N/A",
          'arr_terminal': BSData['flight_details'][0]['arrival_terminal']?.toString() ?? "N/A",
          'dep_time': BSData['flight_details'][0]['dep_time']?.toString() ?? "N/A",
          'arr_time': BSData['flight_details'][0]['arr_time']?.toString() ?? "N/A",
          'cabin_baggage': BSData['flight_details'][0]['cabin_baggage']?.toString() ?? "N/A",
          'checkin_baggage': BSData['flight_details'][0]['checkin_baggage']?.toString() ?? "N/A",
          'duration': BSData['flight_details'][0]['flight_duration']?.toString() ?? "N/A",
          'stops': BSData['flight_details'][0]['stops']?.toString() ?? "Non-stop",
        },
        {
          // 'flight': 'Emirates EK 567',
          // 'type': 'Departure',
          // 'icon': 'takeoff',
          // 'airport': 'Bangalore (BLR), India',
          // 'date': '11-Dec-2024',
          // 'terminal': 'T1',
          'flight': BSData['flight_details'][1]['airline_name']?.toString() ?? "N/A",
          'type': BSData['flight_details'][1]['flight_type']?.toString() ?? "N/A",
          'icon': 'landing',
          'from_city': BSData['flight_details'][1]['from_city']?.toString() ?? "N/A",
          'to_city': BSData['flight_details'][1]['to_city']?.toString() ?? "N/A",
          'date': BSData['flight_details'][1]['travel_date']?.toString() ?? "N/A",
          'dep_terminal': BSData['flight_details'][1]['depart_terminal']?.toString() ?? "N/A",
          'arr_terminal': BSData['flight_details'][1]['arrival_terminal']?.toString() ?? "N/A",
          'dep_time': BSData['flight_details'][1]['dep_time']?.toString() ?? "N/A",
          'arr_time': BSData['flight_details'][1]['arr_time']?.toString() ?? "N/A",
          'cabin_baggage': BSData['flight_details'][1]['cabin_baggage']?.toString() ?? "N/A",
          'checkin_baggage': BSData['flight_details'][1]['checkin_baggage']?.toString() ?? "N/A",
          'duration': BSData['flight_details'][1]['flight_duration']?.toString() ?? "N/A",
          'stops': BSData['flight_details'][1]['stops']?.toString() ?? "Non-stop",
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

  Widget _buildTopCurve() {
    return Padding(
      padding: const EdgeInsets.only(top: 50), // 20% of the screen height
      child: CustomPaint(
        size: Size(double.infinity, 0), // Height of the curved area
        painter: CirclePainter(radius: 200),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double fontSize = screenWidth * 0.035;

    return Scaffold(
      // appBar: AppBar(
      //   leading: IconButton(
      //     icon: const Icon(Icons.arrow_back, color: Colors.black),
      //     onPressed: () => Navigator.pop(context),
      //   ),
      //   backgroundColor: Colors.white,
      //   elevation: 0,
      //   title: const Text(
      //     'Booking Summary',
      //     style: TextStyle(color: Colors.black),
      //   ),
      //   centerTitle: true,
      // ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: isLoading
            ? _buildShimmerEffect()
            : Column(
          children: [
            _buildTopCurve(),
            const SizedBox(height: 10),
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
                const SizedBox(width: 10),
                Text('BOOKING SUMMARY',
                    style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.white))
              ],
            ),
            Padding(
              padding:
              EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  _buildSection(
                      'PACKAGE DETAILS', packageDetails, fontSize),
                  const SizedBox(height: 20),
                  if (flightDetails.isNotEmpty)
                    _buildFlightDetailsSection(
                        'FLIGHT DETAILS', flightDetails, fontSize),
                  tourList.isEmpty
                      ? SizedBox()
                      : _buildtourDetailsSection(
                      "TOUR DETAILS", tourList, fontSize),
                  const SizedBox(height: 20),
                  _buildSection('HOTEL DETAILS', hotelDetails, fontSize),
                  const SizedBox(height: 20),
                  _buildSection('TRANSFER DETAILS', transferDetails, fontSize),
                  const SizedBox(height: 20),
                  _buildSection('TRAVEL INSURANCE DETAILS', insuranceDetails, fontSize),
                  const SizedBox(height: 20),
                  _buildPriceSection('PRICE DETAILS', priceDetails, fontSize),
                  const SizedBox(height: 20),
                  Padding(
                    padding: EdgeInsets.all(5),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _voucherController,
                            enabled: !isCodeApplied,
                            decoration: InputDecoration(
                              labelText: "Enter Voucher Code",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: isCodeApplied ? null : _applyVoucher,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.lightBlueAccent,
                          ),
                          child: Text(
                            isCodeApplied ? "Applied" : "Apply",
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(
            left: 16.0, right: 16.0, bottom: 16.0, top: 7),
        child: SizedBox(
          width: double.infinity,
          child: IconButton(
            onPressed: () {
              _loadLogedinDetails();
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => isLoggedIn
                          ? TravelersDetailsFD(
                          flightDetails: widget.flightDetails,
                          selectedHotel: widget.selectedHotel,
                          packageDetails: widget.packageDetails,
                          totalRoomsdata: widget.totalRoomsdata,
                          searchId: widget.searchId,
                          activityList: widget.activityList,
                          destination: widget.destination,
                          BSData: BSData,
                          finalPrice: finalPrice.toString(),
                          voucherCode: enteredCode)
                          : LoginPage(
                        canSkip: true,
                        redirectTo: TravelersDetailsFD(
                          flightDetails: widget.flightDetails,
                          selectedHotel: widget.selectedHotel,
                          packageDetails: widget.packageDetails,
                          totalRoomsdata: widget.totalRoomsdata,
                          searchId: widget.searchId,
                          activityList: widget.activityList,
                          destination: widget.destination,
                          BSData: BSData,
                          finalPrice: finalPrice.toString(),
                          voucherCode: enteredCode,
                        ),
                      )));
            },
            icon: responciveButton(text: 'SELECT'),
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Map<String, String>> details, double fontSize) {
    return Card(
      color: Colors.white, // White background
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8), // Rounded corners for the card
      ),
      elevation: 4, // Add some elevation for shadow effect
      child: Padding(
        padding: const EdgeInsets.all(16.0), // Padding around the content
        child: Column(
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
            Column(
              children: List.generate(
                (details.length / 2).ceil(), // Divide into rows
                    (index) {
                  bool isLastOdd =
                      details.length % 2 != 0 && index == details.length ~/ 2;
                  return Column(
                    children: [
                      const Divider(color: Colors.grey),
                      const SizedBox(height: 15),
                      IntrinsicHeight(
                        // This ensures both boxes in the row will have equal height
                        child: Row(
                          children: [
                            Expanded(
                              child: _buildDetailBox(
                                details[index * 2]['title']!,
                                details[index * 2]['value']!,
                                fontSize,
                              ),
                            ),
                            if (!isLastOdd) ...[
                              const VerticalDivider(
                                  width: 10, color: Colors.grey),
                              Expanded(
                                child: _buildDetailBox(
                                  details[index * 2 + 1]['title']!,
                                  details[index * 2 + 1]['value']!,
                                  fontSize,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFlightDetailsSection(String title, List<Map<String, String>> details, double fontSize) {
    return Card(
      color: Colors.white, // White background for the card
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8), // Rounded corners for the card
      ),
      elevation: 4, // Shadow effect for the card
      child: Padding(
        padding: const EdgeInsets.all(16.0), // Padding around the content
        child: Column(
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
            Column(
              children: details.map((flight) {
                return Column(
                  children: [
                    const Divider(color: Colors.grey),
                    const SizedBox(height: 10),
                    _buildFlightCard(flight, fontSize),
                  ],
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  // Widget _buildFlightCard(Map<String, String> flight, double fontSize) {
  //   return Container(
  //     padding: EdgeInsets.all(fontSize * 0.7),
  //     margin: const EdgeInsets.only(bottom: 10),
  //     decoration: BoxDecoration(
  //       color: Colors.grey.shade50,
  //       borderRadius: BorderRadius.circular(10), // Rounded corners
  //     ),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Row(
  //           children: [
  //             Icon(
  //               flight['type'] == 'Onward'
  //                   ? Icons.flight_takeoff
  //                   : Icons.flight_land,
  //               color: Colors.black54,
  //             ),
  //             const SizedBox(width: 5),
  //             Text(
  //               flight['type']!,
  //               style: TextStyle(
  //                   fontSize: fontSize * 1.2, fontWeight: FontWeight.bold),
  //             ),
  //           ],
  //         ),
  //         const SizedBox(height: 5),
  //
  //         // Flight Name
  //         Text(
  //           flight['flight']!,
  //           style: TextStyle(
  //               fontSize: fontSize * 1.1,
  //               fontWeight: FontWeight.bold,
  //               color: Colors.blue),
  //         ),
  //         const SizedBox(height: 5),
  //
  //         // Airport Name
  //         Row(
  //           children: [
  //             const Icon(Icons.location_on, color: Colors.black54),
  //             const SizedBox(width: 5),
  //             Text(flight['airport']!, style: TextStyle(fontSize: fontSize)),
  //           ],
  //         ),
  //         const SizedBox(height: 5),
  //
  //         // Date
  //         Row(
  //           children: [
  //             const Icon(Icons.date_range, color: Colors.black54),
  //             const SizedBox(width: 5),
  //             Text("${flight['date']}", style: TextStyle(fontSize: fontSize)),
  //           ],
  //         ),
  //         const SizedBox(height: 5),
  //
  //         // Terminal
  //         Row(
  //           children: [
  //             const Icon(Icons.directions_transit, color: Colors.black54),
  //             const SizedBox(width: 5),
  //             Text("${flight['terminal']}",
  //                 style: TextStyle(fontSize: fontSize)),
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildFlightCard(Map<String, String> flight, double fontSize) {
    return Container(
      padding: EdgeInsets.all(fontSize * 0.7),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Type Row
          Row(
            children: [
              Row(
                children: [
                  Icon(
                    flight['type'] == 'Onward'
                        ? Icons.flight_takeoff
                        : Icons.flight_land,
                    color: Colors.blue,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    flight['type'] ?? "N/A",
                    style: TextStyle(
                      fontSize: fontSize * 1.2,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Text(
                flight['flight'] ?? "N/A",
                style: TextStyle(
                  fontSize: fontSize * 1.1,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),


          // Airport Name Row (with space-between)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.location_on, color: Colors.black54),
                  const SizedBox(width: 5),
                  Text(
                    flight['from_city'] ?? "N/A",
                    style: TextStyle(fontSize: fontSize),
                  ),
                ],
              ),
              Text(
                flight['to_city'] ?? "N/A",
                style: TextStyle(fontSize: fontSize),
              ),
            ],
          ),
          const SizedBox(height: 5),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Left side (Date and Departure Time)
              Row(
                children: [
                  const Icon(Icons.date_range, color: Colors.black54),
                  const SizedBox(width: 5),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start, // Left alignment
                    children: [
                      Text(
                        flight['date'] ?? "N/A", // Date on top
                        style: TextStyle(fontSize: fontSize),
                      ),
                      Text(
                        flight['dep_time'] ?? 'N/A', // Departure time below the date
                        style: TextStyle(fontSize: fontSize),
                      ),
                    ],
                  ),
                ],
              ),

              // Right side (Date and Arrival Time)
              Column(
                crossAxisAlignment: CrossAxisAlignment.end, // Right alignment
                children: [
                  Text(
                    flight['date'] ?? "N/A", // Date on top
                    style: TextStyle(fontSize: fontSize),
                  ),
                  Text(
                    flight['arr_time'] ?? 'N/A', // Arrival time below the date
                    style: TextStyle(fontSize: fontSize),
                    textAlign: TextAlign.end, // Aligns the text to the end (right)
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 5),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.timer, color: Colors.black54),
                  const SizedBox(width: 5),
                  Text(
                    "Duration: ${flight['duration'] ?? 'N/A'}",
                    style: TextStyle(fontSize: fontSize),
                  ),
                ],
              ),
              Text("Stops: ${flight['stops']}",
                style: TextStyle(fontSize: fontSize),
              )
            ],
          ),
          const SizedBox(height: 5),

          // Terminal Info Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.directions_transit, color: Colors.black54),
                  const SizedBox(width: 5),
                  Text(
                    flight['dep_terminal'] ?? "N/A",
                    style: TextStyle(fontSize: fontSize),
                  ),
                ],
              ),
              Text(
                flight['arr_terminal'] ?? "N/A",
                style: TextStyle(fontSize: fontSize),
              ),
            ],
          ),

          const Divider(),
          // Baggage Info Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.luggage, color: Colors.black54),
                  const SizedBox(width: 5),
                  Text(
                    "Check-in: ${flight['checkin_baggage'] ?? 'N/A'}kg",
                    style: TextStyle(fontSize: fontSize),
                  ),
                ],
              ),
              Text(
                "Cabin: ${flight['cabin_baggage'] ?? 'N/A'}kg",
                style: TextStyle(fontSize: fontSize),
              ),
            ],
          ),
          const SizedBox(height: 5),

        ],
      ),
    );
  }


  Widget _buildPriceSection(String title, List<Map<String, dynamic>> details, double fontSize) {
    return SizedBox(
      width: double.infinity, // Makes the card take full width
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
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
              const Divider(),
              const SizedBox(height: 10),
              Column(
                children: details.map((item) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _buildPriceDetailBox(
                      item['title']!,
                      item['value']!,
                      fontSize,
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 10),
              if (isCodeApplied)
                Container(
                  width: double.infinity, // Already correct
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Voucher Applied',
                        style: TextStyle(
                          fontSize: fontSize,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Voucher Code:'),
                          Text(voucherCode ?? "N/A"),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Discount Price:'),
                          Text(discountPrice ?? "N/A"),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Final Price:'),
                          Text(finalPrice ?? "N/A"),
                        ],
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailBox(String title, String value, double fontSize) {
    return Container(
      width: double.infinity, // Makes the box take full width
      padding: EdgeInsets.all(fontSize * 0.7),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
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

  Widget _buildPriceDetailBox(String title, String value, double fontSize) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(fontSize * 0.7),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
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
          SizedBox(height: fontSize * 0.4),
          Text(
            value,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.normal,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildtourDetailsSection(String title, List<Map<String, dynamic>> tour, double fontSize) {
    return Card(
      color: Colors.white, // White background for the card
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8), // Rounded corners for the card
      ),
      elevation: 4, // Shadow effect for the card
      child: Padding(
        padding: const EdgeInsets.all(16.0), // Padding around the content
        child: Column(
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
            Column(
              children: tour.map((tour) {
                return Column(
                  children: [
                    const Divider(color: Colors.grey),
                    const SizedBox(height: 20),
                    _buildTourCard(tour, fontSize),
                  ],
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTourCard(Map<dynamic, dynamic> tour, double fontSize) {
    return Container(
      // padding: EdgeInsets.all(fontSize * 0.7),
      padding: EdgeInsets.symmetric(
          horizontal: fontSize * 0.7, vertical: fontSize * 0.5),
      margin: const EdgeInsets.only(bottom: 2),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(10), // Rounded corners for the card
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
        SizedBox(
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

class CirclePainter extends CustomPainter {
  final double radius;

  CirclePainter({required this.radius});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..style = PaintingStyle.fill;

    // We can use FontAwesome icon positioning logic here.
    double centerX = size.width / 2;

    // Draw the largest circle (dark blue)
    paint.color = Color(0xFF0D939E);
    canvas.drawCircle(Offset(centerX, radius - 600), radius + 400, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
