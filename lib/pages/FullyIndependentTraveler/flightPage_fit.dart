import 'package:flutter/material.dart';
import 'package:HolidayMakers/pages/FullyIndependentTraveler/add_tour_fit.dart';
import 'package:HolidayMakers/utils/api_handler.dart';
import 'package:HolidayMakers/widgets/responciveButton.dart';

import 'package:shimmer/shimmer.dart';

class FlightPageFIT extends StatefulWidget {
  final String numberOfNights;
  final Map<dynamic, dynamic>? responceData;
  final Map<dynamic, dynamic>? hotel;
  final List<dynamic> roomArray;

  const FlightPageFIT(
      {super.key,
      required this.hotel,
      required this.responceData,
      required this.roomArray,
      required this.numberOfNights});

  @override
  State<FlightPageFIT> createState() => _FlightPageFITState();
}

class _FlightPageFITState extends State<FlightPageFIT> {
  Map<dynamic, dynamic>? flightList;
  bool isLoading = true;
  int hotelAndTransferFare = 0;
  int selectedFlightIndex = 0;
  @override
  void initState() {
    super.initState();
    fitFlightList();
  }

  Future<void> fitFlightList() async {
    final hotel = widget.hotel;
    Map<String, dynamic> fitUpdateHotelData = {
      "search_id": widget.responceData?["data"]["search_id"],
      "hotel_id": hotel?["parent_ht_id"],
      "hotel_fit_id": hotel?["hotel_fit_id"]
    };
    try {
      print("Sending API Request with Data: $fitUpdateHotelData");
      Map<dynamic, dynamic> response =
          await APIHandler.fitUpdateHotel(fitUpdateHotelData);

      print("API Response: ${response}");

      if (response["message"] == "success") {
        setState(() {
          flightList = response["data"];
          hotelAndTransferFare = response['data']["hotel_and_transfer_fare"];
          isLoading = false;
        });

        // print("Update Hotel Data Updated: ${fitUpdateHotelData}");
      } else {
        print("API Error: ${response["message"]}");
      }
    } catch (error) {
      print("Exception in API Call: $error");
    }
  }

  Future<void> fitUpdateFlight(
      final Map<String, dynamic> selectedFlightPackage) async {
    Map<String, dynamic> fitUpdateFlightData = {
      "search_id": widget.responceData?["data"]["search_id"],
      "flight_fare_id":
          "${selectedFlightPackage["onward"][0]["flight_fare_id"] ?? ""}_${selectedFlightPackage["return"][0]["flight_fare_id"] ?? ""}"
    };
    try {
      // print("Sending API Request with Data: $fitUpdateHotelData");
      Map<dynamic, dynamic> response =
          await APIHandler.fitUpdateFlight(fitUpdateFlightData);

      print("Flight Response: ${response}");

      if (response["message"] == "success") {
        // print("Update Hotel Data Updated: ${fitUpdateHotelData}");
      } else {
        print("API Error: ${response["message"]}");
      }
    } catch (error) {
      print("Exception in API Call: $error");
    }
  } // Default: No selection

