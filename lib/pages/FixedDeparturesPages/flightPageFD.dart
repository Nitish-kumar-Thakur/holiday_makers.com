import 'package:flutter/material.dart';
import 'package:holdidaymakers/pages/Cruise/booking_summary.dart';
import 'package:holdidaymakers/widgets/responciveButton.dart';

class FlightPageFD extends StatelessWidget {
  final Map<String, dynamic> respponceData;
  final Map<String, dynamic> selectedHotel;

  const FlightPageFD({
    super.key,
    required this.respponceData,
    required this.selectedHotel,
  });

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> flightOptions =
    (respponceData["group_by_flight_details"] is Map<String, dynamic>)
        ? respponceData["group_by_flight_details"]
        : {};

    // Map<String, dynamic> flightOptions = {
    // "Option_1": {
    // "Onward": [
    // {
    // "flight_details_id": "521",
    // "flight_option": "Option_1",
    // "enquiry_id": "0",
    // "hub_id": "0",
    // "flight": "TK",
    // "dep_from": "DXB",
    // "arr_to": "IST",
    // "pax_count": "0",
    // "travel_date": "2025-01-23",
    // "dep_time": "09:15",
    // "arr_time": "14:20",
    // "flight_duration": "5:5",
    // "package_id": "75",
    // "depart_terminal": "Terminal 2",
    // "arrival_terminal": "Terminal 1",
    // "flight_no": "7584",
    // "cabin_baggage": "10",
    // "checkin_baggage": "20",
    // "flight_type": "Onward",
    // "total_available_seat": "20",
    // "airline_name": "TURKISH AIRLINES",
    // "from_airport_name": "Dubai",
    // "to_airport_name": "Istanbul"
    // },
    // {
    // "flight_details_id": "522",
    // "flight_option": "Option_1",
    // "enquiry_id": "0",
    // "hub_id": "0",
    // "flight": "TK",
    // "dep_from": "IST ",
    // "arr_to": "CDG",
    // "pax_count": "0",
    // "travel_date": "2025-01-23",
    // "dep_time": "17:45",
    // "arr_time": "21:10",
    // "flight_duration": "3:45",
    // "package_id": "75",
    // "depart_terminal": "Terminal 1",
    // "arrival_terminal": "Terminal 2",
    // "flight_no": "5448",
    // "cabin_baggage": "10",
    // "checkin_baggage": "20",
    // "flight_type": "Onward",
    // "total_available_seat": "0",
    // "airline_name": "TURKISH AIRLINES",
    // "from_airport_name": "Istanbul",
    // "to_airport_name": "Paris"
    // }
    // ],
    // "Return": [
    // {
    // "flight_details_id": "523",
    // "flight_option": "Option_1",
    // "enquiry_id": "0",
    // "hub_id": "0",
    // "flight": "TK",
    // "dep_from": "CDG",
    // "arr_to": "IST",
    // "pax_count": "0",
    // "travel_date": "2025-01-28",
    // "dep_time": "13:20",
    // "arr_time": "16:05",
    // "flight_duration": "3:45",
    // "package_id": "75",
    // "depart_terminal": "Terminal 1",
    // "arrival_terminal": "Terminal 2",
    // "flight_no": "5499",
    // "cabin_baggage": "10",
    // "checkin_baggage": "20",
    // "flight_type": "Return",
    // "total_available_seat": "0",
    // "airline_name": "TURKISH AIRLINES",
    // "from_airport_name": "Paris",
    // "to_airport_name": "Istanbul"
    // },
    // {
    // "flight_details_id": "524",
    // "flight_option": "Option_1",
    // "enquiry_id": "0",
    // "hub_id": "0",
    // "flight": "TK",
    // "dep_from": "IST ",
    // "arr_to": "DXB",
    // "pax_count": "0",
    // "travel_date": "2025-01-28",
    // "dep_time": "20:30",
    // "arr_time": "1:35",
    // "flight_duration": "5:5",
    // "package_id": "75",
    // "depart_terminal": "Terminal 1",
    // "arrival_terminal": "Terminal 2",
    // "flight_no": "7589",
    // "cabin_baggage": "10",
    // "checkin_baggage": "20",
    // "flight_type": "Return",
    // "total_available_seat": "20",
    // "airline_name": "TURKISH AIRLINES",
    // "from_airport_name": "Istanbul",
    // "to_airport_name": "Dubai"
    // }
    // ]
    // }
    // };

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
        child: flightOptions.isEmpty
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
          children: flightOptions.entries.map((entry) {
            String optionKey = entry.key;
            Map<String, dynamic> flights = entry.value;

            List<Map<String, dynamic>> onwardFlights =
            (flights["Onward"] is List)
                ? (flights["Onward"] as List)
                .whereType<Map<String, dynamic>>()
                .toList()
                : [];

            List<Map<String, dynamic>> returnFlights =
            (flights["Return"] is List)
                ? (flights["Return"] as List)
                .whereType<Map<String, dynamic>>()
                .toList()
                : [];

            return FlightPackageCard(
              optionKey: optionKey,
              onwardFlights: onwardFlights,
              returnFlights: returnFlights,
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
                                BookingSummaryPage()));
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
        ...flights.map((flight) {
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
            ],
          );
        }).toList(),
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
            Text(
              flightName,
              style: const TextStyle(
                  fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            const Spacer(),
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
                const Icon(Icons.flight_takeoff,
                    color: Colors.blueAccent, size: 30),
                Text(duration, style: const TextStyle(fontSize: 14, color: Colors.grey)),
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
