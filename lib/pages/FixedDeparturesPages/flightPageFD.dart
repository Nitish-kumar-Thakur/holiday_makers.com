import 'package:flutter/material.dart';
import 'package:holdidaymakers/pages/FixedDeparturesPages/booking_summary_fd.dart';
import 'package:holdidaymakers/widgets/responciveButton.dart';

class FlightPageFD extends StatelessWidget {
  final Map<String, dynamic> respponceData;
  final Map<String, dynamic> selectedHotel;
  final List<Map<String, dynamic>> flightList;

  const FlightPageFD({
    super.key,
    required this.respponceData,
    required this.selectedHotel,
    required this.flightList,
  });

  @override
  Widget build(BuildContext context) {
    // List<Map<String, dynamic>> flightList = [
    //     {
    //       "option_type": "Option_1",
    //       "Onward": [
    //         {
    //           "flight_details_id": "591",
    //           "flight_option": "Option_1",
    //           "flight": "PQ123",
    //           "dep_from": "DMB",
    //           "arr_to": "IST",
    //           "travel_date": "2024-12-02",
    //           "dep_time": "08:30",
    //           "arr_time": "11:30",
    //           "flight_duration": "3:00",
    //           "package_id": "79",
    //           "depart_terminal": "Terminal 1",
    //           "arrival_terminal": "Terminal 2",
    //           "flight_no": "58967",
    //           "cabin_baggage": "7",
    //           "checkin_baggage": "15",
    //           "flight_type": "Onward",
    //           "airline_name": "Airline A",
    //           "from_airport_name": "Dzhambyl",
    //           "to_airport_name": "Istanbul"
    //         },
    //         {
    //           "flight_details_id": "592",
    //           "flight_option": "Option_1",
    //           "flight": "PQ125",
    //           "dep_from": "IST",
    //           "arr_to": "DXB",
    //           "travel_date": "2024-12-02",
    //           "dep_time": "13:00",
    //           "arr_time": "16:30",
    //           "flight_duration": "3:30",
    //           "package_id": "79",
    //           "depart_terminal": "Terminal 2",
    //           "arrival_terminal": "Terminal 3",
    //           "flight_no": "58968",
    //           "cabin_baggage": "7",
    //           "checkin_baggage": "15",
    //           "flight_type": "Onward",
    //           "airline_name": "Airline B",
    //           "from_airport_name": "Istanbul",
    //           "to_airport_name": "Dubai"
    //         }
    //       ],
    //       "Return": [
    //         {
    //           "flight_details_id": "577",
    //           "flight_option": "Option_1",
    //           "flight": "PQ126",
    //           "dep_from": "DXB",
    //           "arr_to": "IST",
    //           "travel_date": "2024-12-10",
    //           "dep_time": "01:30",
    //           "arr_time": "04:30",
    //           "flight_duration": "3:00",
    //           "package_id": "79",
    //           "depart_terminal": "Terminal 3",
    //           "arrival_terminal": "Terminal 2",
    //           "flight_no": "58969",
    //           "cabin_baggage": "7",
    //           "checkin_baggage": "15",
    //           "flight_type": "Return",
    //           "airline_name": "Airline A",
    //           "from_airport_name": "Dubai",
    //           "to_airport_name": "Istanbul"
    //         },
    //         {
    //           "flight_details_id": "578",
    //           "flight_option": "Option_1",
    //           "flight": "PQ127",
    //           "dep_from": "IST",
    //           "arr_to": "DMB",
    //           "travel_date": "2024-12-10",
    //           "dep_time": "07:00",
    //           "arr_time": "10:00",
    //           "flight_duration": "3:00",
    //           "package_id": "79",
    //           "depart_terminal": "Terminal 2",
    //           "arrival_terminal": "Terminal 1",
    //           "flight_no": "58970",
    //           "cabin_baggage": "7",
    //           "checkin_baggage": "15",
    //           "flight_type": "Return",
    //           "airline_name": "Airline B",
    //           "from_airport_name": "Istanbul",
    //           "to_airport_name": "Dzhambyl"
    //         }
    //       ],
    //       "total": 500
    //     },
    //     {
    //       "option_type": "Option_2",
    //       "Onward": [
    //         {
    //           "flight_details_id": "593",
    //           "flight_option": "Option_2",
    //           "flight": "PQ128",
    //           "dep_from": "DMB",
    //           "arr_to": "DXB",
    //           "travel_date": "2024-12-01",
    //           "dep_time": "08:30",
    //           "arr_time": "11:30",
    //           "flight_duration": "3:00",
    //           "package_id": "80",
    //           "depart_terminal": "Terminal 1",
    //           "arrival_terminal": "Terminal 1",
    //           "flight_no": "58971",
    //           "cabin_baggage": "7",
    //           "checkin_baggage": "15",
    //           "flight_type": "Onward",
    //           "airline_name": "Airline C",
    //           "from_airport_name": "Dzhambyl",
    //           "to_airport_name": "Dubai"
    //         }
    //       ],
    //       "Return": [
    //         {
    //           "flight_details_id": "579",
    //           "flight_option": "Option_2",
    //           "flight": "PQ129",
    //           "dep_from": "DXB",
    //           "arr_to": "DMB",
    //           "travel_date": "2024-12-05",
    //           "dep_time": "04:30",
    //           "arr_time": "07:30",
    //           "flight_duration": "3:00",
    //           "package_id": "80",
    //           "depart_terminal": "Terminal 1",
    //           "arrival_terminal": "Terminal 1",
    //           "flight_no": "58972",
    //           "cabin_baggage": "7",
    //           "checkin_baggage": "15",
    //           "flight_type": "Return",
    //           "airline_name": "Airline C",
    //           "from_airport_name": "Dubai",
    //           "to_airport_name": "Dzhambyl"
    //         }
    //       ],
    //       "total": 450
    //     }
    //   ];

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
        child: flightList.isEmpty
            ? const Center(
          child: Text(
            "Flights not available",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black54),
          ),
        )
            : ListView(
          children: flightList.map((flightData) {
            return FlightPackageCard(
              optionKey: flightData["option_type"], // "Option_1", "Option_2"
              onwardFlights: List<Map<String, dynamic>>.from(flightData["Onward"] ?? []),
              returnFlights: List<Map<String, dynamic>>.from(flightData["Return"] ?? []),
            );
          }).toList(),
        ),
      ),

    );
  }
}