  _selectButton(final Map<String, dynamic> selectedFlightPackage) async {
    await fitUpdateFlight(
        selectedFlightPackage); // Wait for API response before proceeding
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TourBookingPageFIT(
            numberOfNights: widget.numberOfNights,
            searchId: (widget.responceData?["data"]["search_id"]).toString(),
            totalRoomsdata: widget.roomArray),
      ),
    );
  }

  /// Function to group flights by `flight_name`
  Map<String, Map<String, dynamic>> _groupFlightsByName() {
    Map<String, Map<String, dynamic>> groupedFlights = {};

    final List<Map<String, dynamic>> onwardFlights =
        List<Map<String, dynamic>>.from(flightList?["flight"]["onward"] ?? []);
    final List<Map<String, dynamic>> returnFlights =
        List<Map<String, dynamic>>.from(flightList?["flight"]["return"] ?? []);

    // Group onward flights by `flight_name`
    for (var flight in onwardFlights) {
      String flightName = flight["flight_name"] ?? "Unknown Airline";
      if (!groupedFlights.containsKey(flightName)) {
        groupedFlights[flightName] = {
          "onward": [],
          "return": [],
        };
      }
      groupedFlights[flightName]?["onward"]!.add(flight);
    }

    // Group return flights by `flight_name`
    for (var flight in returnFlights) {
      String flightName = flight["flight_name"] ?? "Unknown Airline";
      if (groupedFlights.containsKey(flightName)) {
        groupedFlights[flightName]?["return"]!.add(flight);
      } else {
        groupedFlights[flightName] = {
          "onward": [],
          "return": [flight],
        };
      }
    }

    return groupedFlights;
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
    Map<String, Map<String, dynamic>> groupedFlights = _groupFlightsByName();

    return Scaffold(
      backgroundColor: Colors.grey[100],
      // appBar: AppBar(
      //   backgroundColor: Colors.grey[100],
      //   leading: IconButton(
      //     onPressed: () {
      //       Navigator.pop(context);
      //     },
      //     icon: const Icon(Icons.arrow_back, color: Colors.black),
      //   ),
      //   title: const Text(
      //     "SELECT YOUR FLIGHT",
      //     style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
      //   ),
      // ),
      body: Column(
        children: [
          _buildTopCurve(),
          const SizedBox(height: 30),
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
              Text('SELECT YOUR FLIGHT',
                  style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white))
            ],
          ),
          Expanded(
            child: isLoading
                ? Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          FlightPackageShimmer(),
                          FlightPackageShimmer()
                        ],
                      ),
                    ),
                  )
                : groupedFlights.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Oops!',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  'No flights found matching your search.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                  ),
                                ),
                                SizedBox(height: 30),
                              ],
                            ),
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: groupedFlights.length,
                        itemBuilder: (context, index) {
                          String flightName =
                              groupedFlights.keys.elementAt(index);
                          Map<String, dynamic> flightData =
                              groupedFlights[flightName]!;

                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: FlightPackageCard(
                              hotelAndTransferFare:
                                  flightList?["hotel_and_transfer_fare"] ?? 0,
                              onwardFlights: List<Map<String, dynamic>>.from(
                                  flightData["onward"] ?? []),
                              returnFlights: List<Map<String, dynamic>>.from(
                                  flightData["return"] ?? []),
                              isSelected: selectedFlightIndex == index,
                              onTap: () {
                                setState(() {
                                  selectedFlightIndex = index;
                                });
                              },
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
      bottomNavigationBar: isLoading
          ? null
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: GestureDetector(
                onTap: () {
                  if (groupedFlights.isNotEmpty && selectedFlightIndex >= 0) {
                    String selectedFlightName =
                        groupedFlights.keys.elementAt(selectedFlightIndex);
                    Map<String, dynamic> selectedFlightPackage =
                        groupedFlights[selectedFlightName]!;
                    print("&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&");
                    print(
                        "${selectedFlightPackage["onward"][0]["flight_fare_id"]}_${selectedFlightPackage["return"][0]["flight_fare_id"]}");
                    print("&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&");
                    _selectButton(selectedFlightPackage);
                  } else {
                    print(
                        "SearchFIT: ${widget.responceData?["data"]["search_id"]}");
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TourBookingPageFIT(
                            numberOfNights: widget.numberOfNights,
                            searchId: (widget.responceData?["data"]
                                    ["search_id"])
                                .toString(),
                            totalRoomsdata: widget.roomArray),
                      ),
                    );
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: responciveButton(text: "Book Now"),
                ),
              ),
            ),
    );
  }
}

class FlightPackageCard extends StatefulWidget {
  final List<Map<String, dynamic>> onwardFlights;
  final List<Map<String, dynamic>> returnFlights;
  final int hotelAndTransferFare;
  final bool isSelected;
  final VoidCallback onTap; // Add this

  const FlightPackageCard(
      {super.key,
      required this.onwardFlights,
      required this.returnFlights,
      required this.isSelected,
      required this.onTap,
      required this.hotelAndTransferFare});

  @override
  _FlightPackageCardState createState() => _FlightPackageCardState();
}

class _FlightPackageCardState extends State<FlightPackageCard> {
  final Set<String> _expandedFlights =
      {}; // Tracks which flight details are expanded
  String? selectedOnwardFlight;
  String? selectedReturnFlight;

