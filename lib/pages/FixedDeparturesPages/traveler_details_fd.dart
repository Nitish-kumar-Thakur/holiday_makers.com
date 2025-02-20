import 'package:flutter/material.dart';
import 'package:holdidaymakers/pages/FixedDeparturesPages/booking_summary_fd.dart';
import 'package:holdidaymakers/pages/FullyIndependentTraveler/payment_method.dart';
import 'package:holdidaymakers/widgets/responciveButton.dart';

class TravelersDetailsFD extends StatefulWidget {
  final Map<String, dynamic> packageDetails;
  final Map<String, dynamic> selectedHotel;
  final List<Map<String, dynamic>> flightDetails;
  final List<dynamic> totalRoomsdata;
  final String searchId;

  const TravelersDetailsFD({super.key, required this.packageDetails, required this.selectedHotel, required this.flightDetails, required this.totalRoomsdata, required this.searchId});

  @override
  State<TravelersDetailsFD> createState() => _TravelersDetailsFD();
}

class _TravelersDetailsFD extends State<TravelersDetailsFD> {
  // final List<Map<String, dynamic>> travelerData = [
  //   {
  //     "adult": "2",
  //     "child": "1",
  //   }
  // ];

  late List<String> travelers;

  @override
  void initState() {
    super.initState();
    travelers = _generateTravelers(widget.totalRoomsdata.cast<Map<String, dynamic>>());
  }

  List<String> _generateTravelers(List<Map<String, dynamic>> data) {
    List<String> generatedTravelers = [];

    for (var entry in data) {
      int adultCount = int.parse(entry["adult"] ?? "0");
      int childCount = int.parse(entry["child"] ?? "0");
      generatedTravelers.addAll(List.filled(adultCount, "Adult"));
      generatedTravelers.addAll(List.filled(childCount, "Child"));
    }

    return generatedTravelers;
  }

  final List<Map<String, String>> contactFields = [
    {"label": "Title", "type": "dropdown", "options": "Mr,Ms,Miss,Mrs"},
    {"label": "Contact Name", "type": "text"},
    {"label": "E-mail", "type": "text"},
    {"label": "Phone Number", "type": "text"},
  ];

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double fontSize = screenWidth * 0.035;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Travellers Details',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              const Text(
                'CONTACT DETAILS',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      // value: selectedTitle,
                      onChanged: (value) {},
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey.shade200,
                        labelText: 'Title',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      items: ['Mr', 'Ms', 'Miss', 'Mrs']
                          .map((title) => DropdownMenuItem(
                        value: title,
                        child: Text(title),
                      ))
                          .toList(),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey.shade200,
                        labelText: 'Contact Name',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey.shade200,
                        labelText: 'E-mail',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey.shade200,
                        labelText: 'Phone Number',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: travelers.length,
                itemBuilder: (context, index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 30),
                      Text(
                        'Traveler ${index + 1} - ${travelers[index]}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              // value: selectedTitle,
                              onChanged: (value) {},
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.grey.shade200,
                                labelText: 'Title',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              items: ['Mr', 'Ms', 'Miss', 'Mrs']
                                  .map((title) => DropdownMenuItem(
                                value: title,
                                child: Text(title),
                              ))
                                  .toList(),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.grey.shade200,
                                labelText: 'First Name',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.grey.shade200,
                                labelText: 'Last Name',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.grey.shade200,
                                labelText: 'Date of Birth',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.grey.shade200,
                                labelText: 'Nationality',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.grey.shade200,
                                labelText: 'Resident Country',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.grey.shade200,
                                labelText: 'Resident City',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
          padding: EdgeInsets.all(20.0),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BookingSummaryFD(
                      flightDetails: widget.flightDetails,
                      selectedHotel: widget.selectedHotel,
                      packageDetails: widget.packageDetails,
                      totalRoomsdata: widget.totalRoomsdata,
                      searchId: widget.searchId
                  ),
                ),
              );
            },
            child: responciveButton(text: 'Pay Now'),
          )
      ),
    );
  }
}
