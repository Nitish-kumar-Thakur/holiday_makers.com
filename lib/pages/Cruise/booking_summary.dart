import 'package:flutter/material.dart';

class BookingSummaryPage extends StatefulWidget {
  const BookingSummaryPage({super.key});

  @override
  State<BookingSummaryPage> createState() => _BookingSummaryPageState();
}

class _BookingSummaryPageState extends State<BookingSummaryPage> {
  String? selectedTitle;
  String? selectedNationality;
  String? selectedResidentCountry;

  // Package details data
  final List<Map<String, String>> packageDetails = [
    {'title': 'PACKAGE', 'value': 'Qatar : Doha'},
    {'title': 'DURATION', 'value': '2 NIGHT / 1 DAY'},
    {'title': 'SHIP', 'value': 'Resorts World One'},
    {'title': 'CABIN', 'value': 'Interior Cabin'},
    {'title': 'DEPARTURE DATE', 'value': '11-Dec-2024'},
    {'title': 'ARRIVAL DATE', 'value': '15-Dec-2024'},
    {'title': 'NO. OF ROOMS', 'value': '1'},
    {'title': 'CHECK IN TIME', 'value': '19:00 - 20:00'},
  ];

  // Price details data
  final List<Map<String, String>> priceDetails = [
    {'title': 'TOTAL (1 ADULT)', 'value': 'AED 1,310'},
    {'title': 'TOTAL', 'value': 'AED 1,310'},
  ];

  // Travellers details data
  final List<Map<String, dynamic>> travellers = [
    {'type': 'Adult', 'firstName': '', 'lastName': '', 'dob': ''},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous page
          },
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Package Details Section
              const Text(
                'PACKAGE DETAILS',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 2.5,
                ),
                itemCount: packageDetails.length,
                itemBuilder: (context, index) {
                  return _buildDetailBox(
                    packageDetails[index]['title']!,
                    packageDetails[index]['value']!,
                  );
                },
              ),
              const SizedBox(height: 20),

              // Price Details Section
              const Text(
                'PRICE DETAILS',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 2.5,
                ),
                itemCount: priceDetails.length,
                itemBuilder: (context, index) {
                  return _buildDetailBox(
                    priceDetails[index]['title']!,
                    priceDetails[index]['value']!,
                  );
                },
              ),
              const SizedBox(height: 20),

              // Traveller Details Section
              const Text(
                'TRAVELLER DETAILS',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: travellers.length,
                itemBuilder: (context, index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Traveller ${index + 1} - ${travellers[index]['type']}',
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
                              value: selectedTitle,
                              onChanged: (value) {
                                setState(() {
                                  selectedTitle = value;
                                });
                              },
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.grey.shade200,
                                labelText: 'Title',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              items: ['Mr', 'Mrs', 'Ms']
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
                    ],
                  );
                },
              ),
              const SizedBox(height: 20),

              // PAY NOW Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Handle Pay Now action
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'PAY NOW',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailBox(String title, String value) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
