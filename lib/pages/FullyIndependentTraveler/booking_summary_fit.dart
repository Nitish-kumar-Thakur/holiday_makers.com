import 'package:HolidayMakers/pages/login&signup/Test.dart';
import 'package:flutter/material.dart';
import 'package:HolidayMakers/pages/FullyIndependentTraveler/travelers_details_fit.dart';
import 'package:HolidayMakers/utils/api_handler.dart';
import 'package:HolidayMakers/widgets/responciveButton.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

class BookingSummaryFIT extends StatefulWidget {
  final String searchId;
  final List<dynamic> activityList;
  final List<dynamic> roomArray;
  final String destination;
  const BookingSummaryFIT(
      {super.key,
      required this.searchId,
      required this.roomArray,
      required this.activityList,
      required this.destination});

  @override
  State<BookingSummaryFIT> createState() => _BookingSummaryFITState();
}

class _BookingSummaryFITState extends State<BookingSummaryFIT> {
  List<Map<String, dynamic>> packageDetails = [];
  List<Map<String, dynamic>> hotelDetails = [];
  List<Map<String, dynamic>> transferDetails = [];
  List<Map<String, dynamic>> priceDetails = [];
  List<Map<String, dynamic>> flightDetails = [];
  List<Map<String, dynamic>> insuranceDetails = [];
  List<Map<String, dynamic>> tourList = [];