class FlightPackageCard extends StatefulWidget {
  final String optionKey;
  final List<Map<String, dynamic>> onwardFlights;
  final List<Map<String, dynamic>> returnFlights;

  const FlightPackageCard({
    super.key,
    required this.optionKey,
    required this.onwardFlights,
    required this.returnFlights,
  });

  @override
  _FlightPackageCardState createState() => _FlightPackageCardState();
}

class _FlightPackageCardState extends State<FlightPackageCard> {
  final Set<String> _expandedFlights = {}; // Tracks which flight details are expanded

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
            // SizedBox(
            //   width: double.infinity,
            //   child: ElevatedButton(
            //     onPressed: () {},
            //     style: ElevatedButton.styleFrom(
            //       backgroundColor: Colors.blueAccent,
            //       shape: RoundedRectangleBorder(
            //           borderRadius: BorderRadius.circular(10)),
            //       padding: const EdgeInsets.symmetric(vertical: 12),
            //     ),
            //     child: const Text(
            //       "Select Flight Package",
            //       style: TextStyle(
            //           fontSize: 16,
            //           fontWeight: FontWeight.bold,
            //           color: Colors.white),
            //     ),
            //   ),
            // ),
            Align(
              alignment: Alignment.center,
              child: IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                BookingSummaryFD()));
                  },
                  icon: responciveButton(text: 'SELECT')),
            )
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
            String flightKey = "${flight["flight_no"]}_${flight["dep_time"]}";

            return Column(
              children: [
                _flightSegment(
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
                // const Divider(thickness: 1), // Separator for multiple flights
              ],
            );
          }).toList(),
        ),
        const SizedBox(height: 15),
      ],
    );
  }

  Widget _flightSegment(
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
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
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
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
                const Icon(Icons.flight_takeoff, color: Colors.blueAccent, size: 30),
                Text(duration, style: const TextStyle(fontSize: 14, color: Colors.grey)),
              ],
            ),
            const Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(arrTime,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
              const Icon(Icons.info_outline, size: 16, color: Colors.blueAccent),
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
