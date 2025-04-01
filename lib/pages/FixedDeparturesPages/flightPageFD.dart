import 'package:flutter/material.dart';
import 'package:HolidayMakers/pages/FixedDeparturesPages/add_tour_fd.dart';
import 'package:HolidayMakers/utils/api_handler.dart';
import 'package:HolidayMakers/widgets/responciveButton.dart';
import 'package:shimmer/shimmer.dart';

class FlightPageFD extends StatefulWidget {
  final List<dynamic> activityList;
  final Map<String, dynamic> packageData;
  final Map<String, dynamic> selectedHotel;
  // final List<Map<String, dynamic>> flightList;
  final String searchId;
  final List<dynamic> totalRoomsdata;

  const FlightPageFD(
      {super.key,
      required this.searchId,
      required this.packageData,
      required this.selectedHotel,
      // required this.flightList,
      required this.totalRoomsdata,
      required this.activityList});

  @override
  State<FlightPageFD> createState() => _FlightPageFDState();
}

class _FlightPageFDState extends State<FlightPageFD> {
  List<Map<String, dynamic>> flightList = [];
  List<Map<String, dynamic>> selectedFlightPackage = [];

  bool isLoading = true;
  @override
  void initState() {
    super.initState();

    // print(widget.searchId);
    // print(widget.selectedHotel['git_adhoc_hotel_id']);
    _fetchFDFlightDetails();
  }

  Future<void> _fetchFDFlightDetails() async {
    Map<dynamic, dynamic> body = {
      "search_id": widget.searchId,
      "hotel_id": widget.selectedHotel['git_adhoc_hotel_id']
    };
    try {
      final response = await APIHandler.getFDFlightDetails(body);

      // Introduce a delay before setting the state
      await Future.delayed(Duration(seconds: 2));

      setState(() {
        flightList = (response['data']['group_by_flight_details'] as List)
            .map((e) => e as Map<String, dynamic>)
            .toList();

        isLoading = false;
      });
    } catch (e) {
      print("Error fetching package cards: $e");
    }
  }

  // called when clicked on Book Now button
  Future<void> _updateFlightDetails(String search_id, String flight_id) async {
    Map<dynamic, dynamic> body = {
      'search_id': search_id,
      'flight_id': flight_id
    };
    try {
      final response = await APIHandler.updateFlightDetails(body);
      print(response);
    } catch (e) {
      print("Error occurred while updating flight details: $e");
    }
  }

  Widget _buildTopCurve() {
    return Padding(
      padding: const EdgeInsets.only(top: 30), // 20% of the screen height
      child: CustomPaint(
        size: Size(double.infinity, 0), // Height of the curved area
        painter: CirclePainter(radius: 200),
      ),
    );
  }

  int selectedFlightIndex = 0;
  @override
  Widget build(BuildContext context) {
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
      //     "Select Your Flight Package",
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
            child: isLoading == true
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
                : flightList.isEmpty
                    ? const Center(
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
                        )
                    : Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: ListView.builder(
                          itemCount: flightList.length,
                          itemBuilder: (context, index) {
                            final flightData = flightList[index];

                            return FlightPackageCard(
                              optionKey: flightData[
                                  "option_type"], // "Option_1", "Option_2"
                              amount: flightData["total"].toString(),
                              onwardFlights: List<Map<String, dynamic>>.from(
                                  flightData["Onward"] ?? []),
                              returnFlights: List<Map<String, dynamic>>.from(
                                  flightData["Return"] ?? []),

                              isSelected: selectedFlightIndex == index,
                              onTap: () {
                                setState(() {
                                  selectedFlightIndex = index;
                                });
                              },
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),

      bottomNavigationBar: isLoading
          ? null
          : flightList.isEmpty? SizedBox(): Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: GestureDetector(
                onTap: () {
                  if (flightList.isNotEmpty) {
                    selectedFlightPackage = [
                      ...flightList[selectedFlightIndex]
                          ["Onward"], // Add all onward flights
                      ...flightList[selectedFlightIndex]
                          ["Return"] // Add all return flights
                    ];

                    String searchId = widget.searchId;
                    String flightId =
                        '${selectedFlightPackage[0]['flight_details_id']}_${selectedFlightPackage[1]['flight_details_id']}';

                    // print('########################################################');
                    // print(search_id);
                    // print(search_id.runtimeType);
                    // print(flight_id);
                    // print(flight_id.runtimeType);
                    // print('########################################################');
                    _updateFlightDetails(searchId, flightId);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TourBookingPage(
                            flightDetails: selectedFlightPackage,
                            selectedHotel: widget.selectedHotel,
                            packageDetails: widget.packageData,
                            totalRoomsdata: widget.totalRoomsdata,
                            searchId: widget.searchId,
                            fixedActivities: widget.activityList),
                      ),
                    );
                  }
                },
                child:  Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: responciveButton(text: "Book Now"),
                ),
              ),
            ),
    );
  }
}

