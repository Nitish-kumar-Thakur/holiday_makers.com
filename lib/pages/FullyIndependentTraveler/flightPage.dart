import 'package:flutter/material.dart';
import 'package:holdidaymakers/pages/FullyIndependentTraveler/booking_summary_fit.dart';

class FlightPage extends StatefulWidget {
  final Map<String, dynamic> responceData;
  final Map<String, dynamic> selectedHotel;
  final List<Map<String, dynamic>> roomArray;
  const FlightPage(
      {super.key, required this.responceData, required this.selectedHotel, required this.roomArray});

  @override
  State<FlightPage> createState() => _FlightPageState();
}

class _FlightPageState extends State<FlightPage> {
  // Map<String,dynamic> onboardFlight = Widget.respnce
  DateTime selectedDate = DateTime.now();
  static const int maxDays = 7;

  List<Flight> getFilteredFlights() {
    return flights
        .where((flight) => isSameDate(flight.flightDate, selectedDate))
        .toList();
  }

  bool isSameDate(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  @override
  Widget build(BuildContext context) {
    DateTime today = DateTime.now();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text(
          "Select Your Flight",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        // actions: [
        //   IconButton(
        //     onPressed: () {
        //       // Add filter logic here
        //     },
        //     icon: const Icon(Icons.filter_list),
        //   ),
        // ],
      ),
      body: Column(
        children: [
          // Date Selection Section
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 16), // Added padding
          //   child: Container(
          //     height: 60,
          //     decoration: BoxDecoration(
          //       borderRadius: BorderRadius.circular(10),
          //       color: Colors.white,
          //     ),
          //     child: Row(
          //       children: [
          //         Expanded(
          //           child: ListView.builder(
          //             scrollDirection: Axis.horizontal,
          //             physics: const BouncingScrollPhysics(),
          //             itemCount: maxDays,
          //             itemBuilder: (context, index) {
          //               DateTime date = today.add(Duration(days: index));
          //               bool isToday = isSameDate(date, today);
          //               return GestureDetector(
          //                 onTap: () {
          //                   setState(() {
          //                     selectedDate = date;
          //                   });
          //                 },
          //                 child: Container(
          //                   margin: const EdgeInsets.symmetric(horizontal: 8),
          //                   padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
          //
          //                   child: Column(
          //                     mainAxisAlignment: MainAxisAlignment.center,
          //                     children: [
          //                       Text(
          //                         isToday
          //                             ? "Today"
          //                             : "${date.day} ${_getMonthName(date.month)}",
          //                         style: TextStyle(
          //                           color: isSameDate(date, selectedDate)
          //                               ? Colors.blueAccent
          //                               : Colors.grey,
          //                           fontWeight: FontWeight.bold,
          //                           fontSize: 12,
          //                         ),
          //                       ),
          //                       Text(
          //                         "\$${1000 + (index * 20)}",
          //                         style: TextStyle(
          //                           color: isSameDate(date, selectedDate)
          //                               ? Colors.blueAccent
          //                               : Colors.grey,
          //                           fontSize: 12,
          //                         ),
          //                       ),
          //                     ],
          //                   ),
          //                 ),
          //               );
          //             },
          //           ),
          //         ),
          //         Container(
          //           height: 50,
          //           width: 50,
          //           decoration: const BoxDecoration(
          //             color: Colors.orangeAccent,
          //             borderRadius: BorderRadius.only(
          //               topRight: Radius.circular(5),
          //               bottomRight: Radius.circular(5),
          //             ),
          //           ),
          //           child: const Icon(
          //             Icons.calendar_month,
          //             size: 24,
          //             color: Colors.white,
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: getFilteredFlights().length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    // print(widget.responceData);
                    // print(widget.selectedHotel);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BookingSummaryFIT(responceData: widget.responceData, selectedHotel: widget.selectedHotel, roomArray: widget.roomArray,)));
                  },
                  child: FlightCard(onboardFlight: widget.responceData["data"]["flight"]["onward"], returnFlight: widget.responceData["data"]["flight"]["return"],),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class Flight {
  final String airline;
  final String from;
  final String to;
  final String departureTime;
  final String arrivalTime;
  final String duration;
  final String stops;
  final int price;
  final DateTime flightDate;
  final String depart_terminal;
  final String arrival_terminal;

  Flight({
    required this.airline,
    required this.from,
    required this.to,
    required this.departureTime,
    required this.arrivalTime,
    required this.duration,
    required this.stops,
    required this.price,
    required this.flightDate,
    required this.arrival_terminal,
    required this.depart_terminal,
  });
}

class FlightCard extends StatefulWidget {
 final Map<String, dynamic> onboardFlight;
 final Map<String, dynamic> returnFlight;
  const FlightCard({super.key, required this.onboardFlight, required this.returnFlight});

  @override
  _FlightCardState createState() => _FlightCardState();
}

class _FlightCardState extends State<FlightCard> {
  bool isExpanded = false; // Track if the card is expanded

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Airline and Price Section
            Row(
              children: [
                Text(
                  widget.onboardFlight["flight_name"],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Text(
                  "\$${widget.onboardFlight["Adult_Fare"]}",
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.redAccent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Departure, Duration, Arrival Section
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.onboardFlight["dep_time"]),
                    const SizedBox(height: 4),
                    Text(
                      widget.onboardFlight["dep_from"],
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(widget.onboardFlight["depart_terminal"])
                  ],
                ),
                const Spacer(),
                Column(
                  children: [
                    Transform.rotate(
                      angle: 1.5708, // 90 degrees in radians
                      child: const Icon(Icons.flight, color: Colors.blueAccent),
                    ),
                    Text(widget.onboardFlight["flight_duration"]),
                  ],
                ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(widget.onboardFlight["arr_time"]),
                    const SizedBox(height: 4),
                    Text(
                      widget.onboardFlight["arr_to"],
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(widget.onboardFlight["arrival_terminal"])
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.returnFlight["dep_time"]),
                    const SizedBox(height: 4),
                    Text(
                      widget.returnFlight["dep_from"],
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(widget.returnFlight["depart_terminal"])
                  ],
                ),
                const Spacer(),
                Column(
                  children: [
                    Transform.rotate(
                      angle: -1.5708, // 90 degrees in radians
                      child: const Icon(Icons.flight, color: Colors.blueAccent),
                    ),
                    Text(widget.returnFlight["flight_duration"]),
                  ],
                ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(widget.returnFlight["arr_time"]),
                    const SizedBox(height: 4),
                    Text(
                      widget.returnFlight["arr_to"],
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(widget.returnFlight["arrival_terminal"])
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Flight Stops Section
            Center(
              child: Text(
                "Non Stop",
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 10),

            // Flight Info Icon and Text
            // Row(
            //   children: [
            //     GestureDetector(
            //       onTap: () {
            //         setState(() {
            //           isExpanded = !isExpanded; // Toggle expansion
            //         });
            //       },
            //       child: Row(
            //         children: [
            //           const Icon(Icons.info, color: Colors.grey),
            //           const SizedBox(width: 8),
            //           const Text(
            //             'Flight Info',
            //             style: TextStyle(
            //               color: Colors.grey,
            //               fontWeight: FontWeight.bold,
            //             ),
            //           ),
            //         ],
            //       ),
            //     ),
            //   ],
            // ),

            // Animated Expansion Section
            // AnimatedCrossFade(
            //   firstChild: const SizedBox.shrink(), // Empty space when collapsed
            //   secondChild: _buildExpandedInfo(), // Content when expanded
            //   crossFadeState: isExpanded
            //       ? CrossFadeState.showSecond
            //       : CrossFadeState.showFirst,
            //   duration: const Duration(milliseconds: 300),
            //   firstCurve: Curves.easeOut,
            //   secondCurve: Curves.easeIn,
            // ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpandedInfo() {
    return Column(
      children: [
        const SizedBox(height: 10),
        Row(
          children: [
            const Icon(Icons.flight_takeoff, color: Colors.blueAccent),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Flight Stops Details:",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Stop 1: Layover at Istanbul Airport (2 hours)\nStop 2: Layover at Dubai International (1 hour)",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[800],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

final flights = [
  Flight(
      airline: "Turkish Airlines",
      from: "NYC",
      to: "DXB",
      departureTime: "09:45",
      arrivalTime: "19:00",
      duration: "17h 15mins",
      stops: "1 Stop",
      price: 1070,
      flightDate: DateTime.now().add(const Duration(days: 1)),
      depart_terminal: 'Terminal 1',
      arrival_terminal: 'Terminal 2'),
  Flight(
      airline: "Ethiopian Airlines",
      from: "NYC",
      to: "DXB",
      departureTime: "11:00",
      arrivalTime: "20:00",
      duration: "17h 15mins",
      stops: "1 Stop",
      price: 1140,
      flightDate: DateTime.now().add(const Duration(days: 2)),
      depart_terminal: 'Terminal 1',
      arrival_terminal: 'Terminal 2'),
  Flight(
      airline: "Etihad Airways",
      from: "NYC",
      to: "DXB",
      departureTime: "09:45",
      arrivalTime: "19:00",
      duration: "17h 15mins",
      stops: "1 Stop",
      price: 1210,
      flightDate: DateTime.now().add(const Duration(days: 3)),
      depart_terminal: 'Terminal 1',
      arrival_terminal: 'Terminal 2'),
  Flight(
      airline: "Emirates",
      from: "NYC",
      to: "DXB",
      departureTime: "11:20",
      arrivalTime: "07:20",
      duration: "12h 30mins",
      stops: "Non Stop",
      price: 1430,
      flightDate: DateTime.now(),
      depart_terminal: 'Terminal 1',
      arrival_terminal: 'Terminal 2'),
];
