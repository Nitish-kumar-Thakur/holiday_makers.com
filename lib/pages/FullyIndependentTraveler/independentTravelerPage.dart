import 'package:flutter/material.dart';
import 'package:holdidaymakers/utils/api_handler.dart';
import 'package:holdidaymakers/widgets/appLargetext.dart';
import 'package:holdidaymakers/widgets/calendarWidget.dart';
import 'package:holdidaymakers/widgets/drawerPage.dart';
import 'package:holdidaymakers/widgets/dropdownWidget.dart';
import 'package:holdidaymakers/widgets/responciveButton.dart';
import 'package:holdidaymakers/widgets/travelerDrawer.dart';

class Independenttravelerpage extends StatefulWidget {
  const Independenttravelerpage({super.key});

  @override
  State<Independenttravelerpage> createState() =>
      _IndependenttravelerpageState();
}

class _IndependenttravelerpageState extends State<Independenttravelerpage> {
  String? selectedCity;
  String? selectedDestination;
  String? fromDate;
  String? returnDate;
  String? stayingDay;
  String? selectedRoom;
  String? selectedAdult;
  String? selectedchild;

  List<Map<String, String>> cities = [];
  List<Map<String, String>> destinations = [];

  String dropdownValue = '1 night';
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    fetchCities(); // Fetch the source cities when the page is initialized
  }

  // Fetch source cities from the API
  Future<void> fetchCities() async {
    try {
      List<Map<String, String>> fetchedCities =
          await APIHandler.fetchSourceList();
      setState(() {
        cities = fetchedCities;
      });
    } catch (error) {
      print('Error fetching cities: $error');
    }
  }

  // Fetch destination cities based on the selected source city
  Future<void> fetchDestinations(String sourceId) async {
    try {
      List<Map<String, String>> fetchedDestinations =
          await APIHandler.fetchDestinationList(sourceId);
      setState(() {
        destinations = fetchedDestinations; // Update the destinations list
      });
    } catch (error) {
      print('Error fetching destinations: $error');
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous screen
          },
        ),
      ),
      key: _scaffoldKey,
      drawer: Drawerpage(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppLargeText(
                  text: 'Fully Independent Traveler',
                  size: 24,
                  color: Colors.black,
                ),
                const SizedBox(height: 20),
                // Source Dropdown with onChanged callback
                Dropdownwidget(
                  selectedValue: selectedCity,
                  items: cities,
                  hintText: "Select City",
                  // controller: sourceController,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedCity = newValue;
                      selectedDestination = null;
                    });
                    if (newValue != null) {
                      fetchDestinations(newValue);
                    }
                  },
                ),
                const SizedBox(height: 20),
                // Destination Dropdown
                Dropdownwidget(
                  selectedValue: selectedDestination,
                  items: destinations,
                  hintText: "Select Destination",
                  // controller: destinationController,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedDestination = newValue;
                    });
                  },
                ),
                const SizedBox(height: 20),
                // Travel date section
                Container(
                  height: 58,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(children: [
                          Icon(
                          Icons.calendar_month,
                          size: 24,
                        ),
                        SizedBox(width: 10,),
                        Column(
                          children: [
                            AppLargeText(
                              text: 'TRAVEL DATE',
                              color: Colors.black,
                              size: 14,
                            ),
                            Calendarwidget(
                              onDateSelected: (DateTime? newValue) {
                                setState(() {
                                  fromDate = newValue.toString();
                                });
                              },
                            ),
                          ],
                        ),
                        ],),
                        Container(
                          
                          height: 30,
                          width: 100,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(width: 1, color: Colors.grey),
                          ),
                          child: DropdownButton<String>(
                            value: dropdownValue,
                            items: ['1', '2', '3', '4']
                                .map((String item) {
                              return DropdownMenuItem<String>(
                                value: "$item night",
                                child: Center(child: Text("$item night")),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                dropdownValue = newValue!;
                                stayingDay = newValue;
                              });
                            },
                            icon: SizedBox.shrink(),
                            isExpanded: true,
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        // Calendarwidget(
                        //   onDateSelected: (selectedDate) {
                        //     setState(() {
                        //       returnDate = selectedDate.toString();
                        //     });
                        //   },
                        // ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Travelerdrawer(
                  onSelectionChanged: (List<Map<String, dynamic>> selection) {
                    setState(() {
                      selectedRoom = selection[0]['rooms'];
                      selectedAdult = selection[1]['adults'];
                      selectedchild = selection[2]['children'];
                    });
                  },
                ),
                const SizedBox(height: 30),
                GestureDetector(
                  onTap: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(builder: (context) => Travelerhotels()),
                    // );
                     print("Selected City: $selectedCity");
    print("Selected Destination: $selectedDestination");
    print("From Date: $fromDate");
    print("Return Date: $returnDate");
    print("Staying Days: $stayingDay");
    print("Selected Rooms: $selectedRoom");
    print("Selected Adults: $selectedAdult");
    print("Selected Children: $selectedchild");

                  },
                  child: Align(alignment: Alignment.center,child: responciveButton(text: 'SEARCH'),),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
