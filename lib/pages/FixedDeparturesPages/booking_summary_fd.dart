import 'package:flutter/material.dart';
import 'package:holdidaymakers/pages/FullyIndependentTraveler/travelers_details.dart';
import 'package:holdidaymakers/widgets/responciveButton.dart';
import 'package:shimmer/shimmer.dart';

class BookingSummaryFD extends StatefulWidget {
  final Map<String, dynamic> packageDetails;
  final Map<String, dynamic> selectedHotel;
  final List<Map<String, dynamic>> flightDetails;

  const BookingSummaryFD({super.key, required this.packageDetails, required this.selectedHotel, required this.flightDetails});

  @override
  State<BookingSummaryFD> createState() => _BookingSummaryFDState();
}

class _BookingSummaryFDState extends State<BookingSummaryFD> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    });
    print('&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&');
    // print(widget.packageDetails);
    // print(widget.selectedHotel);
    print(widget.flightDetails);
    print('&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&');
  }
  bool isLoading = false;

  final List<Map<String, String>> packageDetails = [
    {'title': 'PACKAGE', 'value': 'Malaysia Duo: Koala and Lumpur'},
    {'title': 'DURATION', 'value': '2 NIGHT / 1 DAY'},
    {'title': 'DEPARTURE DATE', 'value': '11-Dec-2024'},
  ];

  final List<Map<String, String>> flightDetails = [
    {
      'flight': 'Emirates EK 567',
      'type': 'Departure',
      'icon': 'takeoff',
      'airport': 'Bangalore (BLR), India',
      'date': '11-Dec-2024',
      'terminal': 'T1'
    },
    {
      'flight': 'Emirates EK 568',
      'type': 'Arrival',
      'icon': 'landing',
      'airport': 'Dubai (DXB), UAE',
      'date': '12-Dec-2024',
      'terminal': 'T3'
    },
  ];

  final List<Map<String, String>> hotelDetails = [
    {'title': 'HOTEL NAME', 'value': 'Qatar : Doha'},
    {'title': 'ROOM TYPE', 'value': '2 NIGHT / 1 DAY'},
    {'title': 'CHECK IN DATE', 'value': '11-Dec-2024'},
    {'title': 'CHECK OUT DATE', 'value': '14-Dec-2024'},
    {'title': 'NO. OF NIGHTS', 'value': '2'},
    {'title': 'NO. OF ROOMS', 'value': '1'},
    {'title': 'MEAL PLAN', 'value': 'BREAKFAST'},
  ];

  final List<Map<String, String>> transferDetails = [
    {'title': 'ARRIVAL TRANSFER', 'value': 'Airport to Hotel'},
    {'title': 'RETURN TRANSFER', 'value': 'Hotel To Airport'},
  ];

  final List<Map<String, String>> insuranceDetails = [
    {'title': 'Travel Insurance in accordance to standards', 'value': ''},
  ];

  final List<Map<String, String>> priceDetails = [
    {'title': 'TOTAL (1 ADULT)', 'value': 'AED 1,310'},
    {'title': 'TOTAL', 'value': 'AED 1,310'},
  ];

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double fontSize = screenWidth * 0.035;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Booking Summary',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: isLoading
          ? _buildShimmerEffect()
          : SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSection('PACKAGE DETAILS', packageDetails, fontSize),
              _buildFlightDetailsSection('FLIGHT DETAILS', flightDetails, fontSize),
              _buildSection('HOTEL DETAILS', hotelDetails, fontSize),
              _buildSection('TRANSFER DETAILS', transferDetails, fontSize),
              _buildSection('TRAVEL INSURANCE DETAILS', insuranceDetails, fontSize),
              _buildSection('PRICE DETAILS', priceDetails, fontSize),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          width: double.infinity,
          child: IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TravelersDetails()),
              );
            },
            icon: responciveButton(text: 'SELECT'),
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Map<String, String>> details, double fontSize) {
    return Column(
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
        const SizedBox(height: 10),

        Column(
          children: List.generate(
            (details.length / 2).ceil(), // Divide into rows
                (index) {
              bool isLastOdd = details.length % 2 != 0 && index == details.length ~/ 2;
              return Column(
                children: [
                  Row(
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
                  const SizedBox(height: 10), // Space after each row
                ],
              );
            },
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildFlightDetailsSection(String title, List<Map<String, String>> details, double fontSize) {
    return Column(
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
        const SizedBox(height: 10),
        Column(
          children: details.map((flight) {
            return _buildFlightCard(flight, fontSize);
          }).toList(),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildFlightCard(Map<String, String> flight, double fontSize) {
    return Container(
      padding: EdgeInsets.all(fontSize * 0.7),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                flight['type'] == 'Departure' ? Icons.flight_takeoff : Icons.flight_land,
                color: Colors.black54,
              ),
              const SizedBox(width: 5),
              Text(
                flight['type']!,
                style: TextStyle(fontSize: fontSize * 1.2, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 5),

          // Flight Name
          Text(
            flight['flight']!,
            style: TextStyle(fontSize: fontSize * 1.1, fontWeight: FontWeight.bold, color: Colors.blue),
          ),
          const SizedBox(height: 5),

          // Airport Name
          Row(
            children: [
              const Icon(Icons.location_on, color: Colors.black54),
              const SizedBox(width: 5),
              Text(flight['airport']!, style: TextStyle(fontSize: fontSize)),
            ],
          ),
          const SizedBox(height: 5),

          // Date
          Row(
            children: [
              const Icon(Icons.date_range, color: Colors.black54),
              const SizedBox(width: 5),
              Text("Date: ${flight['date']}", style: TextStyle(fontSize: fontSize)),
            ],
          ),
          const SizedBox(height: 5),

          // Terminal
          Row(
            children: [
              const Icon(Icons.directions_transit, color: Colors.black54),
              const SizedBox(width: 5),
              Text("Terminal: ${flight['terminal']}", style: TextStyle(fontSize: fontSize)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailBox(String title, String value, double fontSize) {
    return Container(
      width: (MediaQuery.of(context).size.width / 2) - 25,
      height: 95,
      padding: EdgeInsets.all(fontSize * 0.7),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
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

  Widget _buildShimmerEffect() {
    return Center(
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Column(
          children: List.generate(4, (index) => _buildShimmerBox()),
        ),
      ),
    );
  }

  Widget _buildShimmerBox() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      width: 200,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  Widget _buildShimmerButton() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          height: 50,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget _responsiveButton({required String text}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
