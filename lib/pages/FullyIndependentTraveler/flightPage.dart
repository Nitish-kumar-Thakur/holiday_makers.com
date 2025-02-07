import 'package:flutter/material.dart';
import 'package:holdidaymakers/pages/FullyIndependentTraveler/booking_summary_fit.dart';
import 'package:holdidaymakers/widgets/responciveButton.dart';

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
  DateTime selectedDate = DateTime.now();
  static const int maxDays = 7;

  bool isSameDate(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  @override
  Widget build(BuildContext context) {
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
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: 2,
              itemBuilder: (context, index) {
                return FlightCard(onboardFlight: widget.responceData["data"]["flight"]["onward"], returnFlight: widget.responceData["data"]["flight"]["return"],
                responceData: widget.responceData, selectedHotel: widget.selectedHotel, roomArray: widget.roomArray);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class FlightCard extends StatefulWidget {
  final Map<String, dynamic> responceData;
  final Map<String, dynamic> selectedHotel;
 final Map<String, dynamic> onboardFlight;
 final Map<String, dynamic> returnFlight;
  final List<Map<String, dynamic>> roomArray;
  const FlightCard({super.key, required this.onboardFlight, required this.returnFlight,
   required this.responceData, required this.selectedHotel, required this.roomArray});

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
        child: Padding(padding: EdgeInsets.all(15),
          child: Column(
            children: [
              Card(
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
                      const SizedBox(height: 10),

                      // Flight Stops Section
                      Center(
                        child: Text(
                          "Non Stop",
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Card(
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
                            widget.returnFlight["flight_name"],
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            "\$${widget.returnFlight["Adult_Fare"]}",
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
                      const SizedBox(height: 10),

                      // Flight Stops Section
                      Center(
                        child: Text(
                          "Non Stop",
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10,),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => BookingSummaryFIT(responceData: widget.responceData, selectedHotel: widget.selectedHotel, roomArray: widget.roomArray,)));
                },child: responciveButton(text: "Select" ),
              ),
              SizedBox(height: 10,)
            ],
          ),)
    );
  }
}