  void _toggleExpand(String flightKey) {
    setState(() {
      if (_expandedFlights.contains(flightKey)) {
        _expandedFlights.remove(flightKey);
      } else {
        _expandedFlights.add(flightKey);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    String onwardStops = (widget.onwardFlights.length - 1 == 0
            ? 'Non-stop'
            : widget.onwardFlights.length - 1)
        .toString();
    String returnStops = (widget.returnFlights.length - 1 == 0
            ? 'Non-stop'
            : widget.returnFlights.length - 1)
        .toString();

    String returnFlightKey =
        widget.returnFlights[0]['flight_details_id'].toString();
    String returnCabinBaggage =
        widget.returnFlights[0]['cabin_baggage'].toString();
    String returnCheckinBaggage =
        widget.returnFlights[0]['check_in_baggage'].toString();

    String onwardFlightKey =
        widget.onwardFlights[0]['flight_details_id'].toString();
    String onwardCabinBaggage =
        widget.onwardFlights[0]['cabin_baggage'].toString();
    String onwardCheckinBaggage =
        widget.onwardFlights[0]['check_in_baggage'].toString();

    bool isOnwardExpanded = _expandedFlights.contains(onwardFlightKey);
    bool isReturnExpanded = _expandedFlights.contains(returnFlightKey);

    // print('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');
    // print(onwardStops);
    // print(returnStops);
    // print(returnFlightKey);
    // print(returnCabinBaggage);
    // print(returnCheckinBaggage);
    // print('=======================================================');
    // print(onwardFlightKey);
    // print(onwardCabinBaggage);
    // print(onwardCheckinBaggage);
    // print('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');

    return GestureDetector(
      onTap: widget.onTap,
      child: Card(
        // color: Colors.white,
        color: Color(0xFFEEEEEE),
        margin: const EdgeInsets.only(bottom: 20),
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  height: 12,
                  width: 12,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget.isSelected
                        ? Color(0xFF0071BC)
                        : Colors.transparent,
                    border: Border.all(color: Color(0xFF0071BC)),
                  ),
                ),
              ),
              Text(
                "Onward Flight",
                style: TextStyle(
                  color: Color(0xFF0071BC),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              _flightSection("Onward Flight", widget.onwardFlights),
              InkWell(
                onTap: () => _toggleExpand(onwardFlightKey),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline,
                        size: 16, color: Colors.blueAccent),
                    const SizedBox(width: 5),
                    Text(
                      isOnwardExpanded ? "Hide Info" : "Show More",
                      style: const TextStyle(
                          fontSize: 12, color: Colors.blueAccent),
                    ),
                  ],
                ),
              ),
              AnimatedCrossFade(
                firstChild: const SizedBox.shrink(),
                secondChild: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10),
                    Text("Cabin Baggage: $onwardCabinBaggage kg"),
                    Text("Check-in Baggage: $onwardCheckinBaggage kg"),
                  ],
                ),
                crossFadeState: isOnwardExpanded
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                duration: const Duration(milliseconds: 300),
              ),
              const SizedBox(height: 5),
              Center(
                child: Text(
                  'Stops: $onwardStops',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Divider(),
              Text(
                "Return Flight",
                style: TextStyle(
                  color: Color(0xFF0071BC),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              _flightSection("Return Flight", widget.returnFlights),
              const SizedBox(height: 10),
              InkWell(
                onTap: () => _toggleExpand(returnFlightKey),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline,
                        size: 16, color: Colors.blueAccent),
                    const SizedBox(width: 5),
                    Text(
                      isReturnExpanded ? "Hide Info" : "Show More",
                      style: const TextStyle(
                          fontSize: 12, color: Colors.blueAccent),
                    ),
                  ],
                ),
              ),
              AnimatedCrossFade(
                firstChild: const SizedBox.shrink(),
                secondChild: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10),
                    Text("Cabin Baggage: $returnCabinBaggage kg"),
                    Text("Check-in Baggage: $returnCheckinBaggage kg"),
                  ],
                ),
                crossFadeState: isReturnExpanded
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                duration: const Duration(milliseconds: 300),
              ),
              const SizedBox(height: 5),
              Center(
                child: Text(
                  'Stops: $returnStops',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total Amount",
                    style: TextStyle(
                      color: Color(0xFF0071BC),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        "AED ${(widget.onwardFlights.isNotEmpty && widget.returnFlights.isNotEmpty ? widget.onwardFlights[0]["Per_totalAmount"] + widget.returnFlights[0]["Per_totalAmount"] + widget.hotelAndTransferFare : 0).toString()}",
                        style: const TextStyle(
                          color: Color(0xFF0071BC),
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(width: 8),
                      // Container(
                      //   height: 10,
                      //   width: 10,
                      //   decoration: BoxDecoration(
                      //     shape: BoxShape.circle,
                      //     color: widget.isSelected
                      //         ? Colors.pinkAccent
                      //         : Colors.transparent,
                      //     border: Border.all(color: Colors.pinkAccent),
                      //   ),
                      // ),
                    ],
                  ),
                ],
              ),
              // const SizedBox(height: 15),
              // Align(
              //   alignment: Alignment.center,
              //   child: SizedBox(
              //     width: double.infinity,
              //     child: ElevatedButton(
              //       onPressed: widget.onTap,
              //       style: ElevatedButton.styleFrom(
              //         backgroundColor:
              //             widget.isSelected ? Color(0xFF0071BC) : Colors.white,
              //         shape: RoundedRectangleBorder(
              //           borderRadius: BorderRadius.circular(10),
              //         ),
              //         side: BorderSide(
              //             color:
              //                 Color(0xFF0071BC)), // Add a border for visibility
              //       ),
              //       child: Text(
              //         widget.isSelected ? 'SELECTED' : 'SELECT',
              //         style: TextStyle(
              //           color: widget.isSelected
              //               ? Colors.white
              //               : Color(0xFF0071BC), // Fix text color
              //           fontSize: 16.0, // Set proper font size
              //           fontWeight: FontWeight.bold,
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _flightSection(String title, List<Map<String, dynamic>> flights) {
    if (flights.isEmpty) return const SizedBox();
    bool show = title == 'Onward Flight' ? true : false;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Text(
        //   title,
        //   style: const TextStyle(
        //       fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
        // ),
        // const SizedBox(height: 10),
        Column(
          children: flights.map((flight) {
            String flightKey = flight["flight_details_id"];

            return Column(
              children: [
                _flightSegment(
                    title,
                    flightKey,
                    flight["flight_name"] ?? "Unknown Airline",
                    flight["dep_time"] ?? "--:--",
                    flight["dep_airport_city"] ?? "Unknown",
                    flight["depart_terminal"] ?? "N/A",
                    flight["flight_duration"] ?? "--h --m",
                    flight["arr_time"] ?? "--:--",
                    flight["arr_airport_city"] ?? "Unknown",
                    flight["arrival_terminal"] ?? "N/A",
                    flight["flight_number"] ?? "",
                    flight["cabin_baggage"] ?? "0",
                    flight["checkin_baggage"] ?? "0",
                    show),
              ],
            );
          }).toList(),
        ),
        const SizedBox(height: 15),
      ],
    );
  }

  Widget _flightSegment(
      String title,
      String flightKey,
      String flightName,
      String depTime,
      String depFrom,
      String depTerminal,
      String duration,
      String arrTime,
      String arrTo,
      String arrTerminal,
      String flightNo,
      String cabinBaggage,
      String checkinBaggage,
      bool show) {
    bool isExpanded = _expandedFlights.contains(flightKey);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: Text(
                flightName,
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87),
              ),
            ),
            Text(
              "Flight No: $flightNo",
              style: const TextStyle(fontSize: 14, color: Colors.black54),
            ),
          ],
        ),
        const SizedBox(height: 10),
        // if (show)
        //   Text(
        //     flightName,
        //     style: const TextStyle(
        //         fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
        //   ),
        // const SizedBox(height: 10),
        Row(
          children: [
            // Left Column (Departure info)
            Container(
              width: MediaQuery.of(context).size.width *
                  0.3, // Set fixed width (30% of screen width)
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    depTime,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                    softWrap: true, // Text will wrap if it's too long
                  ),
                  const SizedBox(height: 4),
                  Text(
                    depFrom,
                    style: const TextStyle(fontSize: 14, color: Colors.black),
                    softWrap: true, // Text will wrap if it's too long
                  ),
                  Text(
                    depTerminal,
                    style: const TextStyle(fontSize: 12, color: Colors.black),
                    softWrap: true, // Text will wrap if it's too long
                  ),
                ],
              ),
            ),

            const Spacer(),

            // Middle Column (Flight Icon and Duration)
            Container(
              width: MediaQuery.of(context).size.width *
                  0.2, // Set fixed width (20% of screen width)
              child: Column(
                children: [
                  Icon(
                    title == "Onward Flight"
                        ? Icons.flight_takeoff
                        : Icons.flight_land_outlined,
                    color: Colors.blueAccent,
                    size: 30,
                  ),
                  Text(
                    duration,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                    softWrap: true, // Text will wrap if it's too long
                  ),
                ],
              ),
            ),

            const Spacer(),

            // Right Column (Arrival info)
            Container(
              width: MediaQuery.of(context).size.width *
                  0.3, // Set fixed width (30% of screen width)
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    arrTime,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                    softWrap: true, // Text will wrap if it's too long
                  ),
                  const SizedBox(height: 4),
                  Text(
                    arrTo,
                    style: const TextStyle(fontSize: 14, color: Colors.black),
                    softWrap: true, // Text will wrap if it's too long
                  ),
                  Text(
                    arrTerminal,
                    style: const TextStyle(fontSize: 12, color: Colors.black),
                    softWrap: true, // Text will wrap if it's too long
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),

        // Additional flight details (baggage info, etc.)
        // if (!show)
        // InkWell(
        //   onTap: () => _toggleExpand(flightKey),
        //   child: Row(
        //     children: [
        //       const Icon(Icons.info_outline,
        //           size: 16, color: Colors.blueAccent),
        //       const SizedBox(width: 5),
        //       Text(
        //         isExpanded ? "Hide Info" : "Show More",
        //         style:
        //             const TextStyle(fontSize: 12, color: Colors.blueAccent),
        //       ),
        //     ],
        //   ),
        // ),
        // AnimatedCrossFade(
        //   firstChild: const SizedBox.shrink(),
        //   secondChild: Column(
        //     crossAxisAlignment: CrossAxisAlignment.start,
        //     children: [
        //       SizedBox(height: 10),
        //       Text("Cabin Baggage: $cabinBaggage kg"),
        //       Text("Check-in Baggage: $checkinBaggage kg"),
        //     ],
        //   ),
        //   crossFadeState:
        //       isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
        //   duration: const Duration(milliseconds: 300),
        // ),
      ],
    );
  }
}

