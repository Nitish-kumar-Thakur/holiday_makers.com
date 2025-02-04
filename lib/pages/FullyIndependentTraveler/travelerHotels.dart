import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:holdidaymakers/pages/FullyIndependentTraveler/flightPage.dart';
import 'package:holdidaymakers/widgets/appLargetext.dart';
import 'package:holdidaymakers/widgets/appText.dart';
import 'package:shimmer/shimmer.dart';

class Travelerhotels extends StatefulWidget {
  final Map<String, dynamic> responceData;
  final List<Map<String, dynamic>> roomArray;
  const Travelerhotels({super.key, required this.responceData , required this.roomArray});

  @override
  State<Travelerhotels> createState() => _TravelerhotelsState();
}

class _TravelerhotelsState extends State<Travelerhotels> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    // Simulate a network delay to fetch hotel data
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        isLoading = false;
      });
    });
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

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final hotelList = List<Map<String, dynamic>>.from(
        widget.responceData['data']['hotel_list']);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: screenHeight * 0.3,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('img/hotel1.png'),
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
            // SizedBox(height: screenHeight * 0.02),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(color: Colors.grey.shade200),
              child: Padding(
                padding: EdgeInsets.all(screenWidth * 0.03),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppLargeText(
                      text: 'INCLUSION',
                      size: screenWidth * 0.06,
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        buildInclusionCard(FontAwesomeIcons.plane, 'Flights'),
                        buildInclusionCard(FontAwesomeIcons.hotel, 'Hotels'),
                        buildInclusionCard(FontAwesomeIcons.car, 'Transfers'),
                        buildInclusionCard(FontAwesomeIcons.userShield, 'Insurance'),
                        buildInclusionCard(FontAwesomeIcons.user, 'Tour Guide'),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    SizedBox(
                      height: screenHeight * 0.6,
                      child: isLoading
                          ? _buildShimmerGrid(screenWidth)
                          : ListView.builder(
                              itemCount: hotelList.length,
                              itemBuilder: (_, index) {
                                return Padding(
                                  padding: EdgeInsets.only(
                                      bottom: screenHeight * 0.09),
                                  child: HotelCard(
                                    hotel: hotelList[index],
                                    responceData: widget.responceData,
                                    roomArray: widget.roomArray,
                                  ),
                                );
                              },
                            ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
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
                  Container(height: 15, width: screenWidth * 0.5, color: Colors.grey),
                  SizedBox(height: 8),
                  Container(height: 12, width: screenWidth * 0.3, color: Colors.grey),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(height: 12, width: screenWidth * 0.4, color: Colors.grey),
                      Container(height: 12, width: screenWidth * 0.2, color: Colors.grey),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: List.generate(5, (index) => Icon(
                          Icons.star,
                          color: Colors.grey,
                          size: screenWidth * 0.04,
                        )),
                  ),
                  SizedBox(height: 12),
                  Container(height: 15, width: screenWidth * 0.25, color: Colors.grey),
                  SizedBox(height: 5),
                  Container(height: 12, width: screenWidth * 0.2, color: Colors.grey),
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
  final Map<String, dynamic> hotel;
  final Map<String, dynamic> responceData;
  final List<Map<String, dynamic>> roomArray;

  const HotelCard({super.key, required this.hotel, required this.responceData, required this.roomArray});

  @override
  State<HotelCard> createState() => _HotelCardState();
}

class _HotelCardState extends State<HotelCard> {
  _selectButton() {
    // print(widget.hotel);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FlightPage(
            selectedHotel: widget.hotel, responceData: widget.responceData, roomArray: widget.roomArray,),
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
                        Text(
                          widget.hotel["hotel_name"],
                          style: TextStyle(
                            fontSize: screenWidth * 0.035,
                            fontWeight: FontWeight.bold,
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
