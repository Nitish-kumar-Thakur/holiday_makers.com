import 'dart:ui';

import 'package:HolidayMakers/Tabby/PaymentPage.dart';
import 'package:HolidayMakers/utils/api_handler.dart';
import 'package:HolidayMakers/widgets/responciveButton.dart';
import 'package:HolidayMakers/widgets/terms_and_conditions_page.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:shimmer/shimmer.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class BookingSummaryPage extends StatefulWidget {
  final Map<String, dynamic>? selectedCruiseData;
  final List<dynamic> totalRoomdata;
  final Map<String, String>? selectedCabin;
  const BookingSummaryPage({super.key, required this.selectedCruiseData, required this.selectedCabin, required this.totalRoomdata});

  @override
  State<BookingSummaryPage> createState() => _BookingSummaryPageState();
}

class _BookingSummaryPageState extends State<BookingSummaryPage> {
  bool isLoading = true;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Map<String, dynamic> packageDetails = {};
  Map<String, dynamic> priceDetails = {};
  Map<String, String> contactDetails = {
    "title": "",
    "contactName": "",
    "email": "",
    "countryCode": "+971", // Default
    "phoneNumber": "",
  };
  String searchId = "";
  Map<String, dynamic> apiResponse = {};
  Map<String, dynamic> BSData = {};
  bool _isChecked = false;
  TextEditingController _voucherController = TextEditingController();
  Map<String, dynamic> voucherAPIResponse = {};
  String? finalPrice;

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
        "rooms": widget.totalRoomdata.length.toString(),
        "room_wise_pax": widget.totalRoomdata.map((room) {
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
        BSData = response['data'];

        packageDetails = {
          'PACKAGE': data['cruise_details']?['cruise_name'] ?? 'N/A',
          'DURATION': data['cruise_details']?['duration'] ?? 'N/A',
          'SHIP': data['cruise_details']?['ship_name'] ?? 'N/A',
          'CABIN': data['cruise_details']?['cabin_type'] ?? 'N/A',
          'DEPARTURE DATE': data['cruise_details']?['dep_date'] ?? 'N/A',
          'ARRIVAL DATE': data['cruise_details']?['arrival_date'] ?? 'N/A',
          'NO. OF ROOMS': widget.totalRoomdata.length.toString(),
          'CHECK IN TIME': '${data['cruise_details']?['checkin_from_time'] ?? 'N/A'} - ${data['cruise_details']?['checkin_to_time'] ?? 'N/A'}',
        };

        priceDetails = {
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

        searchId = response['data']['search_id'].toString();
        isLoading = false;
      });
      print(BSData['cruise_details']['cruise_id']);
      print(BSData['cruise_price']['total']);
    } catch (e) {
      print("Error: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _applyVoucher() async {
    String enteredCode = _voucherController.text.trim();

    // Map<String, dynamic> body = {
    //   "voucher_code": enteredCode,
    //   "package_id": widget.BSData['package_details']['package_id'],
    //   "package_price": widget.BSData['package_price']['total'],
    //   "package_type": "fd"
    // };

    Map<String, dynamic> body = {
      "voucher_code": enteredCode,
      "package_id": BSData['cruise_details']['cruise_id'],
      "package_price": BSData['cruise_price']['total'],
      "package_type": "cruise"
    };

    final response = await APIHandler.validateVoucher(body);

    setState(() {
      voucherAPIResponse = response;
    });

    print('###########################################################');
    print(voucherAPIResponse);
    print('###########################################################');

    if (voucherAPIResponse['status'] == true) {
      finalPrice = voucherAPIResponse['final_price'];
      Fluttertoast.showToast(msg: voucherAPIResponse['message']);

    } else {
      Fluttertoast.showToast(msg: voucherAPIResponse['message']);
    }
  }

  // Future<void> _saveBooking(Map<String, dynamic> body) async {
  //   print(body);
  //   try {
  //     final response = await APIHandler.cruiseSaveBooking(body);
  //     if (response["status"] == true) {
  //       setState(() {
  //         apiResponse = response['data'];
  //       });
  //       print('==================================');
  //       print('Final API Response: $apiResponse');
  //       print('==================================');
  //     }
  //   } catch (e) {
  //     print("Error fetching cities: $e");
  //   }
  // }

  // Controllers for input fields
  final TextEditingController contactNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  String? selectedTitle;
  PhoneNumber?number = PhoneNumber(isoCode: 'AE');

  Widget _buildTopCurve() {
    return Padding(
      padding: const EdgeInsets.only(top: 50), // 20% of the screen height
      child: CustomPaint(
        size: Size(double.infinity, 0), // Height of the curved area
        painter: CirclePainter(radius: 200),
      ),
    );
  }

  void _showTermsPopup(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Stack(
          children: [
            // Blurred Background Effect
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Container(
                    color: Colors.black.withOpacity(0.05)),
              ),
            ),
            Center(
              child: AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12), // Rounded corners
                ),
                title: Text(
                  "Terms and Conditions",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                content: Container(
                  width: double.maxFinite,
                  constraints: BoxConstraints(maxHeight: 300), // Limit height
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Please read the terms carefully before proceeding:",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "1. You must agree to the terms before proceeding.\n"
                              "2. Payments are final and non-refundable.\n"
                              "3. Your data will be used as per our privacy policy.\n"
                              "4. Other terms may apply...\n\n"
                              "By proceeding, you confirm that you have read and accepted these terms.",
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      "Close",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue, // Professional blue color
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double fontSize = screenWidth * 0.035;

    return Scaffold(
      // appBar: AppBar(
      //   leading: IconButton(
      //     icon: const Icon(Icons.arrow_back, color: Colors.black),
      //     onPressed: () => Navigator.pop(context),
      //   ),
      //   backgroundColor: Colors.white,
      //   elevation: 0,
      //   title: const Text(
      //     'Booking Summary',
      //     style: TextStyle(color: Colors.black),
      //   ),
      //   centerTitle: true,
      // ),
      backgroundColor: Colors.white,
      body: isLoading == true
          ? _buildShimmerEffect()
          : SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTopCurve(),
            const SizedBox(height: 10),
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: CircleAvatar(
                    backgroundColor: Colors.grey.withOpacity(0.6),  // Transparent grey background
                    child: Text(
                      '<',  // Use "<" symbol
                      style: TextStyle(
                        color: Colors.white,  // White text color
                        fontSize: 24,  // Adjust font size as needed
                        fontWeight: FontWeight.bold,  // Make the "<" bold if needed
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Text('BOOKING SUMMARY',
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white)
                )
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
              child: Column(
                children: [
                  const SizedBox(height: 40),  // Add space before first section
                  _buildSection('PACKAGE DETAILS', packageDetails, fontSize),
                  const SizedBox(height: 20),  // Space between sections
                  _buildSection('PRICE DETAILS', priceDetails, fontSize),
                  const SizedBox(height: 20),  // Space between sections
                  _buildContactInfo(fontSize),
                  // const SizedBox(height: 20),  // Space at the bottom
                  SizedBox(height: 5,),
                  Padding(padding: EdgeInsets.all(5),
                  child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _voucherController,
                        decoration: InputDecoration(
                          labelText: "Enter Voucher Code",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: _applyVoucher,
                      child: Text("Apply",
                          style: const TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.lightBlueAccent,
                      ),
                    ),
                  ],
                ),)
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: isLoading
          ? null
          : Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Checkbox(
                          value: _isChecked,
                          onChanged: (bool? value) {
                            setState(() {
                              _isChecked = value ?? false;
                            });
                          },
                        ),
                        Flexible(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _isChecked = !_isChecked;
                              });
                            },
                            child: RichText(
                              text: TextSpan(
                                style: TextStyle(fontSize: 14.0, color: Colors.black),
                                children: [
                                  TextSpan(text: "I have read and agree to the "),
                                  TextSpan(
                                    text: "Terms and Conditions",
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.underline,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => TermsAndConditionsPage(),
                                          ),
                                        );
                                      },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    AbsorbPointer(
                      absorbing: !_isChecked,
                      child: GestureDetector(
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            // print(contactDetails);
                            // print(searchId);
                            Map <String, dynamic> body = {
                              "search_id": searchId.toString(),
                              "voucher_code": _voucherController.text,
                              "title": contactDetails['title'].toString(),
                              "name": contactDetails['contactName'].toString(),
                              "email": contactDetails['email'].toString(),
                              "country_code": contactDetails['countryCode'].toString(),
                              "phone": contactDetails['phoneNumber'].toString(),
                              "payment_type": ""
                            };
                            // _saveBooking(body);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PaymentScreen(BSData: BSData, sbAPIBody: body, flow: 'cruise'),
                                ));
                          }

                        },
                        child: Opacity(
                          opacity: _isChecked ? 1.0 : 0.5,
                          child: responciveButton(
                            text: "Pay Now (${finalPrice ?? BSData['cruise_price']['total'].toString()})",
                            // text: '${finalPrice}' ?? widget.BSData['package_price']['total'].toString(),
                            // text: 'Pay Now',
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ),
            ],
          )
    );
  }

