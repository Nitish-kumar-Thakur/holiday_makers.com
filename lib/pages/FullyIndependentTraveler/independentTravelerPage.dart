import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:HolidayMakers/utils/api_handler.dart';
import 'package:HolidayMakers/widgets/appLargetext.dart';
import 'package:HolidayMakers/widgets/appText.dart';
import 'package:HolidayMakers/widgets/calendarWidget.dart';
import 'package:HolidayMakers/widgets/drawerPage.dart';
import 'package:HolidayMakers/widgets/dropdownWidget.dart';
import 'package:HolidayMakers/widgets/responciveButton.dart';
import 'package:HolidayMakers/widgets/travelerDrawer.dart';
import 'package:HolidayMakers/pages/FullyIndependentTraveler/travelerhotels.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class IndependentTravelerPage extends StatefulWidget {
  const IndependentTravelerPage({
    super.key,
  });

  @override
  State<IndependentTravelerPage> createState() =>
      _IndependentTravelerPageState();
}

class _IndependentTravelerPageState extends State<IndependentTravelerPage>
    with TickerProviderStateMixin {
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
  late AnimationController _errorController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    // resetData(); // Reset all fields when page is loaded
    fetchCities();
    // Initialize AnimationController for smooth fading
    _errorController = AnimationController(
      duration: const Duration(seconds: 1), // Duration for the fade effect
      vsync: this,
    );

    _fadeAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_errorController);
  }

  void resetData() {
    setState(() {
      selectedCity = null;
      selectedDestination = null;
      fromDate = null;
      stayingDay = null;
      selectedRoom = "1";
      selectedAdult = "2";
      selectedChild = "0";
      childrenAge = [];
      totalRoomsdata = [
        {"adults": "2", "children": "0", "childrenAges": []}
      ];
      destinations = [];
      destinationLoading = true;
      blockedDates = [];
    });
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
      // setState(() {
      //   errorMessage = "Please fill all the required fields";
      // });
      // _errorController.forward();
      //
      // // Fade out the error message after 3 seconds
      // Future.delayed(Duration(seconds: 3), () {
      //   _errorController.reverse();
      //   setState(() {
      //     errorMessage = null;
      //   });
      // });
      Fluttertoast.showToast(msg: 'Please fill all the required fields');
      return;
    }

    try {
      print("====================");
      print(stayingDay!.split(' ')[0]);
      print("====================");
      var response = await APIHandler.fitSearch(
          sourceId: selectedCity!,
          destinationId: selectedDestination!,
          travelDate: fromDate!,
          noOfNights: stayingDay!.split(' ')[0],
          rooms: selectedRoom!,
          adults: selectedAdult!,
          children: selectedChild!,
          childrenAge: totalRoomsdata);

      if (response["message"] == "success") {
        // print("====================");
        // print(response["data"]["hotel_list"][0]);
        // print(totalRoomsdata); // Not Used Yet
        // print("====================");

        Navigator.push(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(
            builder: (context) => Travelerhotels(
              numberOfNights: stayingDay.toString(),
              responceData: response,
              roomArray: totalRoomsdata,
            ),
          ),
        );
      } else {
        Fluttertoast.showToast(msg: response["message"]);
        // setState(() {
        //   errorMessage = ;
        // });
        // _errorController.forward();
        //
        // // Fade out the error message after 3 seconds
        // Future.delayed(Duration(seconds: 3), () {
        //   _errorController.reverse();
        //   setState(() {
        //     errorMessage = null;
        //   });
        // });
      }
    } catch (error) {
      Fluttertoast.showToast(msg: "Error fetching hotels: $error");
      // setState(() {
      //   errorMessage = "Error fetching hotels: $error";
      // });
      // _errorController.forward();
      //
      // // Fade out the error message after 3 seconds
      // Future.delayed(Duration(seconds: 3), () {
      //   _errorController.reverse();
      //   setState(() {
      //     errorMessage = null;
      //   });
      // });
    }
  }

  @override
  void dispose() {
    _errorController.dispose(); // Dispose the animation controller
    super.dispose();
  }

  Widget _buildTopCurve() {
    return Padding(
      padding: const EdgeInsets.only(top: 20), // 20% of the screen height
      child: CustomPaint(
        size: Size(double.infinity, 0), // Height of the curved area
        painter: CirclePainter(radius: 200),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   backgroundColor: Colors.white,
      //   leading: IconButton(
      //             onPressed: () {
      //               Navigator.pop(context);
      //             },
      //             icon: CircleAvatar(
      //               backgroundColor: Colors.grey.withOpacity(0.6),  // Transparent grey background
      //               child: Text(
      //                 '<',  // Use "<" symbol
      //                 style: TextStyle(
      //                   color: Colors.white,  // White text color
      //                   fontSize: 24,  // Adjust font size as needed
      //                   fontWeight: FontWeight.bold,  // Make the "<" bold if needed
      //                 ),
      //               ),
      //             ),
      //           ), 
      // ),
      key: _scaffoldKey,
      drawer: Drawerpage(),
      body: SafeArea(
        child: SingleChildScrollView(
          // child: Padding(
            // padding: const EdgeInsets.all(25),
            // padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTopCurve(),
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
                              fontWeight: FontWeight
                                  .bold, // Make the "<" bold if needed
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  
                  const SizedBox(height: 30),
                  // Wrap the contents in a container with background image and box shadow
                  Container(
                    padding: const EdgeInsets.all(25),
                    // padding: const EdgeInsets.symmetric(horizontal: 25),
                    height: screenHeight * 0.67, // Increased height of the container (adjust as needed)
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20), // Rounded corners for the container
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.5), // Shadow color
                          offset: Offset(0, 3), // Shadow offset (vertical displacement)
                          blurRadius: 50, // Softens the shadow
                          spreadRadius: 1, // Extends the shadow
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20), // Ensure the border radius applies to the child as well
                      child: Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('img/fitFormBG.png'), // Path to your image
                                fit: BoxFit.cover, // This will make the image cover the entire container
                              ),
                            ),
                          ),
                          // The rest of the content inside the container
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Dropdownwidget(
                                  txtcolor: Colors.white,
                                  bgColor: Colors.white,
                                  selectedValue: selectedCity,
                                  items: cities,
                                  hintText: "Departure From".toUpperCase(),
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
                                const SizedBox(height: 15),
                                AbsorbPointer(
                                  absorbing: destinationLoading, // Prevents interaction when loading
                                  child: Dropdownwidget(
                                    txtcolor: Colors.white,
                                    bgColor: Colors.white,
                                    selectedValue: selectedDestination,
                                    items: destinations,
                                    hintText: "Destination".toUpperCase(),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        selectedDestination = newValue;
                                        loadBlockedDates(
                                          selectedCity.toString(),
                                          selectedDestination.toString(),
                                        );
                                      });
                                    },
                                  ),
                                ),
                                const SizedBox(height: 30),
                                Container(
                                  height: 58,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
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
                                              width: 5,
                                            ),
                                            // Column(
                                            //   children: [
                                            //     AppLargeText(
                                            //       text: 'TRAVEL DATE',
                                            //       color: Colors.black,
                                            //       size: 14,
                                            //     ),
                                            //     Calendarwidget(
                                            //       blockedDates: blockedDates,
                                            //       onDateSelected: (DateTime? newValue) {
                                            //         setState(() {
                                            //           fromDate = DateFormat('dd-MM-yyyy')
                                            //               .format(newValue!);
                                            //         });
                                            //       },
                                            //     ),
                                            //   ],
                                            // ),
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
                                        Container(
                                          height: 30,
                                          width: 100,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(20),
                                            border: Border.all(width: 1, color: Colors.grey),
                                          ),
                                          child: DropdownButtonHideUnderline(
                                            child: DropdownButton<String>(
                                              value: stayingDay, // Allow null values
                                              hint: Center(
                                                child: AppText(
                                                  text: "No. of Nights",
                                                  color: Colors.black,
                                                  size: 13,
                                                ),
                                              ), // Default hint text
                                              items: List.generate(60, (index) {
                                                String item = (index + 1)
                                                    .toString(); // Generate numbers from 1 to 90
                                                return DropdownMenuItem<String>(
                                                  value: "$item night",
                                                  child: Center(child: Text("$item Night")),
                                                );
                                              }),
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
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 30),
                                Travelerdrawer(
                                  onSelectionChanged: (Map<String, dynamic> selection) {
                                    setState(() {
                                      selectedRoom = selection['totalRooms'].toString();
                                      selectedAdult = selection['totalAdults'].toString();
                                      selectedChild = selection['totalChildren'].toString();
                                      childrenAge = selection['childrenAges'];
                                      totalRoomsdata = selection["totalData"];
                                    });
                                  },
                                ),
                                const SizedBox(height: 50),
                                GestureDetector(
                                  onTap: searchHotels,
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: responciveButton(text: 'SEARCH'),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                // if (errorMessage != null)
                                //   FadeTransition(
                                //     opacity: _fadeAnimation,
                                //     child: Center(
                                //       child: Text(
                                //         errorMessage!,
                                //         style: TextStyle(color: Colors.red.shade900, fontSize: 20, fontWeight: FontWeight.bold),
                                //       ),
                                //     ),
                                //   ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
          // ),
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
    paint.color = Color(0xFF0D939E); // Dark blue
    canvas.drawCircle(Offset(centerX, radius - 600), radius + 400, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