  Map<String, dynamic> bookingApiData = {};
  Map<dynamic, dynamic> bookingSummreyData = {};
  // List<dynamic> destinationList = [];
  bool isLoading = true;
  bool isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    bookingApiDataIntlize();
    bookingSummaryFIT();
    print("================================================");
    print({
      "search_id": widget.searchId,
      "activity_list": [
        {"destination": widget.destination, "activity": widget.activityList}
      ]
    });
    print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
    print("================================================");
  }

  Future<void> _loadLogedinDetails() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isLoggedIn = prefs.getBool("isLoggedIn") ?? false;
    });
  }

  void bookingApiDataIntlize() {
    final searchId = widget.searchId;
    // final hotel = widget.responceData["data"]["search_params"];
    // final roomArray = widget.roomArray;

    // final onwardFlight = widget.responceData["data"]["flight"]["onward"];
    // final returnFlight = widget.responceData["data"]["flight"]["return"];
    // final insuranceList = widget.responceData["data"]["insurance_list"];

    setState(() {
      bookingApiData = {
        "search_id": searchId,
        "activity_list": [
          {"destination": widget.destination, "activity": widget.activityList}
        ]
      };
    });
  }

  Future<void> bookingSummaryFIT() async {
    try {
      // print("Sending API Request with Data: $bookingApiData");
      Map<dynamic, dynamic> response =
          await APIHandler.fitBookingSummary(bookingApiData);

      // print("API Response: ${response["data"]["result"]["activity"]["activity_list"]}");

      if (response["message"] == "success") {
        setState(() {
          bookingSummreyData = response;
          packagedetails();
          isLoading = false;
        });
        // print("Booking Summary Data Updated: ${bookingSummreyData["data"]["result"]["activity"]["activity_list"]}");
      } else {
        // print("API Error: ${response["message"]}");
      }
    } catch (error) {
      // print("Exception in API Call: $error");
    }
  }

  void packagedetails() {
    // final searchparams = bookingSummreyData["data"]["search_parms"];
    // final searchParms = widget.responceData["data"]["search_params"] ?? [];
    final hotel = bookingSummreyData["data"]["result"]["hotel"] ?? [];
    final amount = bookingSummreyData["data"] ?? [];
    final onwardFlight =
        bookingSummreyData["data"]["result"]["flight"]["onward"];
    final String onwardconnectioncount = bookingSummreyData["data"]["result"]
            ["flight"]["onward"]["connection_count"]
        .toString();
    final String returnconnectioncount = bookingSummreyData["data"]["result"]
            ["flight"]["return"]["connection_count"]
        .toString();
    final returnFlight =
        bookingSummreyData["data"]["result"]["flight"]["return"] ?? [];
    final activityList =
        bookingSummreyData["data"]["result"]["activity"]["activity_list"] ?? [];
    // print("@@@@@@@@@@@@@@@@@@!@#%^&*!@#%^&*()@@@@@@@@@@@@@@@@");
    // print(activityList);
    // print("@@@@@@@@@@@@@@@@@@!@#%^&*!@#%^&*()@@@@@@@@@@@@@@@@");
    // final airportToHotel =
    //     bookingSummreyData["data"]["result"]["transfer"]["airport_to_hotel"];

    if (hotel != null && amount != null) {
      // int n = int.parse(hotel["no_of_nights"]) - 1;
      // String night = n.toString();
      // // Parsing the check_out_date String to DateTime
      // DateTime checkInDateTime = DateTime.parse(hotel["check_in_date"]);
      // DateTime checkOutDateTime =
      //     DateTime.parse(hotel["check_out_date"]);
      // // Formatting it to "dd-MM-yyyy"
      // String checkInDate = DateFormat('dd MMM yy, EEE').format(checkInDateTime);
      // // Parsing the check_out_date String to DateTime

      // // Formatting it to "dd-MM-yyyy"
      // String checkOutDate =
      //     DateFormat('dd MMM yy, EEE').format(checkOutDateTime);
      setState(() {
        // packageDetails = [
        //   {
        //     "title": "Package",
        //     "value": "${hotel["destination"]}: ${hotel["destination"]}" ?? "N/A"
        //   },
        //   // {"title": "Destination", "value": hotel["destination"] ?? "N/A"},
        //   {
        //     "title": "Duration",
        //     "value": "${hotel["no_of_nights"]} Days/ $n Night"
        //   },
        //   {"title": "Departure Date", "value": checkInDate},
        //   {"title": "Arrival Date", "value": checkOutDate},
        //   // {"title": "Arrival Date", "value": hotel["room_count"] ?? "N/A"},
        // ];
        hotelDetails = [
          {"title": "Hotel Name", "value": hotel["hotel_name"]},
          {"title": "Room Type", "value": hotel["room_category_name"]},
          {"title": "Check In Time", "value": hotel["checkin_time"]},
          {"title": "Check Out Time", "value": hotel["checkout_time"]},
          {"title": "No. of Rooms", "value": amount["room_count"].toString()},
          {"title": "Meal Plan", "value": hotel["meal_type_name"]},
        ];
        print(
            "onward flight: ${bookingSummreyData["data"]["result"]["flight"]["onward"]}");
        if (bookingSummreyData["data"]["result"]["flight"]["onward"] == null) {
          print("flightDetails: $flightDetails");
        } else {
          flightDetails = [
            {
              'flight': onwardFlight['flight_name']?.toString() ?? "N/A",
              'type': onwardFlight['flight_type']?.toString() ?? "N/A",
              'icon': 'landing',
              'from_city':
                  onwardFlight['dep_airport_city']?.toString() ?? "N/A",
              'to_city': onwardFlight['arr_airport_city']?.toString() ?? "N/A",
              'date': onwardFlight['onward_date']?.toString() ?? "N/A",
              'dep_terminal':
                  onwardFlight['depart_terminal']?.toString() ?? "N/A",
              'arr_terminal':
                  onwardFlight['arrival_terminal']?.toString() ?? "N/A",
              'dep_time': onwardFlight['dep_time']?.toString() ?? "N/A",
              'arr_time': onwardFlight['arr_time']?.toString() ?? "N/A",
              'cabin_baggage':
                  onwardFlight['cabin_baggage']?.toString() ?? "N/A",
              'checkin_baggage':
                  onwardFlight['check_in_baggage']?.toString() ?? "N/A",
              'duration': onwardFlight['flight_duration']?.toString() ?? "N/A",
              'stops':
                  onwardFlight['connection_count']?.toString() ?? "Non-stop",
              'stop_name': onwardconnectioncount == "1"
                  ? onwardFlight['connection_flight_details'][0]['arr_to_city']
                  : "N/A"
            },
            {
              'flight': returnFlight['flight_name']?.toString() ?? "N/A",
              'type': returnFlight['flight_type']?.toString() ?? "N/A",
              'icon': 'landing',
              'from_city':
                  returnFlight['dep_airport_city']?.toString() ?? "N/A",
              'to_city': returnFlight['arr_airport_city']?.toString() ?? "N/A",
              'date': returnFlight['return_date']?.toString() ?? "N/A",
              'dep_terminal':
                  returnFlight['depart_terminal']?.toString() ?? "N/A",
              'arr_terminal':
                  returnFlight['arrival_terminal']?.toString() ?? "N/A",
              'dep_time': returnFlight['dep_time']?.toString() ?? "N/A",
              'arr_time': returnFlight['arr_time']?.toString() ?? "N/A",
              'cabin_baggage':
                  returnFlight['cabin_baggage']?.toString() ?? "N/A",
              'checkin_baggage':
                  returnFlight['check_in_baggage']?.toString() ?? "N/A",
              'duration': returnFlight['flight_duration']?.toString() ?? "N/A",
              'stops':
                  returnFlight['connection_count']?.toString() ?? "Non-stop",
              'stop_name': returnconnectioncount == "1"
                  ? returnFlight['connection_flight_details'][0]['arr_to_city']
                  : "N/A"
            },
          ];
        }

        insuranceDetails = [
          {'title': 'Travel Insurance in accordance to standards', 'value': ''},
        ];
        transferDetails = [
          {"title": "Arrival Transfer", "value": "Airport to Hotel"},
          {"title": "Return Transfer", "value": "Hotel to Airport"},
        ];
        priceDetails = [
          {
            "title": "Prices",
            "value": [
              if (amount["total_adult_count"] != null &&
                  amount["total_adult_count"] > 0)
                "${amount["total_adult_count"]} Adult(s) AED ${amount["total_adult_amount"]}",
              if (amount["total_child_count"] != null &&
                  amount["total_child_count"] > 0)
                "${amount["total_child_count"]} Child(ren) AED ${amount["total_child_amount"]}",
              if (amount["total_infant_count"] != null &&
                  amount["total_infant_count"] > 0)
                "${amount["total_infant_count"]} Infant(s) AED ${amount["total_infant_amount"]}",
            ]
                .where((element) => element.isNotEmpty)
                .join("\n"), // Join all valid values with line breaks
          },
          {
            "title": "Total",
            "value": "AED  ${amount["total_amount"].toString()}"
          },
        ];
        tourList = (activityList as List).map((activity) {
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
      });
    }
  }

  // Widget _buildDetailBox(String title, String value, double fontSize) {
  //   return Container(
  //     width: 180,
  //     height: 95,
  //     padding: EdgeInsets.all(fontSize * 0.7),
  //     decoration: BoxDecoration(
  //       color: Colors.grey.shade200,
  //       borderRadius: BorderRadius.circular(8),
  //     ),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Text(
  //           title,
  //           style: TextStyle(
  //             fontSize: fontSize * 1.2,
  //             fontWeight: FontWeight.bold,
  //             color: Colors.black,
  //           ),
  //         ),
  //         SizedBox(height: fontSize * 0.3),
  //         Text(
  //           value,
  //           style: TextStyle(
  //             fontSize: title == "Price" ? 10 : fontSize,
  //             fontWeight: FontWeight.normal,
  //             color: Colors.black,
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

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
      //     onPressed: () {
      //       Navigator.pop(context);
      //     },
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
      body: isLoading
          ? _buildShimmerEffect()
          : SingleChildScrollView(
              child: Column(children: [
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
                            fontWeight:
                                FontWeight.bold, // Make the "<" bold if needed
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
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 40),
                      // _buildSection('PACKAGE DETAILS', packageDetails, fontSize),
                      flightDetails.isEmpty
                          ? SizedBox(
                              height: 10,
                            )
                          : _buildFlightDetailsSection(
                              'FLIGHT DETAILS', flightDetails, fontSize),
                      const SizedBox(height: 20),
                      tourList.isEmpty
                          ? SizedBox()
                          : _buildtourDetailsSection(
                              "TOUR DETAILS", tourList, fontSize),
                      const SizedBox(height: 20),
                      _buildSection('HOTEL DETAILS', hotelDetails, fontSize),
                      const SizedBox(height: 20),
                      flightDetails.isEmpty
                          ? SizedBox(
                              height: 10,
                            )
                          : _buildSection(
                              'TRANSFER DETAILS', transferDetails, fontSize),
                      const SizedBox(height: 20),
                      _buildSection('TRAVEL INSURANCE DETAILS',
                          insuranceDetails, fontSize),
                      const SizedBox(height: 20),
                      _buildPriceSection(
                          'PRICE DETAILS', priceDetails, fontSize),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ]),
            ),
      bottomNavigationBar: isLoading
          ? null
          : Padding(
              padding: EdgeInsets.all(20.0),
              child: GestureDetector(
                onTap: () {
                  _loadLogedinDetails();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => isLoggedIn
                            ? TravelersDetailsFIT(
                                totalRoomsdata: widget.roomArray,
                                searchId: widget.searchId,
                                BSData: bookingSummreyData['data'],
                              )
                            : LoginPage(
                                canSkip: true,
                                redirectTo: TravelersDetailsFIT(
                                  totalRoomsdata: widget.roomArray,
                                  searchId: widget.searchId,
                                  BSData: bookingSummreyData['data'],
                                ),
                              )),
                  );
                },
                child: responciveButton(text: 'PROCEED TO BOOKING'),
              ),
            ),
    );
  }

  Widget _buildFlightDetailsSection(
      String title, List<Map<String, dynamic>> details, double fontSize) {
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
            const Divider(color: Colors.grey),
            const SizedBox(height: 15),
            Column(
              children: details.map((flight) {
                return _buildFlightCard(flight, fontSize);
              }).toList(),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildFlightCard(Map<String, dynamic> flight, double fontSize) {
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
                    crossAxisAlignment:
                        CrossAxisAlignment.start, // Left alignment
                    children: [
                      Text(
                        flight['date'] ?? "N/A", // Date on top
                        style: TextStyle(fontSize: fontSize),
                      ),
                      Text(
                        flight['dep_time'] ??
                            'N/A', // Departure time below the date
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
                    textAlign:
                        TextAlign.end, // Aligns the text to the end (right)
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
              Text(
                flight['stops'] == "0"
                    ? "Stops: Non-Stop"
                    : "Stops: ${flight['stops'] ?? 'N/A'} via ${flight['stop_name'] ?? 'N/A'}",    // ${flight['stop_name'] ?? 'N/A'}
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

  Widget _buildSection(
      String title, List<Map<String, dynamic>> details, double fontSize) {
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
              children: List.generate(
                (details.length / 2).ceil(), // Divide into rows
                (index) {
                  bool isLastOdd =
                      details.length % 2 != 0 && index == details.length ~/ 2;
                  return Column(
                    children: [
                      const Divider(
                          color: Colors.grey), // Divider before each row
                      const SizedBox(height: 10),
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
                              const SizedBox(width: 10),
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
                      const SizedBox(height: 10), // Space after each row
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

  Widget _buildDetailBox(String title, String value, double fontSize) {
    return Container(
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
              fontSize: fontSize,
              fontWeight: FontWeight.normal,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceSection(
      String title, List<Map<String, dynamic>> details, double fontSize) {
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
            // const SizedBox(height: 10),
            const Divider(),
            Column(
              children: List.generate(
                details
                    .length, // Directly use details.length, no need to divide by 2
                (index) {
                  return Column(
                    children: [
                      SizedBox(height: 10), // Space between items
                      _buildPriceDetailBox(
                        details[index]['title']!,
                        details[index]['value']!,
                        fontSize,
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

  Widget _buildPriceDetailBox(String title, String value, double fontSize) {
    return Container(
      width: double.infinity, // Makes the container take the whole width
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

  Widget _buildtourDetailsSection(
      String title, List<Map<String, dynamic>> tour, double fontSize) {
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
            // const SizedBox(height: 10),
            Column(
              children: tour.map((tour) {
                return _buildTourCard(tour, fontSize);
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTourCard(Map<dynamic, dynamic> tour, double fontSize) {
    return Column(
      children: [
        const Divider(color: Colors.grey), // Divider between each tour card
        const SizedBox(height: 15),
        Container(
          padding: EdgeInsets.all(fontSize * 0.7),
          // margin: const EdgeInsets.only(bottom: 2),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width *
                    0.4, // 40% of screen width
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
        ),
      ],
    );
  }

  // Function to build the details box
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
