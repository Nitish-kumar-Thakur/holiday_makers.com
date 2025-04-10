import 'package:HolidayMakers/pages/FixedDeparturesPages/add_tour_fd.dart';
import 'package:HolidayMakers/pages/FixedDeparturesPages/booking_summary_fd.dart';
import 'package:flutter/material.dart';
import 'package:HolidayMakers/pages/FixedDeparturesPages/flightPageFD.dart';
import 'package:HolidayMakers/utils/api_handler.dart';
import 'package:HolidayMakers/widgets/responciveButton.dart';
import 'package:shimmer/shimmer.dart';

class HotelsAccommodation extends StatefulWidget {
  final List<dynamic> activityList;
  final Map<String, dynamic> packageData;
  final List<dynamic> totalRoomsdata;
  final String showTourPage;
  final int showFlightPage;
  const HotelsAccommodation(
      {super.key,
      required this.packageData,
      required this.totalRoomsdata,
      required this.activityList,
      required this.showTourPage,
      required this.showFlightPage
      });

  @override
  State<HotelsAccommodation> createState() => _HotelsAccommodationState();
}

class _HotelsAccommodationState extends State<HotelsAccommodation> {
  bool isLoading = true;
  int selectedHotelIndex = 0;
  Map<String, dynamic> hotelList = {};
  // List<Map<String, dynamic>> flightList = [];
  String temp = "";
  String searchId = "";
  String hotelId = "";

  @override
  void initState() {
    // print("@@@@@@@@@@@@@@@@Nitish Thakur@@@@@@@@@@@@@@@@");
    // print(widget.packageData["dep_date"]);
    // print(widget.packageData["package_id"]);
    // print(widget.totalRoomsdata);
    // print(widget.packageData);
    // print("@@@@@@@@@@@@@@@@Nitish Thakur@@@@@@@@@@@@@@@@");

    super.initState();
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    });
    _fetchFDHotelDetails();
  }

  Future<void> _fetchFDHotelDetails() async {
    Map<dynamic, dynamic> body = {
      "package_id": widget.packageData['package_id'],
      "rooms": widget.totalRoomsdata.length.toString(),
      "room_wise_pax": widget.totalRoomsdata,
      "dep_date": widget.packageData['dep_date']
    };
    try {
      final response = await APIHandler.getFDHotelDetails(body);
      setState(() {
        hotelList = response['data']['hotel_details'] ?? {};
        // flightList = (response['data']['group_by_flight_details'] as List)
        //         .map((e) => e as Map<String, dynamic>)
        //         .toList() ??
        //     [];
        searchId = response['data']['search_id'].toString();
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching package cards: $e");
    }
  }

  Future<void> _updateHotelDetails(String hotelId) async {
    Map<dynamic, dynamic> body = {
      "search_id": searchId,
      "hotel_id": hotelId
    };
    // print('body: $body');
    try {
      final response = await APIHandler.getFDFlightDetails(body);
      // print('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');
      // print(response);
      // print('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');
    } catch (e) {
      print("Error updating hotel details: $e");
    }
  }

  Widget _buildTopCurve() {
    return Padding(
      padding: const EdgeInsets.only(top: 30), // 20% of the screen height
      child: CustomPaint(
        size: Size(double.infinity, 0), // Height of the curved area
        painter: CirclePainter(radius: 200),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> flattenedHotelList = [];

    hotelList.forEach((rating, hotels) {
      if (hotels is List) {
        flattenedHotelList.addAll(hotels.whereType<Map<String, dynamic>>());
      }
    });

    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Colors.white,
      //   leading: IconButton(
      //     onPressed: () {
      //       Navigator.pop(context);
      //     },
      //     icon: Icon(Icons.arrow_back),
      //   ),
      //   title: AppLargeText(
      //     text: 'Accommodation',
      //     size: 24,
      //   ),
      // ),
      body: Container(
        color: Colors.white,
        child: Column(
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
                Text('HOTELS',
                    style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.white))
              ],
            ),
            Expanded(
              child: isLoading
                  ? const HotelCardShimmer()
                  : flattenedHotelList.isEmpty
                      ? Center(
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
                      : ListView.builder(
                          itemCount: flattenedHotelList.length,
                          itemBuilder: (_, index) {
                            return Padding(
                              padding: const EdgeInsets.only(
                                  left: 8, right: 8, bottom: 12),
                              child: isLoading
                                  ? const HotelCardShimmer()
                                  : HotelCard(
                                      hotel: flattenedHotelList[index],
                                      isSelected: selectedHotelIndex == index,
                                      onTap: () {
                                        setState(() {
                                          selectedHotelIndex = index;
                                        });
                                      },
                                    ),
                            );
                          },
                        ),
            ),
            isLoading == true
                ? Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        height: 50,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  )
                : flattenedHotelList.isEmpty
                    ? Container()
                    : Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: GestureDetector(
                          onTap: () {
                            if(widget.showFlightPage == 0) { // flight available
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => FlightPageFD(
                                    activityList: widget.activityList,
                                    selectedHotel: flattenedHotelList[selectedHotelIndex],
                                    packageData: widget.packageData,
                                    // flightList: flightList,
                                    totalRoomsdata: widget.totalRoomsdata,
                                    searchId: searchId,
                                    showTourPage: widget.showTourPage,
                                  ),
                                ),
                              );
                            } else if(widget.showTourPage != "0"){
                              _updateHotelDetails(flattenedHotelList[selectedHotelIndex]['git_adhoc_hotel_id']);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => TourBookingPage(packageDetails: widget.packageData, selectedHotel: flattenedHotelList[selectedHotelIndex], flightDetails: [], totalRoomsdata: widget.totalRoomsdata, searchId: searchId, fixedActivities: widget.activityList)
                                ),
                              );
                            } else {
                              _updateHotelDetails(flattenedHotelList[selectedHotelIndex]['git_adhoc_hotel_id']);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => BookingSummaryFD(packageDetails: widget.packageData, selectedHotel: flattenedHotelList[selectedHotelIndex], flightDetails: [], totalRoomsdata: widget.totalRoomsdata, searchId: searchId, activityList: [], destination: "")
                                ),
                              );
                            }
                          },
                          child: Padding(
                              padding: const EdgeInsets.only(bottom: 20.0),
                              child: responciveButton(text: "Book Now")),
                        ),
                      ),
          ],
        ),
      ),
    );
  }
}