class FlightPackageShimmer extends StatelessWidget {
  const FlightPackageShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 20),
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Onward Flight Title
            const SizedBox(height: 15),
            _shimmerFlightDetails(),
            const Divider(), // Return Flight Title
            const SizedBox(height: 15),
            const SizedBox(height: 15),
            _shimmerButton(),
          ],
        ),
      ),
    );
  }

  Widget _shimmerFlightDetails() {
    return Column(
      children: List.generate(2, (index) {
        return Column(
          children: [
            Row(
              children: [
                _shimmerBox(height: 20, width: 100), // Flight No
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                _shimmerColumn(width: 80), // Departure Details
                const Spacer(),
                const Icon(Icons.flight_takeoff, color: Colors.grey, size: 30),
                const Spacer(),
                _shimmerColumn(width: 80), // Arrival Details
              ],
            ),
            const SizedBox(height: 15),
          ],
        );
      }),
    );
  }

  Widget _shimmerColumn({required double width}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _shimmerBox(height: 18, width: width), // Time
        const SizedBox(height: 5),
        _shimmerBox(height: 14, width: width - 20), // Terminal
      ],
    );
  }

  Widget _shimmerBox({required double height, required double width}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
        ),
      ),
    );
  }

  Widget _shimmerButton() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        height: 45,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
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
    paint.color = Color(0xFF0D939E); // Dark blue
    canvas.drawCircle(Offset(centerX, radius - 600), radius + 400, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
