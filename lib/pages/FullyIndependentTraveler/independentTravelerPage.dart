  import 'package:flutter/material.dart';
  import 'package:holdidaymakers/utils/api_handler.dart';
  import 'package:holdidaymakers/widgets/appLargetext.dart';
  import 'package:holdidaymakers/widgets/appText.dart';
  import 'package:holdidaymakers/widgets/calendarWidget.dart';
  import 'package:holdidaymakers/widgets/drawerPage.dart';
  import 'package:holdidaymakers/widgets/dropdownWidget.dart';
  import 'package:holdidaymakers/widgets/responciveButton.dart';
  import 'package:holdidaymakers/widgets/travelerDrawer.dart';
  import 'package:holdidaymakers/pages/FullyIndependentTraveler/travelerhotels.dart';
  import 'package:intl/intl.dart';

  class IndependentTravelerPage extends StatefulWidget {
    const IndependentTravelerPage({
      super.key,
    });

    @override
    State<IndependentTravelerPage> createState() =>
        _IndependentTravelerPageState();
  }

  class _IndependentTravelerPageState extends State<IndependentTravelerPage> {
    List<DateTime> blockedDates = [];
    bool destinationLoading = true;
    String? selectedCity;
    String? selectedDestination;
    String? fromDate;
    String? stayingDay;
    String? selectedRoom = "1";
    String? selectedAdult = "2";
    String? selectedChild = "0";
    List<String>? childrenAge = [];
    List<dynamic> totalRoomsdata = [
      {"adults": "2", "children": "0", "childrenAges": []}
    ];

    List<Map<String, String>> cities = [];
    List<Map<String, String>> destinations = [];
    String? errorMessage;

    String dropdownValue = '1 night';
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

    @override
    void initState() {
      super.initState();
      fetchCities();
      // print(selectedRoom);
    }

    Future<void> fetchCities() async {
      print(totalRoomsdata);
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

    Future<void> fetchDestinations(String sourceId) async {
      try {
        List<Map<String, String>> fetchedDestinations =
            await APIHandler.fetchDestinationList(sourceId);
        setState(() {
          destinations = fetchedDestinations;
          destinationLoading = false;
        });
      } catch (error) {
        print('Error fetching destinations: $error');
      }
    }

    Future<void> loadBlockedDates(String source, String destination) async {
      List<DateTime> dates =
          await APIHandler.fetchBlockedDates(source, destination);
      setState(() {
        blockedDates = dates;
        print("&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&");
      print("Blocked dates = $blockedDates");
      print("&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&");
      });
    }

    Future<void> searchHotels() async {
      if (selectedCity == null ||
          selectedDestination == null ||
          fromDate == null || 
          stayingDay == null ||
          selectedRoom == null ||
          selectedAdult == null ||
          selectedChild == null) {
        print("====================");

        print(totalRoomsdata); // Not Used Yet
        print("====================");
        setState(() {
          errorMessage = "Please fill all the required fields";
        });
        return;
      }

      try {
        var response = await APIHandler.fitSearch(
            sourceId: selectedCity!,
            destinationId: selectedDestination!,
            travelDate: fromDate!,
            noOfNights: stayingDay!.split(' ')[0],
            rooms: selectedRoom!,
            adults: selectedAdult!,
            children: selectedChild!,
            childrenAge: totalRoomsdata!);

        if (response["message"] == "success") {
          print("====================");
          print(response["data"]["hotel_list"][0]);
          print(totalRoomsdata); // Not Used Yet
          print("====================");

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Travelerhotels(
                responceData: response,
                roomArray: totalRoomsdata,
              ),
            ),
          );
        } else {
          setState(() {
            errorMessage = response["message"];
          });
        }
      } catch (error) {
        setState(() {
          errorMessage = "Error fetching hotels: $error";
        });
      }
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: Colors.white,
        // appBar: AppBar(
        //   backgroundColor: Colors.white,
        //   leading: IconButton(
        //     icon: Icon(Icons.arrow_back, color: Colors.black),
        //     onPressed: () {
        //       Navigator.pop(context);
        //     },
        //   ),
        // ),
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
                      color: Colors.black),
                  const SizedBox(height: 20),
                  Dropdownwidget(
                    selectedValue: selectedCity,
                    items: cities,
                    hintText: "Select City",
                    onChanged: (String? newValue) {
                      setState(() {
                        destinationLoading = true;
                        selectedCity = newValue;
                        selectedDestination = null;
                      });
                      if (newValue != null) {
                        fetchDestinations(newValue);
                        selectedCity = newValue;
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  AbsorbPointer(
                    absorbing:
                        destinationLoading, // Prevents interaction when loading
                    child: Dropdownwidget(
                      selectedValue: selectedDestination,
                      items: destinations,
                      hintText: "Select Destination",
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedDestination = newValue;
                          loadBlockedDates(selectedCity.toString(), selectedDestination.toString());
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 25),
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
                          Row(
                            children: [
                              Icon(
                                Icons.calendar_month,
                                size: 24,
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Column(
                                children: [
                                  AppLargeText(
                                    text: 'TRAVEL DATE',
                                    color: Colors.black,
                                    size: 14,
                                  ),
                                  Calendarwidget(
                                    blockedDates: blockedDates,
                                    onDateSelected: (DateTime? newValue) {
                                      setState(() {
                                        fromDate = DateFormat('dd-MM-yyyy')
                                            .format(newValue!);
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Container(
                            height: 30,
                            width: 100,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(width: 1, color: Colors.grey),
                            ),
                            child: DropdownButton<String>(
                              value: stayingDay, // Allow null values
                              hint: Center(
                                  child: AppText(
                                text: "Select",
                                color: Colors.black,
                              )), // Default hint text
                              items: ['1', '2', '3', '4'].map((String item) {
                                return DropdownMenuItem<String>(
                                  value: "$item night",
                                  child: Center(child: Text("$item night")),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  stayingDay = newValue; // Assign value directly
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
                  const SizedBox(height: 25),
                  Travelerdrawer(
                    onSelectionChanged: (Map<String, dynamic> selection) {
                      setState(() {
                        selectedRoom = selection['totalRooms'].toString() ?? "1";
                        selectedAdult =
                            selection['totalAdults'].toString() ?? "1";
                        selectedChild =
                            selection['totalChildren'].toString() ?? "0";
                        childrenAge = selection['childrenAges'];
                        totalRoomsdata = selection["totalData"];
                      });
                    },
                  ),
                  const SizedBox(height: 30),
                  GestureDetector(
                    onTap: searchHotels,
                    child: Align(
                        alignment: Alignment.center,
                        child: responciveButton(text: 'SEARCH')),
                  ),
                  const SizedBox(height: 20),
                  if (errorMessage != null)
                    Center(
                      child: Text(
                        errorMessage!,
                        style: TextStyle(color: Colors.red, fontSize: 16),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      );
    }
  }
