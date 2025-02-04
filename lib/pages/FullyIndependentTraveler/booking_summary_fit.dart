import 'package:flutter/material.dart';
import 'package:holdidaymakers/pages/FullyIndependentTraveler/travelers_details.dart';
import 'package:holdidaymakers/utils/api_handler.dart';
import 'package:holdidaymakers/widgets/responciveButton.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

class BookingSummaryFIT extends StatefulWidget {
  final Map<String, dynamic> responceData;
  final Map<String, dynamic> selectedHotel;
  final List<Map<String, dynamic>> roomArray;
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

  @override
  void initState() {
    super.initState();
    bookingApiDataIntlize();
    bookingSummaryFIT();
    print("================================================");
    print(widget.roomArray);
    print("================================================");
  }

  void bookingApiDataIntlize() {
    final hotel = widget.selectedHotel;
    final searchParms = widget.responceData["data"]["search_params"];
    final roomArray = widget.responceData["data"]["room_array"];
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
        "room_array": roomArray
      };
    });
  }

  Future<void> bookingSummaryFIT() async {
    try {
      print("Sending API Request with Data: $bookingApiData");
      Map<String, dynamic> response =
          await APIHandler.fitBookingSummary(bookingApiData);

      print("API Response: ${response["data"]["search_parms"]}");

      if (response["message"] == "success") {
        setState(() {
          bookingSummreyData = response;
          packagedetails();
        });
        print(
            "Booking Summary Data Updated: ${bookingSummreyData["data"]["search_parms"]}");
      } else {
        print("API Error: ${response["message"]}");
      }
    } catch (error) {
      print("Exception in API Call: $error");
    }
  }

  void packagedetails() {
    // final searchparams = bookingSummreyData["data"]["search_parms"];
    final searchParms = bookingSummreyData["data"]["search_parms"];
    final hotel = bookingSummreyData["data"]["result"]["hotel"];
    final amount = bookingSummreyData["data"];

    if (searchParms != null && hotel != null && amount != null) {
      int n = int.parse(searchParms["no_of_nights"]) - 1;
      String night = n.toString();
      // Parsing the check_out_date String to DateTime
      DateTime checkInDateTime = DateTime.parse(searchParms["check_in_date"]);
      DateTime checkOutDateTime = DateTime.parse(searchParms["check_out_date"]);
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
      body: SingleChildScrollView(
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
              SizedBox(height: 10),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: (screenWidth > 600) ? 3 : 2,
                  crossAxisSpacing: screenWidth * 0.02,
                  mainAxisSpacing: screenWidth * 0.02,
                  childAspectRatio: 2,
                ),
                itemCount: packageDetails.length,
                itemBuilder: (context, index) {
                  return _buildDetailBox(
                    packageDetails[index]['title']!,
                    packageDetails[index]['value']!,
                    fontSize,
                  );
                },
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
              SizedBox(height: 10),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: (screenWidth > 600) ? 3 : 2,
                  crossAxisSpacing: screenWidth * 0.02,
                  mainAxisSpacing: screenWidth * 0.02,
                  childAspectRatio: 2,
                ),
                itemCount: hotelDetails.length,
                itemBuilder: (context, index) {
                  return _buildDetailBox(
                    hotelDetails[index]['title']!,
                    hotelDetails[index]['value']!,
                    fontSize,
                  );
                },
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
              SizedBox(height: 10),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: (screenWidth > 600) ? 3 : 2,
                  crossAxisSpacing: screenWidth * 0.02,
                  mainAxisSpacing: screenWidth * 0.02,
                  childAspectRatio: 2,
                ),
                itemCount: transferDetails.length,
                itemBuilder: (context, index) {
                  return _buildDetailBox(
                    transferDetails[index]['title']!,
                    transferDetails[index]['value']!,
                    fontSize,
                  );
                },
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
              SizedBox(height: 10),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: (screenWidth > 600) ? 3 : 2,
                  crossAxisSpacing: screenWidth * 0.02,
                  mainAxisSpacing: screenWidth * 0.02,
                  childAspectRatio: 2,
                ),
                itemCount: priceDetails.length,
                itemBuilder: (context, index) {
                  return _buildDetailBox(
                    priceDetails[index]['title']!,
                    priceDetails[index]['value']!,
                    fontSize,
                  );
                },
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
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

  Widget _buildShimmerEffect() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 10,
                width: 100,
                color: Colors.white,
              ),
              SizedBox(height: 10),
              Container(
                height: 10,
                width: 150,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Function to build the details box
}
