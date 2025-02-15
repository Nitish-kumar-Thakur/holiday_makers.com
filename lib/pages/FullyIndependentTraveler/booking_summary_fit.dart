import 'package:flutter/material.dart';
import 'package:holdidaymakers/pages/FullyIndependentTraveler/travelers_details.dart';
import 'package:holdidaymakers/utils/api_handler.dart';
import 'package:holdidaymakers/widgets/responciveButton.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

class BookingSummaryFIT extends StatefulWidget {
  final Map<String, dynamic> responceData;
  final Map<String, dynamic> selectedHotel;
  final List<dynamic> roomArray;
  const BookingSummaryFIT(
      {super.key,
      required this.responceData,
      required this.selectedHotel,
      required this.roomArray});

  @override
  State<BookingSummaryFIT> createState() => _BookingSummaryFITState();
}

class _BookingSummaryFITState extends State<BookingSummaryFIT> {
  List<Map<String, dynamic>> packageDetails = [];
  List<Map<String, String>> hotelDetails = [];
  List<Map<String, String>> transferDetails = [];
  List<Map<String, String>> priceDetails = [];
  Map<String, dynamic> bookingApiData = {};
  Map<String, dynamic> bookingSummreyData = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    bookingApiDataIntlize();
    bookingSummaryFIT();

