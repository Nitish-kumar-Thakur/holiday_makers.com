import 'package:flutter/material.dart';
import 'package:HolidayMakers/pages/FixedDeparturesPages/flightPageFD.dart';
import 'package:HolidayMakers/utils/api_handler.dart';
import 'package:HolidayMakers/widgets/appLargetext.dart';
import 'package:HolidayMakers/widgets/responciveButton.dart';
import 'package:shimmer/shimmer.dart';

class HotelsAccommodation extends StatefulWidget {
  final List<dynamic> activityList;
  final Map<String, dynamic> packageData;
  final List<dynamic> totalRoomsdata;
  const HotelsAccommodation(
      {super.key,
      required this.packageData,
      required this.totalRoomsdata,
      required this.activityList});

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

  @override
  void initState() {
    print("@@@@@@@@@@@@@@@@Nitish Thakur@@@@@@@@@@@@@@@@");
    print(widget.packageData["dep_date"]);
    print(widget.packageData["package_id"]);
    print("@@@@@@@@@@@@@@@@Nitish Thakur@@@@@@@@@@@@@@@@");

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
      "dep_date": "2024-11-30"
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

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> flattenedHotelList = [];

    hotelList.forEach((rating, hotels) {
      if (hotels is List) {
        flattenedHotelList.addAll(hotels.whereType<Map<String, dynamic>>());
      }
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
        title: AppLargeText(
          text: 'Accommodation',
          size: 24,
        ),
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            Expanded(
              child: isLoading
                  ? const HotelCardShimmer()
                  : ListView.builder(
                      itemCount: flattenedHotelList.length,
                      itemBuilder: (_, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
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
                : Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: GestureDetector(
                      onTap: flattenedHotelList.isEmpty
                          ? null
                          : () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => FlightPageFD(
                                    activityList: widget.activityList,
                                    selectedHotel:
                                        flattenedHotelList[selectedHotelIndex],
                                    packageData: widget.packageData,
                                    // flightList: flightList,
                                    totalRoomsdata: widget.totalRoomsdata,
                                    searchId: searchId,
                                  ),
                                ),
                              );
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
    final String roomType = widget.hotel["room_category"];
    final String mealType = widget.hotel["meal_plan"];
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
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
            child: Image.network(
              widget.hotel["image"],
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
                            widget.hotel["hotel"],
                            style: TextStyle(
                              fontSize: screenWidth * 0.035,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          widget.hotel["city"],
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
                              widget.hotel["check_in"],
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
                              widget.hotel["check_out"],
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
                Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: widget.onTap,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            widget.isSelected ? Colors.red : Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        side: BorderSide(
                            color: Colors.red), // Add a border for visibility
                      ),
                      child: Text(
                        widget.isSelected ? 'SELECTED' : 'SELECT',
                        style: TextStyle(
                          color: widget.isSelected
                              ? Colors.white
                              : Colors.red, // Fix text color
                          fontSize: 16.0, // Set proper font size
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
