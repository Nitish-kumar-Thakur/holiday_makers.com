import 'package:flutter/material.dart';
import 'package:holdidaymakers/pages/FullyIndependentTraveler/booking_summary_fit.dart';
import 'package:holdidaymakers/utils/api_handler.dart';
import 'package:holdidaymakers/widgets/responciveButton.dart';
import 'dart:collection';

import 'package:shimmer/shimmer.dart';

class FlightPageFIT extends StatefulWidget {
  final Map<dynamic, dynamic>? responceData;
  final Map<dynamic, dynamic>? hotel;
  final List<dynamic> roomArray;

  const FlightPageFIT(
      {super.key,
      required this.hotel,
      required this.responceData,
      required this.roomArray});

  @override
  State<FlightPageFIT> createState() => _FlightPageFITState();
}

class _FlightPageFITState extends State<FlightPageFIT> {
  Map<dynamic, dynamic>? flightList;
  bool isLoading = true;
  int selectedFlightIndex = 0;
  @override
  void initState() {
    // TODO: implement initState
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
          "${selectedFlightPackage["onward"][0]["flight_fare_id"]}_${selectedFlightPackage["return"][0]["flight_fare_id"]}"
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
        builder: (context) => BookingSummaryFIT(
            searchId: (widget.responceData?["data"]["search_id"]).toString(),
            roomArray: widget.roomArray),
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

  @override
  Widget build(BuildContext context) {
    Map<String, Map<String, dynamic>> groupedFlights = _groupFlightsByName();

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
        child: isLoading
            ? SingleChildScrollView(
                child: Column(
                  children: [FlightPackageShimmer(), FlightPackageShimmer()],
                ),
              )
            :groupedFlights.isEmpty
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
                itemCount: groupedFlights.length,
                itemBuilder: (context, index) {
                  String flightName = groupedFlights.keys.elementAt(index);
                  Map<String, dynamic> flightData = groupedFlights[flightName]!;

                  return FlightPackageCard(
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
                  );
                },
              ),
      ),
      bottomNavigationBar: isLoading?null: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child:  GestureDetector(
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
  final bool isSelected;
  final VoidCallback onTap; // Add this

  const FlightPackageCard({
    super.key,
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

