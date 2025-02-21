import 'package:flutter/material.dart';
import 'package:holdidaymakers/utils/api_handler.dart';
import 'package:holdidaymakers/widgets/responciveButton.dart';

class TravelersDetailsFD extends StatefulWidget {
  final List<dynamic> totalRoomsdata;
  final String searchId;

  const TravelersDetailsFD({super.key,  required this.totalRoomsdata, required this.searchId});

  @override
  State<TravelersDetailsFD> createState() => _TravelersDetailsFD();
}

class _TravelersDetailsFD extends State<TravelersDetailsFD> {
  late List<String> travelers;
  bool isLoading = true;
  List<dynamic> countryList = [];
  late List<Map<String, String>> _travelerDetails;
  List<String> cityList = [];
  final _formKey = GlobalKey<FormState>(); // Form key for validation
  TextEditingController dobController = TextEditingController();

  @override
  void initState() {
    super.initState();
    travelers = _generateTravelers(widget.totalRoomsdata.cast<Map<String, dynamic>>());
    _fetchCountry();
    _travelerDetails = List.generate(travelers.length, (index) => {
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
          cityList = List<String>.from(response["data"].map((city) => city["city_name"]));
        });
      }
    } catch (e) {
      print("Error fetching cities: $e");
    }
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

  final List<Map<String, String>> contactFields = [
    {"label": "Title", "type": "dropdown", "options": "Mr,Ms,Miss,Mrs"},
    {"label": "Contact Name", "type": "text"},
    {"label": "E-mail", "type": "text"},
    {"label": "Phone Number", "type": "text"},
  ];

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    // final double screenHeight = MediaQuery.of(context).size.height;
    // final double fontSize = screenWidth * 0.035;

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
          child: Form(
          key: _formKey,
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
                      validator: (value) =>
                      value == null ? 'Title is required' : null,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey.shade200,
                        labelText: 'Contact Name',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      validator: (value) =>
                      value!.isEmpty ? 'Contact Name is required' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey.shade200,
                        labelText: 'E-mail',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'E-mail is required';
                        } else if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                          return 'Enter a valid email';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey.shade200,
                        labelText: 'Phone Number',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      validator: (value) =>
                      value!.isEmpty ? 'Phone Number is required' : null,
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
                              value: _travelerDetails[index]["title"]!.isNotEmpty
                                  ? _travelerDetails[index]["title"]
                                  : null, // Avoids null errors
                              onChanged: (value) {
                                setState(() {
                                  _travelerDetails[index]["title"] = value!;
                                });
                              },
                              validator: (value) =>
                                value == null ? 'Title is required' : null,
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
                            child: TextFormField(
                              onChanged: (value) {
                                setState(() {
                                  _travelerDetails[index]["firstName"] = value;
                                });
                              },
                              validator: (value) =>
                                value!.isEmpty ? 'First Name is required' : null,
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
                            child: TextFormField(
                              onChanged: (value) {
                                setState(() {
                                  _travelerDetails[index]["lastName"] = value;
                                });
                              },
                              validator: (value) =>
                                value!.isEmpty ? 'Last Name is required' : null,
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
                            child: TextFormField(
                              controller: TextEditingController(text: _travelerDetails[index]["dob"]),
                              readOnly: true, // Makes it non-editable
                              onTap: () async {
                                DateTime? pickedDate = await showDatePicker(
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
                              validator: (value) =>
                                  value!.isEmpty ? 'Date of Birth is required' : null,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.grey.shade200,
                                labelText: 'Date of Birth',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                suffixIcon: Icon(Icons.calendar_today),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: countryList.any((country) => country["name"] == _travelerDetails[index]["nationality"])
                                  ? _travelerDetails[index]["nationality"]
                                  : null, // Set null if value is not found
                              onChanged: (value) {
                                setState(() {
                                  _travelerDetails[index]["nationality"] = value!;
                                });
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select nationality';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.grey.shade200,
                                labelText: 'Nationality',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              items: countryList
                                  .map((country) => DropdownMenuItem<String>(
                                value: country["name"] as String,
                                child: Text(country["name"] as String),
                              ))
                                  .toList(),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: countryList.any((country) => country["name"] == _travelerDetails[index]["residentCountry"])
                                  ? _travelerDetails[index]["residentCountry"]
                                  : null,
                              onChanged: (value) {
                                setState(() {
                                  _travelerDetails[index]["residentCountry"] = value!;
                                  cityList = []; // Clear city list when country changes
                                });

                                // Fetch cities based on the selected country
                                String countryId = countryList.firstWhere((country) => country["name"] == value)["origin"]!;
                                _fetchCity(countryId);
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select resident country';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.grey.shade200,
                                labelText: 'Resident Country',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              items: countryList
                                  .map((country) => DropdownMenuItem<String>(
                                value: country["name"],
                                child: Text(country["name"]!),
                              ))
                                  .toList(),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: cityList.contains(_travelerDetails[index]["residentCity"])
                                  ? _travelerDetails[index]["residentCity"]
                                  : null,
                              onChanged: (value) {
                                setState(() {
                                  _travelerDetails[index]["residentCity"] = value!;
                                });
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select resident city';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.grey.shade200,
                                labelText: 'Resident City',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              items: cityList
                                  .map((city) => DropdownMenuItem<String>(
                                value: city,
                                child: Text(city),
                              ))
                                  .toList(),
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
        ),),
      ),
      bottomNavigationBar: Padding(
          padding: EdgeInsets.all(20.0),
          child: GestureDetector(
            onTap: () {
              if (_formKey.currentState!.validate()) {
                print("Traveler Details:");
                print(_travelerDetails);
              } else {
                print("Form is not valid");
              }
            },
            child: responciveButton(text: 'Pay Now'),
          )
      ),
    );
  }
}
