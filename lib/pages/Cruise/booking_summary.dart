import 'package:flutter/material.dart';
import 'package:holdidaymakers/utils/api_handler.dart';
import 'package:holdidaymakers/widgets/responciveButton.dart';
import 'package:shimmer/shimmer.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class BookingSummaryPage extends StatefulWidget {
  final Map<String, dynamic>? selectedCruiseData;
  final List<dynamic> totalRoomsdata;
  final Map<String, String>? selectedCabin;
  const BookingSummaryPage({super.key, required this.selectedCruiseData, required this.selectedCabin, required this.totalRoomsdata});

  @override
  State<BookingSummaryPage> createState() => _BookingSummaryPageState();
}

class _BookingSummaryPageState extends State<BookingSummaryPage> {
  bool isLoading = true;
  final _formKey = GlobalKey<FormState>();
  Map<String, dynamic> packageDetailss = {};
  Map<String, dynamic> priceDetailss = {};

  @override
  void initState() {
    super.initState();
    _fetchCruiseBookingSummary();
  }

  Future<void> _fetchCruiseBookingSummary() async {
    setState(() {
      isLoading = true; // ✅ Start loading before API call
    });

    try {
      Map<String, dynamic> requestBody = {
        "cruise_id": widget.selectedCruiseData?['cruise_id'].toString() ?? "",
        "dep_date": widget.selectedCruiseData?['dep_date'].toString() ?? "",
        "rooms": widget.totalRoomsdata.length.toString(),
        "room_wise_pax": widget.totalRoomsdata.map((room) {
          return {
            "paxCount": room["paxCount"].toString(),
            "paxAges": room["paxAges"].map((age) => age.toString()).toList(),
          };
        }).toList(),
        "cabin_type": widget.selectedCabin?['origin'].toString() ?? "",
      };

      final response = await APIHandler.getCruiseBSDetails(requestBody: requestBody);

      setState(() {
        var data = response['data'] ?? {};

        packageDetailss = {
          'PACKAGE': data['cruise_details']?['cruise_name'] ?? 'N/A',
          'DURATION': data['cruise_details']?['duration'] ?? 'N/A',
          'SHIP': data['cruise_details']?['ship_name'] ?? 'N/A',
          'CABIN': data['cruise_details']?['cabin_type'] ?? 'N/A',
          'DEPARTURE DATE': data['cruise_details']?['dep_date'] ?? 'N/A',
          'ARRIVAL DATE': data['cruise_details']?['arrival_date'] ?? 'N/A',
          'NO. OF ROOMS': widget.totalRoomsdata.length.toString(),
          'CHECK IN TIME': '${data['cruise_details']?['checkin_from_time'] ?? 'N/A'} - ${data['cruise_details']?['checkin_to_time'] ?? 'N/A'}',
        };

        priceDetailss = {
          'PAX': [
            if ((data['cruise_price']?['adult_count'] ?? 0) > 0)
              '${data['cruise_price']?['adult_count']} Adult(s)',
            if ((data['cruise_price']?['child_count'] ?? 0) > 0)
              '${data['cruise_price']?['child_count']} Child(ren)',
            if ((data['cruise_price']?['infant_count'] ?? 0) > 0)
              '${data['cruise_price']?['infant_count']} Infant(s)',
          ].join('\n'),
          'TOTAL': '${data['cruise_price']?['currency'] ?? 'AED'} ${data['cruise_price']?['total'] ?? 'N/A'}',
        };

        isLoading = false;
      });
    } catch (e) {
      print("Error: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  // Controllers for input fields
  final TextEditingController contactNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  String? selectedTitle;
  PhoneNumber?number = PhoneNumber(isoCode: 'AE');

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
      body: isLoading == true
          ? _buildShimmerEffect()
          : SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSection('PACKAGE DETAILS', packageDetailss, fontSize),
              _buildSection('PRICE DETAILS', priceDetailss, fontSize),
              _buildContactInfo(fontSize),
            ],
          ),
        ),
      ),
      bottomNavigationBar:isLoading?null:Padding(
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

  Widget _buildSection(String title, Map<String, dynamic> details, double fontSize) {
    // Convert the map entries into a list of entries
    List<MapEntry<String, dynamic>> entryList = details.entries.toList();

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
            (entryList.length / 2).ceil(), // Divide into rows
                (index) {
              bool isLastOdd =
                  entryList.length % 2 != 0 && index == entryList.length ~/ 2;
              return Column(
                children: [
                  IntrinsicHeight(  // Ensures both boxes in the row will have equal height
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildDetailBox(
                            entryList[index * 2].key, // Key as the title
                            entryList[index * 2].value.toString(), // Value as the value
                            fontSize,
                          ),
                        ),
                        if (!isLastOdd) ...[
                          const SizedBox(width: 10),
                          Expanded(
                            child: _buildDetailBox(
                              entryList[index * 2 + 1].key, // Key as the title
                              entryList[index * 2 + 1].value.toString(), // Value as the value
                              fontSize,
                            ),
                          ),
                        ],
                      ],
                    ),
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

  Widget _buildDetailBox(String title, String value, double fontSize) {
    return Container(
      padding: EdgeInsets.all(fontSize * 0.5),
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
  initialValue: number,
  textFieldController: phoneController,
  onSaved: (PhoneNumber number) {
    setState(() {
      this.number = number;
    });
  },
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title shimmer
                Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    height: 20,
                    width: 150,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),

                // Multiple shimmer rows for different sections
                _buildShimmerRow(),
                const SizedBox(height: 20),
                Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    height: 20,
                    width: 150,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                const SizedBox(height: 20),
                _buildShimmerRow(),
                const SizedBox(height: 20),

                Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    height: 20,
                    width: 150,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10), const SizedBox(height: 20),
                _buildShimmerRow(),
                const SizedBox(height: 20),
                Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    height: 20,
                    width: 150,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                const SizedBox(height: 20),
                _buildShimmerRow(),
                const SizedBox(height: 20),
                Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    height: 20,
                    width: 150,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                const SizedBox(height: 20),
                _buildShimmerRow(),
                const SizedBox(height: 20),
                Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    height: 20,
                    width: 150,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                const SizedBox(height: 20),
                _buildShimmerRow(),
              ],
            ),
          ),
        ),
      ],
    );
  }

// Function to build shimmer rows
  Widget _buildShimmerRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildShimmerBox(),
        _buildShimmerBox(),
      ],
    );
  }

// Function to create shimmer box for text placeholders
  Widget _buildShimmerBox() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: MediaQuery.of(context).size.width * (150 / 375),
        height: MediaQuery.of(context).size.width * (100 / 812),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
