import 'package:flutter/material.dart';
import 'package:holdidaymakers/pages/FullyIndependentTraveler/booking_summary_fit.dart';
import 'package:holdidaymakers/widgets/responciveButton.dart';

class FlightPage extends StatefulWidget {
  final Map<String, dynamic> responceData;
  final Map<String, dynamic> selectedHotel;
  final List<Map<String, dynamic>> roomArray;

  const FlightPage({
    super.key,
    required this.responceData,
    required this.selectedHotel,
    required this.roomArray,
  });

  @override
  State<FlightPage> createState() => _FlightPageState();
}

class _FlightPageState extends State<FlightPage> {
  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> flightOptions =
    (widget.responceData["group_by_flight_details"] is Map<String, dynamic>)
        ? widget.responceData["group_by_flight_details"]
        : {};

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        title: const Text(
          "Select Your Flight Package",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
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

            return FlightCard(
              optionKey: optionKey,
              onwardFlights: onwardFlights,
              returnFlights: returnFlights,
              responceData: widget.responceData,
              selectedHotel: widget.selectedHotel,
              roomArray: widget.roomArray,
            );
          }).toList(),
        ),
      ),
    );
  }
}

class FlightCard extends StatelessWidget {
  final String optionKey;
  final List<Map<String, dynamic>> onwardFlights;
  final List<Map<String, dynamic>> returnFlights;
  final Map<String, dynamic> responceData;
  final Map<String, dynamic> selectedHotel;
  final List<Map<String, dynamic>> roomArray;

  const FlightCard({
    super.key,
    required this.optionKey,
    required this.onwardFlights,
    required this.returnFlights,
    required this.responceData,
    required this.selectedHotel,
    required this.roomArray,
  });

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
            _flightSection("Onward Flight", onwardFlights),
            _flightSection("Return Flight", returnFlights),
            const SizedBox(height: 15),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BookingSummaryFIT(
                        responceData: responceData,
                        selectedHotel: selectedHotel,
                        roomArray: roomArray,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text(
                  "Select Flight Package",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
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
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        const SizedBox(height: 10),
        ...flights.map((flight) {
          return Column(
            children: [
              _flightSegment(
                flight["airline_name"] ?? "Unknown Airline",
                flight["dep_time"] ?? "--:--",
                flight["from_airport_name"] ?? "Unknown",
                flight["flight_duration"] ?? "--h --m",
                flight["arr_time"] ?? "--:--",
                flight["to_airport_name"] ?? "Unknown",
              ),
              if (flights.length > 1 && flight != flights.last)
                const Divider(),
            ],
          );
        }).toList(),
        const SizedBox(height: 15),
      ],
    );
  }

  Widget _flightSegment(
      String flightName, String depTime, String depFrom, String duration, String arrTime, String arrTo) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(flightName, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            Text("$depFrom → $arrTo", style: const TextStyle(fontSize: 14, color: Colors.grey)),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text("$depTime - $arrTime", style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            Text(duration, style: const TextStyle(fontSize: 14, color: Colors.grey)),
          ],
        ),
      ],
    );
  }
}
