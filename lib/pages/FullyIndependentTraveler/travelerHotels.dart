import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:HolidayMakers/pages/FullyIndependentTraveler/flightPage_fit.dart';
import 'package:HolidayMakers/utils/api_handler.dart';
import 'package:HolidayMakers/widgets/appLargetext.dart';
import 'package:HolidayMakers/widgets/appText.dart';
import 'package:shimmer/shimmer.dart';

class Travelerhotels extends StatefulWidget {
  final String numberOfNights;
  final Map<String, dynamic> responceData; 
  final List<dynamic> roomArray;
  const Travelerhotels(
      {super.key,
      required this.responceData,
      required this.roomArray,
      required this.numberOfNights});

  @override
  State<Travelerhotels> createState() => _TravelerhotelsState();
}

class _TravelerhotelsState extends State<Travelerhotels> {
  List<dynamic> inclusionList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchPackageCards();
  }

  Future<void> _fetchPackageCards() async {
    try {
      final response = await APIHandler.fitInclusionList();
      setState(() {
        inclusionList = response['data'];
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching inclusion list: $e");
    }
  }

  // Widget buildInclusionCard(IconData icon, String label) {
  //   final screenWidth = MediaQuery.of(context).size.width;
  //   return Container(
  //     width: screenWidth * 0.17,
  //     height: screenWidth * 0.15,
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //       borderRadius: BorderRadius.circular(10),
  //     ),
  //     child: Column(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: [
  //         Icon(icon),
  //         const SizedBox(height: 4),
  //         AppText(
  //           text: label,
  //           size: screenWidth * 0.02,
  //           color: Colors.black,
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildTopCurve() {
    return Padding(
      padding: const EdgeInsets.only(top: 50), // 20% of the screen height
      child: CustomPaint(
        size: Size(double.infinity, 0), // Height of the curved area
        painter: CirclePainter(radius: 200),
      ),
    );
  }

  IconData getFontAwesomeIcon(String iconClass) {
    if (iconClass.contains("plane")) {
      return FontAwesomeIcons.plane;
    } else if (iconClass.contains("car")) {
      return FontAwesomeIcons.car;
    } else if (iconClass.contains("shield")) {
      return FontAwesomeIcons.shieldHalved;
    } else if (iconClass.contains("user")) {
      return FontAwesomeIcons.user;
    } else if (iconClass.contains("hotel")) {
      return FontAwesomeIcons.hotel;
    } else {
      return FontAwesomeIcons.circleQuestion; // Default icon
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    final hotelList = List<Map<String, dynamic>>.from(
        widget.responceData['data']['hotel_list'] ?? []);


    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _buildTopCurve(),
          const SizedBox(height: 30),
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
              Text('HOTELS',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white)
              )
            ],
          ),
          // Header Image with Back Button
          // isLoading
          //     ? HotelImageShimmer(screenHeight: screenHeight)
          //     : Container(
          //         height: screenHeight * 0.3,
          //         width: double.infinity,
          //         decoration: BoxDecoration(
          //           image: DecorationImage(
          //             image: NetworkImage(hotelList[0]["hotel_image"]),
          //             fit: BoxFit.cover,
          //           ),
          //         ),
          //         child: Padding(
          //           padding: EdgeInsets.only(top: screenHeight * 0.05),
          //           child: Column(
          //             crossAxisAlignment: CrossAxisAlignment.start,
          //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //             children: [
          //               IconButton(
          //                 icon: const Icon(
          //                   Icons.arrow_back,
          //                   color: Colors.white,
          //                 ),
          //                 onPressed: () {
          //                   Navigator.pop(context);
          //                 },
          //               ),
          //             ],
          //           ),
          //         ),
          //       ),

          Expanded(
            child: isLoading
                ? _buildShimmerGrid(screenWidth)
                : hotelList.isEmpty?
                 Center(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Oops!',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  'No hotels found matching your search.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                  ),
                                ),
                                SizedBox(height: 30),
                              ],
                            ),
                          ),
                        )
                 :ListView.builder(
              itemCount: hotelList.length,
              itemBuilder: (_, index) {
                return Padding(
                  // padding: EdgeInsets.only(bottom: screenHeight * 0.04),
                  padding: EdgeInsets.only(bottom: screenHeight * 0.015, left: screenHeight * 0.015, right: screenHeight * 0.015),
                  child: HotelCard(
                    numberOfNights: widget.numberOfNights,
                    hotel: hotelList[index],
                    responceData: widget.responceData,
                    roomArray: widget.roomArray,
                  ),
                );
              },
            ),
          ),
          // Container with Inclusion & Hotel List
          // Expanded(
          //   child: Container(
          //     width: double.infinity,
          //     decoration: BoxDecoration(color: Colors.white),
          //     child: Padding(
          //       padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
          //       child: Column(
          //         crossAxisAlignment: CrossAxisAlignment.start,
          //         children: [
          //           // if (inclusionList.isNotEmpty) ...[
          //           //   AppLargeText(
          //           //     text: 'INCLUSION',
          //           //     size: screenWidth * 0.06,
          //           //   ),
          //           //   SizedBox(height: screenHeight * 0.01),
          //           //   SingleChildScrollView(
          //           //     scrollDirection: Axis.horizontal,
          //           //     child: Row(
          //           //       children: inclusionList.map<Widget>((inclusion) {
          //           //         return Padding(
          //           //           padding: const EdgeInsets.symmetric(
          //           //               horizontal: 4), // Add spacing
          //           //           child: buildInclusionCard(
          //           //             getFontAwesomeIcon(inclusion['class']),
          //           //             inclusion['name'],
          //           //           ),
          //           //         );
          //           //       }).toList(),
          //           //     ),
          //           //   ),
          //           //   SizedBox(height: screenHeight * 0.02),
          //           // ],
          //
          //           // Expanded ListView to avoid overflow
          //           Expanded(
          //             child: isLoading
          //                 ? _buildShimmerGrid(screenWidth)
          //                 : ListView.builder(
          //                     itemCount: hotelList.length,
          //                     itemBuilder: (_, index) {
          //                       return Padding(
          //                         padding: EdgeInsets.only(
          //                             bottom: screenHeight * 0.04),
          //                         child: HotelCard(
          //                           numberOfNights: widget.numberOfNights,
          //                           hotel: hotelList[index],
          //                           responceData: widget.responceData,
          //                           roomArray: widget.roomArray,
          //                         ),
          //                       );
          //                     },
          //                   ),
          //           ),
          //         ],
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  // Shimmer effect for hotel grid while loading
  Widget _buildShimmerGrid(double screenWidth) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 8,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: screenWidth * 0.4,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(screenWidth * 0.04),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      height: 15, width: screenWidth * 0.5, color: Colors.grey),
                  SizedBox(height: 8),
                  Container(
                      height: 12, width: screenWidth * 0.3, color: Colors.grey),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                          height: 12,
                          width: screenWidth * 0.4,
                          color: Colors.grey),
                      Container(
                          height: 12,
                          width: screenWidth * 0.2,
                          color: Colors.grey),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: List.generate(
                        5,
                        (index) => Icon(
                              Icons.star,
                              color: Colors.grey,
                              size: screenWidth * 0.04,
                            )),
                  ),
                  SizedBox(height: 12),
                  Container(
                      height: 15,
                      width: screenWidth * 0.25,
                      color: Colors.grey),
                  SizedBox(height: 5),
                  Container(
                      height: 12, width: screenWidth * 0.2, color: Colors.grey),
                  SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    height: screenWidth * 0.12,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HotelCard extends StatefulWidget {
  final String numberOfNights;
  final Map<String, dynamic> hotel;
  final Map<String, dynamic> responceData;
  final List<dynamic> roomArray;

  const HotelCard(
      {super.key,
      required this.hotel,
      required this.responceData,
      required this.roomArray,
      required this.numberOfNights});

  @override
  State<HotelCard> createState() => _HotelCardState();
}

