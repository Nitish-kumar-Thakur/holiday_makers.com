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
    final double screenWidth = MediaQuery.of(context).size.width;
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: bookingList.length,
      itemBuilder: (context, index) {
        final booking = bookingList[index];
        return Card(
          color: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 4,
          margin: const EdgeInsets.only(bottom: 20),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Package Header
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        booking["package_name"] ?? "N/A",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Icon(Icons.location_on, color: Colors.blue, size: 20),
                    const SizedBox(width: 4),
                    Text(
                      booking["destination"] ?? "N/A",
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),

                const SizedBox(height: 12),
                const Divider(),

                // Reference & Date
                _buildLabelValueRow("Reference No.", booking["booking_ref_no"]),
                _buildLabelValueRow(
                    "Booking Date", booking["booking_created_datetime"]),
                _buildLabelValueRow(
                    "Payment Status", booking["payment_status"]),
                _buildLabelValueRow(
                    "Booking Status", booking["booking_status"]),
                _buildLabelValueRow("Booking Type", booking["booking_type"]),

                const Divider(),

                // Travel Info
                _buildLabelValueRow("From", booking["travel_date_from"]),
                _buildLabelValueRow("To", booking["travel_date_to"]),
                _buildLabelValueRow(
                    "No. of Pax", booking["no_of_pax"].toString()),
                _buildLabelValueRow(
                    "Total Amount", 'AED ${booking["total_amount"] ?? "N/A"}'),

                if ((booking["booking_voucher"] ?? "").isNotEmpty)
                  _buildLabelValueRow(
                      "Booking Voucher", booking["booking_voucher"]),

                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            final voucherUrl = booking["booking_voucher"];
                            if (voucherUrl != null && voucherUrl.isNotEmpty) {
                              _downloadTicket(voucherUrl);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text("No booking voucher available.")),
                              );
                            }
                          },
                          icon: const Icon(Icons.download, color: Colors.white),
                          label: Text(
                            "Booking Voucher",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: screenWidth * 0.03),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            final receiptUrl = booking["payment_receipt"];
                            if (receiptUrl != null && receiptUrl.isNotEmpty) {
                              _downloadTicket(receiptUrl);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text("No payment receipt available.")),
                              );
                            }
                          },
                          icon: const Icon(Icons.download, color: Colors.white),
                          label: Text(
                            "Payment Receipt",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: screenWidth * 0.03),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
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
        );
      },
    );
  }

  Widget _buildLabelValueRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value ?? "N/A",
              textAlign: TextAlign.end,
              style: const TextStyle(
                color: Colors.black54,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCruiseList() {
    final double screenWidth = MediaQuery.of(context).size.width;
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: cruiseList.length,
      itemBuilder: (context, index) {
        final booking = cruiseList[index];
        return Card(
          color: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 4,
          margin: const EdgeInsets.only(bottom: 20),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Package Header
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        booking["cruise_name"] ?? "N/A",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Icon(Icons.location_on, color: Colors.blue, size: 20),
                    const SizedBox(width: 4),
                    Text(
                      booking["destination"] ?? "N/A",
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),

                const SizedBox(height: 12),
                const Divider(),

                // Reference & Date
                _buildLabelValueRow("Reference No.", booking["booking_ref_no"]),
                _buildLabelValueRow(
                    "Booking Date", booking["booking_created_datetime"]),
                _buildLabelValueRow(
                    "Payment Status", booking["payment_status"]),
                _buildLabelValueRow(
                    "Booking Status", booking["booking_status"]),
                // _buildLabelValueRow("Booking Type", booking["booking_type"]),

                const Divider(),

                // Travel Info
                _buildLabelValueRow("From", booking["travel_date_from"]),
                _buildLabelValueRow("To", booking["travel_date_to"]),
                _buildLabelValueRow(
                    "No. of Pax", booking["no_of_pax"].toString()),
                _buildLabelValueRow(
                    "Total Amount", 'AED ${booking["total_amount"] ?? "N/A"}'),

                if ((booking["booking_voucher"] ?? "").isNotEmpty)
                  _buildLabelValueRow(
                      "Booking Voucher", booking["booking_voucher"]),

                const SizedBox(height: 16),

                // Download Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            final voucherUrl = booking["booking_voucher"];
                            if (voucherUrl != null && voucherUrl.isNotEmpty) {
                              _downloadTicket(voucherUrl);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text("No booking voucher available.")),
                              );
                            }
                          },
                          icon: const Icon(Icons.download, color: Colors.white),
                          label: Text(
                            "Booking Voucher",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: screenWidth * 0.03),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            final receiptUrl = booking["payment_receipt"];
                            if (receiptUrl != null && receiptUrl.isNotEmpty) {
                              _downloadTicket(receiptUrl);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text("No payment receipt available.")),
                              );
                            }
                          },
                          icon: const Icon(Icons.download, color: Colors.white),
                          label: Text(
                            "Payment Receipt",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: screenWidth * 0.03),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
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