    // print("================================================");
    // print(widget.roomArray);
    // print("================================================");
  }

  void bookingApiDataIntlize() {
    final hotel = widget.selectedHotel;
    final searchParms = widget.responceData["data"]["search_params"];
    final roomArray = widget.roomArray;
    final onwardFlight = widget.responceData["data"]["flight"]["onward"];
    final returnFlight = widget.responceData["data"]["flight"]["return"];
    final insuranceList = widget.responceData["data"]["insurance_list"];
    setState(() {
      bookingApiData = {
        "hotel_id": hotel["hotel_id"],
        "hotel_fit_id": hotel["id"],
        "onward_flight_id": onwardFlight["flight_details_id"],
        "onward_flight_fare_id": onwardFlight["flight_fare_id"],
        "return_flight_id": returnFlight["flight_details_id"],
        "return_flight_fare_id": returnFlight["flight_fare_id"],
        "ath_transfer_id": hotel["airport_to_hotel_transfer"]
            ["ath_transfer_id"],
        "ath_transfer_price_id": hotel["airport_to_hotel_transfer"]
            ["ath_transfer_price_id"],
        "hta_transfer_id": hotel["hotel_to_airport_transfer"]
            ["hta_transfer_id"],
        "hta_transfer_price_id": hotel["hotel_to_airport_transfer"]
            ["hta_transfer_price_id"],
        "insurance_id": insuranceList["origin"],
        "break_fast": "",
        "search_params": searchParms,
        "room_wise_pax": roomArray
      };
    });
  }

  Future<void> bookingSummaryFIT() async {
    try {
      print("Sending API Request with Data: $bookingApiData");
      Map<String, dynamic> response =
          await APIHandler.fitBookingSummary(bookingApiData);

      print("API Response: ${response["data"]}");

      if (response["message"] == "success") {
        setState(() {
          bookingSummreyData = response;
          packagedetails();
          isLoading = false;
        });
        print(
            "Booking Summary Data Updated: ${bookingSummreyData["data"]}");
      } else {
        print("API Error: ${response["message"]}");
      }
    } catch (error) {
      print("Exception in API Call: $error");
    }
  }

  void packagedetails() {
    // final searchparams = bookingSummreyData["data"]["search_parms"];
    final searchParms = bookingSummreyData["data"]["search_parms"]??[];
    final hotel = bookingSummreyData["data"]["result"]["hotel"]??[];
    final amount = bookingSummreyData["data"]??[];

    if (searchParms != null && hotel != null && amount != null) {
      int n = int.parse(searchParms["no_of_nights"]) - 1;
      String night = n.toString();
      // Parsing the check_out_date String to DateTime
      DateTime checkInDateTime = DateTime.parse(searchParms["check_in_date"]?? null);
      DateTime checkOutDateTime = DateTime.parse(searchParms["check_out_date"]?? null);
      // Formatting it to "dd-MM-yyyy"
      String checkInDate = DateFormat('dd MMM yy, EEE').format(checkInDateTime);
      // Parsing the check_out_date String to DateTime

      // Formatting it to "dd-MM-yyyy"
      String checkOutDate =
          DateFormat('dd MMM yy, EEE').format(checkOutDateTime);
      setState(() {
        packageDetails = [
          {
            "title": "Package",
            "value":
                "${searchParms["source"]}: ${searchParms["destination"]}" ??
                    "N/A"
          },
          // {"title": "Destination", "value": searchParms["destination"] ?? "N/A"},
          {
            "title": "Duration",
            "value": "${searchParms["no_of_nights"]} Days/ $night Night"
          },
          {"title": "Departure Date", "value": checkInDate},
          {"title": "Arrival Date", "value": checkOutDate},
          // {"title": "Arrival Date", "value": searchParms["room_count"] ?? "N/A"},
        ];
        hotelDetails = [
          {"title": "Hotel Name", "value": hotel["hotel_name"]},
          {"title": "Room Type", "value": hotel["room_category_name"]},
          {"title": "Check In Time", "value": hotel["checkin_time"]},
          {"title": "Check Out Time", "value": hotel["checkout_time"]},
          {
            "title": "No. of Rooms",
            "value": searchParms["room_count"] ?? "N/A"
          },
          {"title": "Meal Plan", "value": hotel["meal_type_name"]},
        ];
        transferDetails = [
          {"title": "Arrival Transfer", "value": "Airport to Hotel"},
          {"title": "Return Transfer", "value": "Hotel to Airport"},
        ];
        priceDetails = [
          {
            "title": "Price",
            "value":
                "Total Adult(${hotel["Adult_Count"]})  AED \$${amount["total_adult_amount"].toString()} \n Total Child(${hotel["Child_Count"]})  AED \$${amount["total_child_amount"].toString()} \n Total Infant(${hotel["Infant_Count"]})  AED \$${amount["total_infant_amount"].toString()}"
          },
          {
            "title": "Total",
            "value": "AED \$${amount["total_amount"].toString()}"
          },
        ];
      });
    }
  }

  Widget _buildDetailBox(String title, String value, double fontSize) {
    return Container(
      width: 180,
      height: 95,
      padding: EdgeInsets.all(fontSize * 0.7),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: fontSize * 1.2,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: fontSize * 0.3),
          Text(
            value,
            style: TextStyle(
              fontSize: title == "Price" ? 10 : fontSize,
              fontWeight: FontWeight.normal,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double fontSize = screenWidth * 0.035;

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
          'Booking Summary',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: isLoading == true
          ? _buildShimmerEffect()
          : SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'PACKAGE DETAILS',
                      style: TextStyle(
                        fontSize: fontSize * 1.3,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildDetailBox(
                          packageDetails[0]['title']!,
                          packageDetails[0]['value']!,
                          fontSize,
                        ),
                        _buildDetailBox(
                          packageDetails[1]['title']!,
                          packageDetails[1]['value']!,
                          fontSize,
                        )
                      ],
                    ),
                    SizedBox(height: 20),

                    // Hotel Details Section
                    Text(
                      'HOTEL DETAILS',
                      style: TextStyle(
                        fontSize: fontSize * 1.3,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildDetailBox(
                          hotelDetails[0]['title']!,
                          hotelDetails[0]['value']!,
                          fontSize,
                        ),
                        _buildDetailBox(
                          hotelDetails[1]['title']!,
                          hotelDetails[1]['value']!,
                          fontSize,
                        ),
                      ],
                    ),
                    SizedBox(height: 20),

                    // Transfer Section
                    Text(
                      'TRANSFER DETAILS',
                      style: TextStyle(
                        fontSize: fontSize * 1.3,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildDetailBox(
                          transferDetails[0]['title']!,
                          transferDetails[0]['value']!,
                          fontSize,
                        ),
                        _buildDetailBox(
                          transferDetails[1]['title']!,
                          transferDetails[1]['value']!,
                          fontSize,
                        ),
                      ],
                    ),
                    SizedBox(height: 20),

                    // Price Details Section
                    Text(
                      'PRICE DETAILS',
                      style: TextStyle(
                        fontSize: fontSize * 1.3,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildDetailBox(
                          priceDetails[0]['title']!,
                          priceDetails[0]['value']!,
                          fontSize,
                        ),
                        _buildDetailBox(
                          priceDetails[1]['title']!,
                          priceDetails[1]['value']!,
                          fontSize,
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
      bottomNavigationBar: isLoading == true
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
              padding: EdgeInsets.all(20.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TravelersDetails()),
                  );
                },
                child: responciveButton(text: 'PROCEED TO BOOKING'),
              ),
            ),
    );
  }

  // Function to build the details box
  Widget _buildShimmerEffect() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title shimmer
                Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    height: 20,
                    width: 150,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),

                // Multiple shimmer rows for different sections
                _buildShimmerRow(),
                const SizedBox(height: 20),
                Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    height: 20,
                    width: 150,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                const SizedBox(height: 20),
                _buildShimmerRow(),
                const SizedBox(height: 20),

                Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    height: 20,
                    width: 150,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10), const SizedBox(height: 20),
                _buildShimmerRow(),
                const SizedBox(height: 20),
                Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    height: 20,
                    width: 150,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                const SizedBox(height: 20),
                _buildShimmerRow(),
              ],
            ),
          ),
        ),
      ],
    );
  }

// Function to build shimmer rows
  Widget _buildShimmerRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildShimmerBox(),
        _buildShimmerBox(),
      ],
    );
  }

// Function to create shimmer box for text placeholders
  Widget _buildShimmerBox() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: 180,
        height: 100,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