class _HotelCardState extends State<HotelCard> {
  // bool isLoading = false;
  // Map<dynamic, dynamic> flightData = {};
  // Future<void> fitUpdateHotel() async {
  //   final hotel = widget.hotel;
  //   Map<String, dynamic> fitUpdateHotelData = {
  //     "search_id": widget.responceData["data"]["search_id"],
  //     "hotel_id": hotel["parent_ht_id"],
  //     "hotel_fit_id": hotel["hotel_fit_id"]
  //   };
  //   try {
  //     // print("Sending API Request with Data: $fitUpdateHotelData");
  //     Map<dynamic, dynamic> response =
  //         await APIHandler.fitUpdateHotel(fitUpdateHotelData);

  //     // print("API Response: ${response}");

  //     if (response["message"] == "success") {
  //       flightData = response;
  //       isLoading = false;
  //       // print("Update Hotel Data Updated: ${fitUpdateHotelData}");
  //     } else {
  //       print("API Error: ${response["message"]}");
  //     }
  //   } catch (error) {
  //     print("Exception in API Call: $error");
  //   }
  // }

  _selectButton() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FlightPageFIT(
          numberOfNights: widget.numberOfNights,
          hotel: widget.hotel,
          responceData: widget.responceData,
          roomArray: widget.roomArray,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final String roomType = widget.hotel["room_category_name"] ?? 'N/A';
    final String mealType = widget.hotel["meal_type_name"] ?? 'N/A';
    final String occupancy = widget.hotel["occupacy"] ?? 'N/A';
    final String price = widget.hotel["price_per_person"].toString();
    final int star = int.parse(widget.hotel["rating"]);

    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 8,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                child: Stack(
                  children: [
                    // Image
                    Image.network(
                      widget.hotel["hotel_image"],
                      fit: BoxFit.cover,
                      width: screenWidth,
                      height: screenWidth * 0.6, // Adjust the height of the image as needed
                    ),
                    // Semi-transparent black overlay
                    Container(
                      width: screenWidth,
                      height: screenWidth * 0.6, // Same height as the image
                      color: Colors.black.withOpacity(0.3), // Adjust opacity for darkness
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 10,
                left: 10,
                right: 60,
                child: Container(
                  width: screenWidth * 0.6, // Set a fixed width to allow wrapping
                  child: Text(
                    widget.hotel["hotel_name"],
                    style: TextStyle(
                      fontSize: screenWidth * 0.05, // Adjust size as needed
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // White text for visibility on dark backgrounds
                    ),
                    softWrap: true, // Allow text to wrap onto the next line
                  ),
                ),
              ),
              Positioned(
                bottom: 10,
                right: 10,
                child: Row(
                  children: List.generate(star, (index) {
                    return Icon(
                      Icons.star,
                      color: Colors.amber,
                      size: screenWidth * 0.05,
                    );
                  }),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.all(screenWidth * 0.04),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Left side: City and Room Details
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // City
                      Container(
                        width: screenWidth * 0.6, // Fixed width for the city text
                        child: Text(
                          widget.hotel["destination"] ?? "N/A",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: screenWidth * 0.04,
                            fontWeight: FontWeight.bold,
                          ),
                          softWrap: true, // Allow the text to wrap to the next line
                        ),
                      ),
                      SizedBox(height: screenWidth * 0.02),
                      // Room Details
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Room Type
                          Row(
                            children: [
                              Text(
                                '•', // Dot
                                style: TextStyle(
                                  color: Colors.red, // Red dot color
                                  fontSize: screenWidth * 0.035,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 5),
                              // Allow text to wrap without truncating
                              Container(
                                width: screenWidth * 0.5, // Fixed width for the room type text
                                child: Text(
                                  'Type: $roomType',
                                  style: TextStyle(
                                    fontSize: screenWidth * 0.03,
                                    height: 1.5,
                                  ),
                                  softWrap: true, // Allow the text to wrap
                                ),
                              ),
                            ],
                          ),
                          // Room Occupancy
                          Row(
                            children: [
                              Text(
                                '•', // Dot
                                style: TextStyle(
                                  color: Colors.red, // Red dot color
                                  fontSize: screenWidth * 0.035,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 5),
                              // Allow text to wrap without truncating
                              Container(
                                width: screenWidth * 0.5, // Fixed width for the room occupancy text
                                child: Text(
                                  'Occupancy: $occupancy',
                                  style: TextStyle(
                                    fontSize: screenWidth * 0.03,
                                    height: 1.5,
                                  ),
                                  softWrap: true, // Allow the text to wrap
                                ),
                              ),
                            ],
                          ),
                          // Meals Plan
                          Row(
                            children: [
                              Text(
                                '•', // Dot
                                style: TextStyle(
                                  color: Colors.red, // Red dot color
                                  fontSize: screenWidth * 0.035,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 5),
                              // Allow text to wrap without truncating
                              Container(
                                width: screenWidth * 0.5, // Fixed width for the meals plan text
                                child: Text(
                                  'Meals Plan: $mealType',
                                  style: TextStyle(
                                    fontSize: screenWidth * 0.03,
                                    height: 1.5,
                                  ),
                                  softWrap: true, // Allow the text to wrap
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Right side: Price and Select Button
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // Price
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'AED $price',
                            style: TextStyle(
                              fontSize: screenWidth * 0.035,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            'Price Per Person',
                            style: TextStyle(
                              fontSize: screenWidth * 0.03,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: screenWidth * 0.005),
                      // Select Button
                      Align(
                        alignment: Alignment.centerRight,
                        child: SizedBox(
                          width: screenWidth * 0.3,
                          child: ElevatedButton(
                            onPressed: _selectButton,
                            style: ElevatedButton.styleFrom(
                              backgroundColor:Color(0xFF0071BC),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              side: BorderSide(color: Color(0xFF0071BC)),
                            ),
                            child: Text(
                              'SELECT',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: screenWidth * 0.035,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      // SizedBox(
                      //   width: double.infinity,
                      //   child: ElevatedButton(
                      //     onPressed: _selectButton,
                      //     style: ElevatedButton.styleFrom(
                      //       backgroundColor: Colors.red,
                      //       shape: RoundedRectangleBorder(
                      //         borderRadius: BorderRadius.circular(10),
                      //       ),
                      //     ),
                      //     child: Text(
                      //       'SELECT',
                      //       style: TextStyle(
                      //           color: Colors.white, fontSize: screenWidth * 0.04),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

  }
}

class HotelImageShimmer extends StatelessWidget {
  final double screenHeight;

  const HotelImageShimmer({
    required this.screenHeight,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        height: screenHeight * 0.3,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey[300], // Placeholder color
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
    paint.color = Color(0xFF0D939E); // Dark blue
    canvas.drawCircle(Offset(centerX, radius - 600), radius + 400, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}