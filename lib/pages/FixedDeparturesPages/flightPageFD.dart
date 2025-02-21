import 'package:flutter/material.dart';
import 'package:holdidaymakers/pages/FixedDeparturesPages/booking_summary_fd.dart';
import 'package:holdidaymakers/utils/api_handler.dart';
import 'package:holdidaymakers/widgets/appLargetext.dart';
import 'package:holdidaymakers/widgets/responciveButton.dart';
import 'package:shimmer/shimmer.dart';

class FlightPageFD extends StatefulWidget {
  final Map<String, dynamic> packageData;
  final Map<String, dynamic> selectedHotel;
  // final List<Map<String, dynamic>> flightList;
  String searchId;
  final List<dynamic> totalRoomsdata;

  FlightPageFD({
    super.key,
    required this.searchId,
    required this.packageData,
    required this.selectedHotel,
    // required this.flightList,
    required this.totalRoomsdata,
  });

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
                .toList() ??
            [];
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

  int selectedFlightIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back, color: Colors.black),
        ),
        title: const Text(
          "Select Your Flight Package",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading == true
            ? SingleChildScrollView(
                child: Column(
                  children: [FlightPackageShimmer(), FlightPackageShimmer()],
                ),
              )
            : flightList.isEmpty
                ? const Center(
                    child: Text(
                      "Flights not available",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54),
                    ),
                  )
                : ListView.builder(
                    itemCount: flightList.length,
                    itemBuilder: (context, index) {
                      final flightData = flightList[index];

                      return FlightPackageCard(
                        optionKey:
                            flightData["option_type"], // "Option_1", "Option_2"
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
      // body: Container(
      //   color: Colors.white, // Set background color to white
      //   child: Padding(
      //     padding: const EdgeInsets.all(16.0),
      //     child: widget.flightList.isEmpty
      //         ? const Center(
      //       child: Text(
      //         "Flights not available",
      //         style: TextStyle(
      //             fontSize: 18,
      //             fontWeight: FontWeight.bold,
      //             color: Colors.black54),
      //       ),
      //     )
      //         : ListView.builder(
      //       itemCount: widget.flightList.length,
      //       itemBuilder: (context, index) {
      //         final flightData = widget.flightList[index];
      //
      //         return FlightPackageCard(
      //           optionKey:
      //           flightData["option_type"], // "Option_1", "Option_2"
      //           onwardFlights: List<Map<String, dynamic>>.from(
      //               flightData["Onward"] ?? []),
      //           returnFlights: List<Map<String, dynamic>>.from(
      //               flightData["Return"] ?? []),
      //           isSelected: selectedFlightIndex == index,
      //           onTap: () {
      //             setState(() {
      //               selectedFlightIndex = index;
      //             });
      //           },
      //         );
      //       },
      //     ),
      //   ),
      // ),

      bottomNavigationBar: Padding(
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

              String search_id = widget.searchId;
              String flight_id =
                  '${selectedFlightPackage[0]['flight_details_id']}_${selectedFlightPackage[1]['flight_details_id']}';

              // print('########################################################');
              // print(search_id);
              // print(search_id.runtimeType);
              // print(flight_id);
              // print(flight_id.runtimeType);
              // print('########################################################');
              _updateFlightDetails(search_id, flight_id);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BookingSummaryFD(
                      flightDetails: selectedFlightPackage,
                      selectedHotel: widget.selectedHotel,
                      packageDetails: widget.packageData,
                      totalRoomsdata: widget.totalRoomsdata,
                      searchId: widget.searchId),
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
  final String optionKey;
  final List<Map<String, dynamic>> onwardFlights;
  final List<Map<String, dynamic>> returnFlights;
  final bool isSelected;
  final VoidCallback onTap; // Add this

  const FlightPackageCard({
    super.key,
    required this.optionKey,
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

  void _selectFlight(String flightKey, bool isOnward) {
    setState(() {
      if (isOnward) {
        selectedOnwardFlight = flightKey;
      } else {
        selectedReturnFlight = flightKey;
      }
    });
  }

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
            _flightSection("Onward Flight", widget.onwardFlights),
            Divider(),
            _flightSection("Return Flight", widget.returnFlights),
            const SizedBox(height: 15),
            Align(
              alignment: Alignment.center,
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: widget.onTap,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        widget.isSelected ? Colors.red : Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    side: BorderSide(
                        color: Colors.red), // Add a border for visibility
                  ),
                  child: Text(
                    widget.isSelected ? 'SELECTED' : 'SELECT',
                    style: TextStyle(
                      color: widget.isSelected
                          ? Colors.white
                          : Colors.red, // Fix text color
                      fontSize: 16.0, // Set proper font size
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _flightSection(String title, List<Map<String, dynamic>> flights) {
    if (flights.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        const SizedBox(height: 10),
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
                ),
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
  ) {
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
                    fontSize: 14,
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

        Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(depTime,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(depFrom,
                    style: const TextStyle(fontSize: 14, color: Colors.black)),
                Text(depTerminal,
                    style: const TextStyle(fontSize: 12, color: Colors.black)),
              ],
            ),
            const Spacer(),
            Column(
              children: [
                 Icon(
                    title == "Onward Flight"
                        ? Icons.flight_takeoff
                        : Icons.flight_land_outlined,
                    color: Colors.blueAccent,
                    size: 30),
                Text(duration,
                    style: const TextStyle(fontSize: 14, color: Colors.grey)),
              ],
            ),
            const Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(arrTime,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(arrTo,
                    style: const TextStyle(fontSize: 14, color: Colors.black)),
                Text(arrTerminal,
                    style: const TextStyle(fontSize: 12, color: Colors.black)),
              ],
            ),
          ],
        ),
        const SizedBox(height: 8),

        // Additional flight details (baggage info, etc.)
        InkWell(
          onTap: () => _toggleExpand(flightKey),
          child: Row(
            children: [
              const Icon(Icons.info_outline,
                  size: 16, color: Colors.blueAccent),
              const SizedBox(width: 5),
              Text(
                isExpanded ? "Hide Info" : "Show More",
                style: const TextStyle(fontSize: 12, color: Colors.blueAccent),
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
          children: [ // Onward Flight Title
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
