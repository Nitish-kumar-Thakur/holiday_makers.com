import 'package:flutter/material.dart';
import 'package:holdidaymakers/pages/FullyIndependentTraveler/travelers_details.dart';
import 'package:holdidaymakers/widgets/responciveButton.dart';
import 'package:shimmer/shimmer.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class BookingSummaryPage extends StatefulWidget {
  const BookingSummaryPage({super.key});

  @override
  State<BookingSummaryPage> createState() => _BookingSummaryPageState();
}

class _BookingSummaryPageState extends State<BookingSummaryPage> {
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();

  final List<Map<String, String>> packageDetails = [
    {'title': 'PACKAGE', 'value': 'Malaysia Duo: Koala & Lumpur'},
    {'title': 'DURATION', 'value': '2 NIGHT / 1 DAY'},
    {'title': 'SHIP', 'value': 'Resorts World One'},
    {'title': 'CABIN', 'value': 'Interior Cabin'},
    {'title': 'DEPARTURE DATE', 'value': '11-Dec-2024'},
    {'title': 'ARRIVAL DATE', 'value': '15-Dec-2024'},
    {'title': 'NO. OF ROOMS', 'value': '1'},
    {'title': 'CHECK IN TIME', 'value': '19:00 - 20:00'},
  ];

  final List<Map<String, String>> priceDetails = [
    {'title': 'TOTAL (1 ADULT)', 'value': 'AED 1,310'},
    {'title': 'TOTAL', 'value': 'AED 1,310'},
  ];

  // Controllers for input fields
  final TextEditingController contactNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  String? selectedTitle;
  PhoneNumber? number;

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
              _buildSection('PRICE DETAILS', priceDetails, fontSize),
              _buildContactInfo(fontSize),
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
              if (_formKey.currentState!.validate()) {
                // Perform the next action like navigating to another page
              }
            },
            icon: responciveButton(text: 'Pay Now'),
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
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: details.map((detail) {
            return _buildDetailBox(detail['title']!, detail['value']!, fontSize);
          }).toList(),
        ),
        const SizedBox(height: 20),
      ],
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

  Widget _buildContactInfo(double fontSize) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'CONTACT DETAILS',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                  items: ['Mr', 'Ms', 'Miss', 'Mrs']
                      .map((title) => DropdownMenuItem(
                    value: title,
                    child: Text(title),
                  ))
                      .toList(),
                  validator: (value) => value == null ? 'Select a title' : null,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextFormField(
                  controller: contactNameController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey.shade200,
                    labelText: 'Contact Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  validator: (value) => value!.isEmpty ? 'Enter your name' : null,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey.shade200,
              labelText: 'E-mail',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            validator: (value) => value!.contains('@') ? null : 'Enter a valid email',
          ),
          const SizedBox(height: 10),

          // Phone Number input with reduced width for the country code dropdown
          InternationalPhoneNumberInput(
            onInputChanged: (PhoneNumber number) {
              setState(() {
                this.number = number;
              });
            },
            onInputValidated: (bool value) {
              print(value ? 'Valid' : 'Invalid');
            },
            selectorConfig: SelectorConfig(
              selectorType: PhoneInputSelectorType.DROPDOWN,
              trailingSpace: false,
            ),
            hintText: 'Enter phone number',
            initialValue: PhoneNumber(isoCode: 'AE'), // Set default country as Dubai (UAE)
            textFieldController: phoneController,
            inputDecoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey.shade200,
              labelText: 'Phone Number',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          const SizedBox(height: 20),
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
}
