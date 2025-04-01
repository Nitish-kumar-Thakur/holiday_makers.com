import 'dart:ui';

import 'package:HolidayMakers/Tabby/PaymentPage.dart';
import 'package:HolidayMakers/utils/api_handler.dart';
import 'package:HolidayMakers/widgets/responciveButton.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class TravelersDetailsFIT extends StatefulWidget {
  final List<dynamic> totalRoomsdata;
  final String searchId;
  final Map<String, dynamic> BSData;

  const TravelersDetailsFIT(
      {super.key,
      required this.totalRoomsdata,
      required this.searchId,
      required this.BSData});

  @override
  State<TravelersDetailsFIT> createState() => _TravelersDetailsFD();
}

class _TravelersDetailsFD extends State<TravelersDetailsFIT> {
  late List<String> travelers;
  bool isLoading = true;
  List<dynamic> countryList = [];
  late List<Map<String, String>> _travelerDetails;
  List<String> cityList = [];
  final _formKey = GlobalKey<FormState>(); // Form key for validation
  TextEditingController dobController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  Map<String, dynamic> apiResponse = {};
  bool _isChecked = false;

  @override
  void initState() {
    super.initState();
    travelers =
        _generateTravelers(widget.totalRoomsdata.cast<Map<String, dynamic>>());
    _fetchCountry();
    _travelerDetails = List.generate(
        travelers.length,
        (index) => {
              "title": "",
              "firstName": "",
              "lastName": "",
              "dob": "",
              "nationality": "",
              "residentCountry": "",
              "residentCity": "",
            });
  }

  Future<void> _fetchCountry() async {
    try {
      final response = await APIHandler.getCountryList();
      setState(() {
        countryList = response['data'];
        isLoading = false;
      });
      // print('######################################################');
      // print(countryList[0]);
      // print('######################################################');
    } catch (e) {
      print("Error fetching package cards: $e");
    }
  }

  Future<void> _fetchCity(String countryId) async {
    try {
      final response = await APIHandler.getCity(countryId);
      if (response["status"] == true) {
        setState(() {
          cityList = List<String>.from(
              response["data"].map((city) => city["city_name"]));
        });
      }
    } catch (e) {
      print("Error fetching cities: $e");
    }
  }