  Widget _buildSection(String title, Map<String, dynamic> details, double fontSize) {
    // Convert the map entries into a list of entries
    List<MapEntry<String, dynamic>> entryList = details.entries.toList();

    return Card(
      color: Colors.white, // White background for the card
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8), // Rounded corners for the card
      ),
      elevation: 4, // Shadow effect for the card
      child: Padding(
        padding: const EdgeInsets.all(16.0), // Padding around the content
        child: Column(
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
            // const SizedBox(height: 10),
            Column(
              children: List.generate(
                (entryList.length / 2).ceil(), // Divide into rows
                    (index) {
                  bool isLastOdd =
                      entryList.length % 2 != 0 && index == entryList.length ~/ 2;
                  return Column(
                    children: [
                      const Divider(color: Colors.grey), // Divider between each row
                      const SizedBox(height: 15),
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
                              const VerticalDivider(width: 10, color: Colors.grey),
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
          ],
        ),
      ),
    );
  }

  Widget _buildDetailBox(String title, String value, double fontSize) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: fontSize * 0.7, vertical: fontSize * 0.4), // Padding inside the detail box
      decoration: BoxDecoration(
        color: Colors.grey.shade50, // Background color of the box
        borderRadius: BorderRadius.circular(8), // Rounded corners
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
          SizedBox(height: fontSize * 0.3), // Space between title and value
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
    return Card(
      color: Colors.white, // White background for the card
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8), // Rounded corners for the card
      ),
      elevation: 4, // Shadow effect for the card
      child: Padding(
        padding: const EdgeInsets.all(16.0), // Padding around the content
        child: Form(
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
                          contactDetails["title"] = value ?? "";
                        });
                      },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'Title', // Placeholder text
                        contentPadding: EdgeInsets.symmetric(vertical: 12.0), // Padding inside the input
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
                        fillColor: Colors.white,
                        hintText: 'Contact Name', // Placeholder text
                        contentPadding: EdgeInsets.symmetric(vertical: 12.0), // Padding inside the input
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Contact Name is required';
                        }
                        if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
                          return 'Only alphabets are allowed';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        contactDetails["contactName"] = value;
                      },
                    ),
                  ),
                ],
              ),
              // const SizedBox(height: 10),
              // const Divider(color: Colors.grey), // Divider between fields
              const SizedBox(height: 10),
              TextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'E-mail', // Placeholder text
                  contentPadding: EdgeInsets.symmetric(vertical: 12.0), // Padding inside the input
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'E-mail is required';
                  } else if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                    return 'Enter a valid email';
                  }
                  return null;
                },
                onChanged: (value) {
                  contactDetails["email"] = value;
                },
              ),
              // const SizedBox(height: 10),
              // const Divider(color: Colors.grey),
              const SizedBox(height: 15),
              IntlPhoneField(
                decoration: InputDecoration(
                  hintText: 'Phone Number', // Placeholder text
                  contentPadding: EdgeInsets.symmetric(vertical: 12.0), // Padding inside the input
                ),
                initialCountryCode: 'AE',
                autovalidateMode: AutovalidateMode.onUserInteraction,
                onChanged: (phone) {
                  setState(() {
                    contactDetails["countryCode"] = phone.countryCode;
                    contactDetails["phoneNumber"] = phone.number;
                  });
                },
                validator: (phone) {
                  if (phone == null || phone.number.isEmpty) {
                    return 'Phone number is required';
                  }
                  if (!RegExp(r'^\d+$').hasMatch(phone.number)) {
                    return 'Enter only numbers';
                  }
                  return null;
                },
                controller: phoneController,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
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

class CirclePainter extends CustomPainter {
  final double radius;

  CirclePainter({required this.radius});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..style = PaintingStyle.fill;

    // We can use FontAwesome icon positioning logic here.
    double centerX = size.width / 2;

    // Draw the largest circle (dark blue)
    paint.color = Color(0xFF0D939E);
    canvas.drawCircle(Offset(centerX, radius - 600), radius + 400, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}