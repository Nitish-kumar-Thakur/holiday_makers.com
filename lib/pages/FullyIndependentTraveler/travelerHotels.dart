import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:holdidaymakers/pages/FullyIndependentTraveler/flightPage_fit.dart';
import 'package:holdidaymakers/utils/api_handler.dart';
import 'package:holdidaymakers/widgets/appLargetext.dart';
import 'package:holdidaymakers/widgets/appText.dart';
import 'package:shimmer/shimmer.dart';

class Travelerhotels extends StatefulWidget {
  final String numberOfNights;
  final Map<String, dynamic> responceData;
  final List<dynamic> roomArray;
  const Travelerhotels(
      {super.key, required this.responceData, required this.roomArray, required this.numberOfNights});

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

  Widget buildInclusionCard(IconData icon, String label) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      width: screenWidth * 0.17,
      height: screenWidth * 0.15,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon),
          const SizedBox(height: 4),
          AppText(
            text: label,
            size: screenWidth * 0.02,
            color: Colors.black,
          ),
        ],
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
          // Header Image with Back Button
          isLoading
              ? HotelImageShimmer(screenHeight: screenHeight)
              : Container(
                  height: screenHeight * 0.3,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(hotelList[0]["hotel_image"]),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(top: screenHeight * 0.05),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  ),
                ),

          // Container with Inclusion & Hotel List
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(color: Colors.grey.shade200),
              child: Padding(
                padding: EdgeInsets.all(screenWidth * 0.03),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (inclusionList.isNotEmpty) ...[
                      AppLargeText(
                        text: 'INCLUSION',
                        size: screenWidth * 0.06,
                      ),
                      SizedBox(height: screenHeight * 0.01),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: inclusionList.map<Widget>((inclusion) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 4), // Add spacing
                              child: buildInclusionCard(
                                getFontAwesomeIcon(inclusion['class']),
                                inclusion['name'],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),
                    ],

                    // Expanded ListView to avoid overflow
                    Expanded(
                      child: isLoading
                          ? _buildShimmerGrid(screenWidth)
                          : ListView.builder(
                              itemCount: hotelList.length,
                              itemBuilder: (_, index) {
                                return Padding(
                                  padding: EdgeInsets.only(
                                      bottom: screenHeight * 0.04),
                                  child: HotelCard(
                                    numberOfNights:widget.numberOfNights,
                                    hotel: hotelList[index],
                                    responceData: widget.responceData,
                                    roomArray: widget.roomArray,
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ),
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
    final String roomType = widget.hotel["room_category_name"];
    final String mealType = widget.hotel["meal_type_name"];
    final String price = widget.hotel["price_per_person"].toString();
    final int star = int.parse(widget.hotel["rating"]);

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 8,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
            child: Image.network(
              widget.hotel["hotel_image"],
              fit: BoxFit.cover,
              width: screenWidth,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(screenWidth * 0.04),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 200,
                          child: Text(
                            widget.hotel["hotel_name"],
                            style: TextStyle(
                              fontSize: screenWidth * 0.035,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          widget.hotel["destination"],
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: screenWidth * 0.035,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: List.generate(star, (index) {
                        return Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: screenWidth * 0.035,
                        );
                      }),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '• Room Type: $roomType',
                          style: TextStyle(
                              fontSize: screenWidth * 0.03, height: 1.5),
                        ),
                        Text(
                          '• Room Occupancy: Double or Twin',
                          style: TextStyle(
                              fontSize: screenWidth * 0.03, height: 1.5),
                        ),
                        Text(
                          '• Meals Plan: $mealType',
                          style: TextStyle(
                              fontSize: screenWidth * 0.03, height: 1.5),
                        ),
                      ],
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                SizedBox(height: screenWidth * 0.03),
                Row(
                  children: [
                    Container(
                      width: screenWidth * 0.25,
                      height: screenWidth * 0.12,
                      decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.grey),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(3),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'CHECK IN',
                              style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: screenWidth * 0.03),
                            ),
                            Text(
                              widget.hotel["checkin_time"],
                              style: TextStyle(
                                  fontSize: screenWidth * 0.035,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: screenWidth * 0.03),
                    Container(
                      width: screenWidth * 0.25,
                      height: screenWidth * 0.12,
                      decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.grey),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(3),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'CHECK OUT',
                              style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: screenWidth * 0.03),
                            ),
                            Text(
                              widget.hotel["checkout_time"],
                              style: TextStyle(
                                  fontSize: screenWidth * 0.035,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(height: screenWidth * 0.03),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _selectButton,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      'SELECT',
                      style: TextStyle(
                          color: Colors.white, fontSize: screenWidth * 0.04),
                    ),
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
