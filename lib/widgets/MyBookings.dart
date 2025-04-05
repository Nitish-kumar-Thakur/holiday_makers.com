import 'dart:io';

import 'package:HolidayMakers/utils/api_handler.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:open_file/open_file.dart';

class MyBookings extends StatefulWidget {
  const MyBookings({super.key});

  @override
  _MyBookingsState createState() => _MyBookingsState();
}

class _MyBookingsState extends State<MyBookings>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  List<dynamic> bookingList = [];
  List<dynamic> cruiseList = [];
  bool isLoading = true;
  String selectedCategory = 'Holiday';

  @override
  void initState() {
    super.initState();
    _BookingHistoryList();
    _tabController = TabController(length: 3, vsync: this);
  }

  Future<void> _BookingHistoryList() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString("user_id") ?? "";
      // final response = await APIHandler.getFITTourList(widget.searchId ?? "");
      final response = await APIHandler.bookingHistoryList({"user_id": userId});
      setState(() {
        bookingList = response["data"]["package_booking_list"];
        cruiseList = response["data"]["cruise_booking_list"];
        // print("booking details: $bookingList");
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching booking List: $e");
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

  Future<void> _downloadTicket(String url) async {
    try {
      // Request storage permission
      if (Platform.isAndroid &&
          await Permission.manageExternalStorage.request().isGranted) {
        // Get the Downloads directory (for public access)
        final directory = await getExternalStorageDirectory();
        final downloadsDirectory = Directory('/storage/emulated/0/Download');

        // If the Downloads folder doesn't exist, it will create one.
        if (!await downloadsDirectory.exists()) {
          await downloadsDirectory.create(recursive: true);
        }

        final filePath = '${downloadsDirectory.path}/Invoice.pdf';

        // Use Dio to download the file
        final dio = Dio();
        await dio.download(url, filePath);

        // Check if the file exists after download
        if (await File(filePath).exists()) {
          Fluttertoast.showToast(msg: 'Download completed!');

          // Open the PDF file
          print("downloadPAth $filePath");
          OpenFile.open(filePath);
        } else {
          Fluttertoast.showToast(msg: 'Failed to find the file.');
        }
      } else {
        Fluttertoast.showToast(
            msg: 'Storage permission denied. Please allow it in settings.');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Failed to download: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Container(
              color: Colors.white, // Add background color
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
                          backgroundColor: Colors.grey.withOpacity(0.6),
                          child: Text(
                            '<',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text('MY BOOKINGS',
                          style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: Colors.white))
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _bookingCategory(Icons.beach_access, "Holiday"),
                        _bookingCategory(Icons.directions_boat, "Cruise"),
                      ],
                    ),
                  ),
                  Expanded(
                      child: selectedCategory == 'Holiday'
                          ? _buildBookingList()
                          : _buildCruiseList()),
                ],
              ),
            ),
    );
  }

  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: const Text(
  //         'My Bookings',
  //         style: TextStyle(fontWeight: FontWeight.bold),
  //       ),
  //       centerTitle: true,
  //       backgroundColor: Colors.blueAccent,
  //       foregroundColor: Colors.white,
  //     ),
  //     body: isLoading
  //         ? Center(
  //             child: CircularProgressIndicator(),
  //           )
  //         : Column(
  //             children: [
  //               // Padding(
  //               //   padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
  //               //   child: Row(
  //               //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //               //     children: [
  //               //       _bookingCategory(Icons.beach_access, "Holiday", "2 bookings"),
  //               //       _bookingCategory(Icons.directions_boat, "Cruise", "3 bookings"),
  //               //     ],
  //               //   ),
  //               // ),
  //               const SizedBox(height: 10),
  //               Padding(
  //                 padding: const EdgeInsets.symmetric(horizontal: 16.0),
  //                 child: TabBar(
  //                   controller: _tabController,
  //                   labelColor: Colors.white,
  //                   unselectedLabelColor: Colors.blueAccent,
  //                   indicator: BoxDecoration(
  //                     color: Colors.blueAccent,
  //                     borderRadius: BorderRadius.circular(12.0),
  //                   ),
  //                   tabs: const [
  //                     Padding(
  //                       padding: EdgeInsets.symmetric(horizontal: 16.0),
  //                       child: Tab(text: "Upcoming"),
  //                     ),
  //                     Padding(
  //                       padding: EdgeInsets.symmetric(horizontal: 16.0),
  //                       child: Tab(text: "Completed"),
  //                     ),
  //                     Padding(
  //                       padding: EdgeInsets.symmetric(horizontal: 16.0),
  //                       child: Tab(text: "Cancelled"),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //               Expanded(
  //                 child: TabBarView(
  //                   controller: _tabController,
  //                   children: [
  //                     _buildBookingList(),
  //                     Center(child: Text("No Completed Bookings")),
  //                     Center(child: Text("No Cancelled Bookings")),
  //                   ],
  //                 ),
  //               ),
  //             ],
  //           ),
  //   );
  // }

  Widget _bookingCategory(IconData icon, String title) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCategory = title;
        });
      },
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor:
                selectedCategory == title ? Colors.blue : Colors.black,
            radius: 25,
            child: Icon(icon, color: Colors.white, size: 30),
          ),
          const SizedBox(height: 5),
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: selectedCategory == title ? Colors.white : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: bookingList.length,
      itemBuilder: (context, index) {
        final booking = bookingList[index];
        // print("buildBooking List $booking");
        return Card(
          color: Colors.white70,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 4,
          margin: const EdgeInsets.only(bottom: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(booking["package_name"] ?? "N/A",
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    // Row(
                    //   children: [
                    //     Text(booking["destination_name"] ?? "N/A"),
                    //     const Spacer(),
                    //     Text(booking["travel_date_from"] ?? "N/A", style: TextStyle(color: Colors.grey[600])),
                    //   ],
                    // ),
                    Text(booking["destination_name"] ?? "N/A"),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.library_books,
                            color: Colors.blueAccent),
                        const SizedBox(width: 8),
                        Text(booking["payment_status"] ?? "N/A"),
                      ],
                    ),
                    const Divider(
                        height: 20, thickness: 1, color: Colors.black),
                    Row(
                      children: [
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(booking["travel_date_from"] ?? "N/a",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold)),
                              // Text(booking["fromTime"] ?? "N/A")
                            ]),
                        const Spacer(),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(booking["travel_date_to"] ?? "N/a",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold)),
                              // Text(booking["toTime"] ?? "N/A")
                            ]),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          final pdfUrl = booking["receipt_pdf"];
                          if (pdfUrl != null && pdfUrl.isNotEmpty) {
                            _downloadTicket(pdfUrl);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("No receipt available.")),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        child: const Text(
                          "Download Ticket",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCruiseList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: cruiseList.length,
      itemBuilder: (context, index) {
        final booking = cruiseList[index];
        // print("buildBooking List $booking");
        return Card(
          color: Colors.white70,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 4,
          margin: const EdgeInsets.only(bottom: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(booking["cruise_name"] ?? "N/A",
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    // Row(
                    //   children: [
                    //     Text(booking["destination_name"] ?? "N/A"),
                    //     const Spacer(),
                    //     Text(booking["travel_date_from"] ?? "N/A", style: TextStyle(color: Colors.grey[600])),
                    //   ],
                    // ),
                    Text(booking["destination_name"] ?? "N/A"),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.library_books,
                            color: Colors.blueAccent),
                        const SizedBox(width: 8),
                        Text(booking["payment_status"] ?? "N/A"),
                      ],
                    ),
                    const Divider(
                        height: 20, thickness: 1, color: Colors.black),
                    Row(
                      children: [
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(booking["travel_date_from"] ?? "N/a",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold)),
                              // Text(booking["fromTime"] ?? "N/A")
                            ]),
                        const Spacer(),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(booking["travel_date_to"] ?? "N/a",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold)),
                              // Text(booking["toTime"] ?? "N/A")
                            ]),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Center(
                      child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red),
                          child: const Text("Download Ticket",
                              style: TextStyle(color: Colors.white))),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
