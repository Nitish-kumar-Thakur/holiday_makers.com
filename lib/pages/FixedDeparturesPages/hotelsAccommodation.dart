import 'package:flutter/material.dart';
import 'package:holdidaymakers/pages/FullyIndependentTraveler/flightPage.dart';
import 'package:holdidaymakers/widgets/appLargetext.dart';
import 'package:shimmer/shimmer.dart';

class HotelsAccommodation extends StatefulWidget {
  final Map<String, dynamic> packageData;
  const HotelsAccommodation({super.key, required this.packageData});

  @override
  State<HotelsAccommodation> createState() => _HotelsAccommodationState();
}

class _HotelsAccommodationState extends State<HotelsAccommodation> {
  bool isLoading = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('=============================================');
    print(widget.packageData["hotel_details"]["4"]);
    print('=============================================');
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final hotelList = List<Map<String, dynamic>>.from(
        widget.packageData["hotel_details"]["4"] ?? []);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back)),
        title: AppLargeText(
          text: 'Accommodation',
          size: 24,
        ),
      ),
      body: SingleChildScrollView(
          child: hotelList.isEmpty
              ? Center(
                  child: AppLargeText(text: "Hotel Not Available"),
                )
              : SizedBox(
                  height: MediaQuery.of(context).size.height * 0.9,
                  child:ListView.builder(
                          itemCount: hotelList.length,
                          itemBuilder: (_, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: isLoading ?HotelCardShimmer(): HotelCard(hotel: hotelList[index]),
                            );
                          },
                        ),
                )),
    );
  }

  
}

class HotelCard extends StatefulWidget {
  final Map<String, dynamic> hotel;

  const HotelCard({super.key, required this.hotel});

  @override
  State<HotelCard> createState() => _HotelCardState();
}

class _HotelCardState extends State<HotelCard> {
  _selectButton() {
    // print(widget.hotel);
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => FlightPage(
    //         selectedHotel: widget.hotel, responceData: widget.responceData, roomArray: widget.roomArray,),
    //   ),
    // );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final String roomType = widget.hotel["room_category"];
    final String mealType = widget.hotel["meal_plan"];
    final String price = widget.hotel["price_per_person"].toString() ?? "N/A";
    final int star = int.parse(widget.hotel["rating"] ?? 3);

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
                        Text(
                          widget.hotel["hotel"],
                          style: TextStyle(
                            fontSize: screenWidth * 0.035,
                            fontWeight: FontWeight.bold,
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
                  Container(width: screenWidth * 0.5, height: 16, color: Colors.grey[300]),
                  SizedBox(height: 8),
                  Container(width: screenWidth * 0.3, height: 14, color: Colors.grey[300]),
                  SizedBox(height: 16),
                  Container(width: screenWidth * 0.7, height: 14, color: Colors.grey[300]),
                  SizedBox(height: 4),
                  Container(width: screenWidth * 0.6, height: 14, color: Colors.grey[300]),
                  SizedBox(height: 4),
                  Container(width: screenWidth * 0.5, height: 14, color: Colors.grey[300]),
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