  // Future<void> _saveBooking(Map<String, dynamic> body) async {
  //   try {
  //     final response = await APIHandler.fitSaveBooking(body);
  //     if (response["status"] == true) {
  //       setState(() {
  //         apiResponse = response['data'];
  //       });
  //       print('==================================');
  //       print(apiResponse);
  //       print('==================================');
  //     }
  //   } catch (e) {
  //     print("Error fetching cities: $e");
  //   }
  // }

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
                    color: Colors.black.withOpacity(0.4)), // Dark overlay
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

  List<String> _generateTravelers(List<Map<String, dynamic>> data) {
    List<String> generatedTravelers = [];

    for (var entry in data) {
      int adultCount = int.parse(entry["adults"] ?? "0");
      int childCount = int.parse(entry["children"] ?? "0");
      generatedTravelers.addAll(List.filled(adultCount, "Adult"));
      generatedTravelers.addAll(List.filled(childCount, "Child"));
    }

    return generatedTravelers;
  }

  Map<String, String> contactDetails = {
    "title": "",
    "contactName": "",
    "email": "",
    "countryCode": "+971", // Default
    "phoneNumber": "",
  };

  Widget _buildTopCurve() {
    return Padding(
      padding: const EdgeInsets.only(top: 50), // 20% of the screen height
      child: CustomPaint(
        size: Size(double.infinity, 0), // Height of the curved area
        painter: CirclePainter(radius: 200),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    // final double screenHeight = MediaQuery.of(context).size.height;
    // final double fontSize = screenWidth * 0.035;

    return Scaffold(
        // appBar: AppBar(
        //   leading: IconButton(
        //     icon: const Icon(Icons.arrow_back, color: Colors.black),
        //     onPressed: () {
        //       Navigator.pop(context);
        //     },
        //   ),
        //   backgroundColor: Colors.white,
        //   elevation: 0,
        //   title: const Text(
        //     'Travellers Details',
        //     style: TextStyle(color: Colors.black),
        //   ),
        //   centerTitle: true,
        // ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
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
                      backgroundColor: Colors.grey
                          .withOpacity(0.6), // Transparent grey background
                      child: Text(
                        '<', // Use "<" symbol
                        style: TextStyle(
                          color: Colors.white, // White text color
                          fontSize: 24, // Adjust font size as needed
                          fontWeight:
                              FontWeight.bold, // Make the "<" bold if needed
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text('TRAVELER DETAILS',
                      style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.white))
                ],
              ),
              const SizedBox(height: 40),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Card(
                        color: Colors.white,
                        elevation:
                            5, // Adjust the elevation for the shadow effect
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              10), // Optional: rounded corners
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(
                              16.0), // Adds padding around the content inside the card
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'CONTACT DETAILS',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              const Divider(),
                              const SizedBox(height: 15),
                              Row(
                                children: [
                                  Expanded(
                                    child: DropdownButtonFormField<String>(
                                      onChanged: (value) {
                                        setState(() {
                                          contactDetails["title"] = value!;
                                        });
                                      },
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.white,
                                        labelText: 'Title',
                                        // border: OutlineInputBorder(
                                        //   borderRadius: BorderRadius.circular(8),
                                        // ),
                                      ),
                                      items: ['Mr', 'Ms', 'Miss', 'Mrs']
                                          .map((title) => DropdownMenuItem(
                                                value: title,
                                                child: Text(title),
                                              ))
                                          .toList(),
                                      validator: (value) => value == null
                                          ? 'Title is required'
                                          : null,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: TextFormField(
                                      onChanged: (value) {
                                        contactDetails["contactName"] = value;
                                      },
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.white,
                                        labelText: 'Contact Name',
                                        // border: OutlineInputBorder(
                                        //   borderRadius: BorderRadius.circular(8),
                                        // ),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Contact Name is required';
                                        }
                                        if (!RegExp(r'^[a-zA-Z]+$')
                                            .hasMatch(value)) {
                                          return 'Only alphabets are allowed';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      onChanged: (value) {
                                        contactDetails["email"] = value;
                                      },
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.white,
                                        labelText: 'E-mail',
                                        // border: OutlineInputBorder(
                                        //   borderRadius: BorderRadius.circular(8),
                                        // ),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'E-mail is required';
                                        } else if (!RegExp(r'\S+@\S+\.\S+')
                                            .hasMatch(value)) {
                                          return 'Enter a valid email';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              IntlPhoneField(
                                decoration: InputDecoration(
                                  labelText: 'Phone Number',
                                  // border: OutlineInputBorder(
                                  //   borderSide: BorderSide(),
                                  // ),
                                ),
                                initialCountryCode: 'AE',
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                onChanged: (phone) {
                                  setState(() {
                                    contactDetails["countryCode"] =
                                        phone.countryCode;
                                    contactDetails["phoneNumber"] =
                                        phone.number;
                                  });
                                },
                                validator: (phone) {
                                  if (phone == null || phone.number.isEmpty) {
                                    return 'Phone number is required';
                                  }
                                  if (!RegExp(r'^\d+$')
                                      .hasMatch(phone.number)) {
                                    return 'Enter only numbers';
                                  }
                                  return null;
                                },
                                controller: phoneController,
                              ),
                            ],
                          ),
                        ),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: travelers.length,
                        itemBuilder: (context, index) {
                          return Card(
                            color: Colors.white,
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Traveler Header
                                  Text(
                                    'Traveler ${index + 1} - ${travelers[index]}',
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const Divider(),
                                  const SizedBox(height: 15),

                                  // Title and First Name Row
                                  Row(
                                    children: [
                                      Expanded(
                                        child: DropdownButtonFormField<String>(
                                          value: _travelerDetails[index]
                                                      ["title"]!
                                                  .isNotEmpty
                                              ? _travelerDetails[index]["title"]
                                              : null,
                                          onChanged: (value) {
                                            setState(() {
                                              _travelerDetails[index]["title"] =
                                                  value!;
                                            });
                                          },
                                          validator: (value) => value == null
                                              ? 'Title is required'
                                              : null,
                                          decoration: InputDecoration(
                                            filled: true,
                                            fillColor: Colors.white,
                                            labelText: 'Title',
                                            // border: OutlineInputBorder(
                                            //   borderRadius: BorderRadius.circular(8),
                                            // ),
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
                                        child: TextFormField(
                                          onChanged: (value) {
                                            setState(() {
                                              _travelerDetails[index]
                                                  ["firstName"] = value;
                                            });
                                          },
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'First Name is required';
                                            }
                                            if (!RegExp(r'^[a-zA-Z]+$')
                                                .hasMatch(value)) {
                                              return 'Only alphabets are allowed';
                                            }
                                            return null;
                                          },
                                          decoration: InputDecoration(
                                            filled: true,
                                            fillColor: Colors.white,
                                            labelText: 'First Name',
                                            // border: OutlineInputBorder(
                                            //   borderRadius: BorderRadius.circular(8),
                                            // ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),

                                  // Last Name and Date of Birth Row
                                  Row(
                                    children: [
                                      Expanded(
                                        child: TextFormField(
                                          onChanged: (value) {
                                            setState(() {
                                              _travelerDetails[index]
                                                  ["lastName"] = value;
                                            });
                                          },
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Last Name is required';
                                            }
                                            if (!RegExp(r'^[a-zA-Z]+$')
                                                .hasMatch(value)) {
                                              return 'Only alphabets are allowed';
                                            }
                                            return null;
                                          },
                                          decoration: InputDecoration(
                                            filled: true,
                                            fillColor: Colors.white,
                                            labelText: 'Last Name',
                                            // border: OutlineInputBorder(
                                            //   borderRadius: BorderRadius.circular(8),
                                            // ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: TextFormField(
                                          controller: TextEditingController(
                                              text: _travelerDetails[index]
                                                  ["dob"]),
                                          readOnly:
                                              true, // Makes it non-editable
                                          onTap: () async {
                                            DateTime? pickedDate =
                                                await showDatePicker(
                                              context: context,
                                              initialDate: DateTime.now(),
                                              firstDate: DateTime(1900),
                                              lastDate: DateTime.now(),
                                            );

                                            if (pickedDate != null) {
                                              setState(() {
                                                _travelerDetails[index]["dob"] =
                                                    "${pickedDate.day}-${pickedDate.month}-${pickedDate.year}";
                                              });
                                            }
                                          },
                                          validator: (value) => value!.isEmpty
                                              ? 'Date of Birth is required'
                                              : null,
                                          decoration: InputDecoration(
                                            filled: true,
                                            fillColor: Colors.white,
                                            labelText: 'Date of Birth',
                                            // border: OutlineInputBorder(
                                            //   borderRadius: BorderRadius.circular(8),
                                            // ),
                                            suffixIcon:
                                                Icon(Icons.calendar_today),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),

                                  // Nationality and Resident Country Row
                                  Row(
                                children: [
                                  Expanded(
                                    child: DropdownSearch<String>(
                                      popupProps: PopupProps.menu(
                                        showSearchBox:
                                            true, // Enables search functionality
                                      ),
                                      items: (filter, infiniteScrollProps) =>
                                          countryList.isNotEmpty
                                              ? countryList
                                                  .map<String>((country) =>
                                                      country["name"]
                                                          ?.toString() ??
                                                      "")
                                                  .toList()
                                              : [],
                                      selectedItem: _travelerDetails[index]
                                                  ["nationality"] !=
                                              null
                                          ? countryList.firstWhere(
                                              (country) =>
                                                  country["origin"] ==
                                                  _travelerDetails[index]
                                                      ["nationality"],
                                              orElse: () =>
                                                  {"name": ""})["name"]
                                          : null,
                                      onChanged: (value) {
                                        setState(() {
                                          // Find the country object where the name matches the selected value
                                          var selectedCountry =
                                              countryList.firstWhere(
                                                  (country) =>
                                                      country["name"] == value,
                                                  orElse: () =>
                                                      {}); // Provide a fallback in case no match is found

                                          // Store the 'origin' instead of the country name
                                          _travelerDetails[index]
                                                  ["nationality"] =
                                              selectedCountry["origin"];
                                        });
                                      },
                                      decoratorProps: DropDownDecoratorProps(
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: Colors.white,
                                          labelText: 'Select Nationality',
                                        ),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please select nationality';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),

                              // Resident Country Row
                              Row(
                                children: [
                                  Expanded(
                                    child: DropdownSearch<String>(
                                      popupProps: PopupProps.menu(
                                        showSearchBox:
                                            true, // Enables search functionality
                                      ),
                                      items: (filter, infiniteScrollProps) =>
                                          countryList.isNotEmpty
                                              ? countryList
                                                  .map<String>((country) =>
                                                      country["name"]
                                                          ?.toString() ??
                                                      "")
                                                  .toList()
                                              : [],
                                      selectedItem: _travelerDetails[index]
                                                  ["residentCountry"] !=
                                              null
                                          ? countryList.firstWhere(
                                              (country) =>
                                                  country["origin"] ==
                                                  _travelerDetails[index]
                                                      ["residentCountry"],
                                              orElse: () =>
                                                  {"name": ""})["name"]
                                          : null,
                                      onChanged: (value) {
                                        setState(() {
                                          // Find the country object where the name matches the selected value
                                          var selectedCountry =
                                              countryList.firstWhere(
                                                  (country) =>
                                                      country["name"] == value,
                                                  orElse: () =>
                                                      {}); // Provide a fallback in case no match is found

                                          // Store the 'origin' (not name) instead of the country name
                                          _travelerDetails[index]
                                                  ["residentCountry"] =
                                              selectedCountry["origin"];
                                        });

                                        // Fetch cities based on the selected country's origin
                                        _fetchCity(_travelerDetails[index]
                                                ["residentCountry"]
                                            .toString());
                                      },
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please select resident country';
                                        }
                                        return null;
                                      },
                                      decoratorProps: DropDownDecoratorProps(
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: Colors.white,
                                          labelText: 'Resident Country',
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),

                              // Resident City Row
                              Row(
                                children: [
                                  Expanded(
                                    child: DropdownSearch<String>(
                                      popupProps: PopupProps.menu(
                                        showSearchBox:
                                            true, // Enables search functionality
                                      ),
                                      items: (filter, infiniteScrollProps) {
                                        // Filter the cityList based on the filter string
                                        if (filter == null || filter.isEmpty) {
                                          return cityList; // Return all cities if no filter is applied
                                        } else {
                                          // Filter cities by the search filter (case insensitive)
                                          return cityList
                                              .where((city) => city
                                                  .toLowerCase()
                                                  .contains(
                                                      filter.toLowerCase()))
                                              .toList();
                                        }
                                      },
                                      selectedItem: _travelerDetails[index]
                                                  ["residentCity"] !=
                                              null
                                          ? _travelerDetails[index]
                                              ["residentCity"]
                                          : null,
                                      onChanged: (value) {
                                        setState(() {
                                          _travelerDetails[index]
                                                  ["residentCity"] =
                                              value!; // Update selected city
                                        });
                                      },
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please select resident city';
                                        }
                                        return null;
                                      },
                                      decoratorProps: DropDownDecoratorProps(
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: Colors.white,
                                          labelText: 'Resident City',
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                                  const SizedBox(
                                      height: 20), // Spacing between travelers
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: Stack(
          children: [
            Padding(
              padding: EdgeInsets.all(20.0),
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
                              style: TextStyle(
                                  fontSize: 14.0, color: Colors.black),
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
                                      _showTermsPopup(context);
                                    },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  AbsorbPointer(
                    absorbing: !_isChecked,
                    child: GestureDetector(
                      onTap: () {
                        if (_formKey.currentState != null &&
                            _formKey.currentState!.validate()) {
                          _formKey.currentState!
                              .save(); // Save form data before navigation
                          // print("Travelers Data: $travelers");
                          // print("Traveler Details: $_travelerDetails");
                          // print("Contact Details: $contactDetails");
                          Map<String, dynamic> body = {
                            'search_id': widget.searchId.toString(),
                            'voucher_code': '',
                            'title': contactDetails['title'],
                            'name': contactDetails['contactName'],
                            'email': contactDetails['email'],
                            'country_code': contactDetails['countryCode'],
                            'phone': contactDetails['phoneNumber'].toString(),
                            "pass_title": _travelerDetails
                                .map((t) => t["title"])
                                .toList(),
                            "pass_name": _travelerDetails
                                .map((t) => t["firstName"])
                                .toList(),
                            "pass_last_name": _travelerDetails
                                .map((t) => t["lastName"])
                                .toList(),
                            "pass_dob":
                                _travelerDetails.map((t) => t["dob"]).toList(),
                            "pass_nationality": _travelerDetails
                                .map((t) => t["nationality"])
                                .toList(),
                            "pass_country": _travelerDetails
                                .map((t) => t["residentCountry"])
                                .toList(),
                            "pass_city": _travelerDetails
                                .map((t) => t["residentCity"])
                                .toList(),
                            "passenger_type": travelers,
                            'payment_type': '',
                          };

                          // _saveBooking(body);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PaymentScreen(
                                    BSData: widget.BSData,
                                    sbAPIBody: body,
                                    flow: 'fit'),
                              ));
                        } else {
                          print("⚠️ Form is not valid");
                          print("Travelers Data: $travelers");
                          print("Traveler Details: $_travelerDetails");
                          print("Contact Details: $contactDetails");
                        }
                      },
                      child: Opacity(
                        opacity: _isChecked ? 1.0 : 0.5,
                        child: responciveButton(
                          text: "Pay Now (${widget.BSData['total_amount'].toString() ?? "N/A"})",
                          // text: '${finalPrice}' ?? widget.BSData['package_price']['total'].toString(),
                          // text: 'Pay Now',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ));
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