class FlightPackageCard extends StatefulWidget {
  final String optionKey;
  final String amount;
  final List<Map<String, dynamic>> onwardFlights;
  final List<Map<String, dynamic>> returnFlights;

  final bool isSelected;
  final VoidCallback onTap; // Add this

  const FlightPackageCard({
    super.key,
    required this.optionKey,
    required this.amount,
    required this.onwardFlights,
    required this.returnFlights,
    required this.isSelected,
    required this.onTap,
  });

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
    print(widget.onwardFlights);
    return GestureDetector(
     onTap: widget.onTap,
     child: Card(
      // color: Colors.grey.shade300,
      color: Color(0xFFEEEEEE),
      margin: const EdgeInsets.only(bottom: 20),
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align( alignment: Alignment.bottomRight,
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
            
            _flightSection("Onward Flight", widget.onwardFlights),
            // Divider(),
            _flightSection("Return Flight", widget.returnFlights),
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
                      "AED ${widget.amount}",
                      style: TextStyle(
                        color: Color(0xFF0071BC),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(width: 8),
                    
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
        // const SizedBox(height: 10),
        Column(
          children: flights.map((flight) {
            String flightKey = flight["flight_details_id"];

            return Column(
              children: [
                _flightSegment(
                    title,
                    flightKey,
                    flight["airline_name"] ?? "Unknown Airline",
                    flight["dep_time"] ?? "--:--",
                    flight["from_airport_name"] ?? "Unknown",
                    flight["depart_terminal"] ?? "N/A",
                    flight["flight_duration"] ?? "--h --m",
                    flight["arr_time"] ?? "--:--",
                    flight["to_airport_name"] ?? "Unknown",
                    flight["arrival_terminal"] ?? "N/A",
                    flight["flight_no"] ?? "",
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
        // const SizedBox(height: 10),
        // if (show)
        //   Text(
        //     flightName,
        //     style: const TextStyle(
        //       fontSize: 20,
        //       fontWeight: FontWeight.bold,
        //       color: Colors.black,
        //     ),
        //   ),
        const SizedBox(height: 10),
        Row(
          children: [
            // Left Column (Departure info)
            Container(
              width: MediaQuery.of(context).size.width * 0.3, // Set fixed width (30% of screen width)
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    depTime,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    softWrap: true, // Text will wrap if it's too long
                  ),
                  const SizedBox(height: 4),
                  Text(
                    depFrom,
                    style: const TextStyle(fontSize: 14, color: Colors.black),
                    softWrap: true,
                  ),
                  Text(
                    depTerminal,
                    style: const TextStyle(fontSize: 12, color: Colors.black),
                    softWrap: true,
                  ),
                ],
              ),
            ),

            const Spacer(),

            // Middle Column (Flight Icon and Duration)
            Container(
              width: MediaQuery.of(context).size.width * 0.2, // Set fixed width (20% of screen width)
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
                    softWrap: true,
                  ),
                ],
              ),
            ),

            const Spacer(),

            // Right Column (Arrival info)
            Container(
              width: MediaQuery.of(context).size.width * 0.3, // Set fixed width (30% of screen width)
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    arrTime,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    softWrap: true,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    arrTo,
                    style: const TextStyle(fontSize: 14, color: Colors.black),
                    softWrap: true,
                  ),
                  Text(
                    arrTerminal,
                    style: const TextStyle(fontSize: 12, color: Colors.black),
                    softWrap: true,
                  ),
                ],
              ),
            ),
          ],
        ),

        // Additional flight details (baggage info, etc.)
        // if (!show) const SizedBox(height: 8),

        // if (!show)
        InkWell(
          onTap: () => _toggleExpand(flightKey),
          child: Row(
            children: [
              const Icon(Icons.info_outline,
                  size: 16, color: Colors.blueAccent),
              const SizedBox(width: 5),
              Text(
                isExpanded ? "Hide Info" : "Show More",
                style:
                    const TextStyle(fontSize: 12, color: Colors.blueAccent),
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
              Text("Cabin Baggage: $cabinBaggage kg"),
              Text("Check-in Baggage: $checkinBaggage kg"),
            ],
          ),
          crossFadeState:
              isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 300),
        ),
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