class HotelCard extends StatefulWidget {
  final Map<String, dynamic> hotel;
  final bool isSelected;
  final VoidCallback onTap;

  const HotelCard({
    super.key,
    required this.hotel,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<HotelCard> createState() => _HotelCardState();
}

class _HotelCardState extends State<HotelCard> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final String roomType = widget.hotel["room_category"] ?? 'N/A';
    final String mealType = widget.hotel["meal_plan"] ?? 'N/A';
    final String occupancy = widget.hotel["occupacy"] ?? 'N/A';
    final String price = widget.hotel["total_price"].toString();
    final int star = int.parse(widget.hotel["rating"] ?? 0);

    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 8,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Use Stack to layer the text over the image
          Stack(
            children: [
              // Image widget
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                child: Stack(
                  children: [
                    // Image
                    Image.network(
                      widget.hotel["image"] ??
                          "https://www.pngkey.com/png/full/360-3608307_placeholder-hotel-house.png",
                      fit: BoxFit.cover,
                      width: screenWidth,
                      height: screenWidth * 0.6,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.network("https://www.pngkey.com/png/full/360-3608307_placeholder-hotel-house.png");
                      }, // Adjust the height of the image as needed
                    ),
                    // Semi-transparent black overlay
                    Container(
                      width: screenWidth,
                      height: screenWidth * 0.6, // Same height as the image
                      color: Colors.black
                          .withOpacity(0.3), // Adjust opacity for darkness
                    ),
                  ],
                ),
              ),
              // Positioned text for hotel name (bottom left)
              Positioned(
                bottom: 10,
                left: 10,
                child: SizedBox(
                  width: screenWidth * 0.5, // 50% of screen width
                  child: Text(
                    widget.hotel["hotel"].toUpperCase(),
                    style: TextStyle(
                      fontSize: screenWidth * 0.05,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    softWrap: true,
                    maxLines: 2, // Optional: limits to 2 lines, remove if you want unlimited
                    overflow: TextOverflow.visible, // or .ellipsis if you want to trim long text
                  ),
                ),
              ),
              // Positioned stars for ratings (bottom right)
              Positioned(
                bottom: 10,
                right: 10,
                child: Container(
                  padding:
                      EdgeInsets.all(3), // Optional padding around the stars
                  child: Row(
                    children: List.generate(star, (index) {
                      return Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: screenWidth * 0.05, // Adjust size as needed
                      );
                    }),
                  ),
                ),
              ),
            ],
          ),
          // Content below the image
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
                        width:
                            screenWidth * 0.6, // Fixed width for the city text
                        child: Text(
                          widget.hotel["city"] ?? "N/A",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: screenWidth * 0.04,
                            fontWeight: FontWeight.bold,
                          ),
                          softWrap:
                              true, // Allow the text to wrap to the next line
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
                                width: screenWidth *
                                    0.5, // Fixed width for the room type text
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
                                width: screenWidth *
                                    0.5, // Fixed width for the room occupancy text
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
                                width: screenWidth *
                                    0.5, // Fixed width for the meals plan text
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
                            onPressed: widget.onTap,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: widget.isSelected
                                  ? Color(0xFF0071BC)
                                  : Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              side: BorderSide(color: Color(0xFF0071BC)),
                            ),
                            child: Text(
                              widget.isSelected ? 'SELECTED' : 'SELECT',
                              style: TextStyle(
                                color: widget.isSelected
                                    ? Colors.white
                                    : Color(0xFF0071BC),
                                fontSize: screenWidth * 0.030,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
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

class HotelCardShimmer extends StatelessWidget {
  const HotelCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 8,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 150,
              color: Colors.grey[300],
            ),
            Padding(
              padding: EdgeInsets.all(screenWidth * 0.04),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      width: screenWidth * 0.5,
                      height: 16,
                      color: Colors.grey[300]),
                  SizedBox(height: 8),
                  Container(
                      width: screenWidth * 0.3,
                      height: 14,
                      color: Colors.grey[300]),
                  SizedBox(height: 16),
                  Container(
                      width: screenWidth * 0.7,
                      height: 14,
                      color: Colors.grey[300]),
                  SizedBox(height: 4),
                  Container(
                      width: screenWidth * 0.6,
                      height: 14,
                      color: Colors.grey[300]),
                  SizedBox(height: 4),
                  Container(
                      width: screenWidth * 0.5,
                      height: 14,
                      color: Colors.grey[300]),
                  SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    height: 40,
                    color: Colors.grey[300],
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
