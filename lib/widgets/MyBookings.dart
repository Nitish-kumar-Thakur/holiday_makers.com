import 'package:HolidayMakers/utils/api_handler.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyBookings extends StatefulWidget {
  const MyBookings({super.key});

  @override
  _MyBookingsState createState() => _MyBookingsState();
}

class _MyBookingsState extends State<MyBookings>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  List<dynamic> bookingList = [];
  bool isLoading = true;

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
        print("booking details: $bookingList");
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching booking List: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Bookings',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                // Padding(
                //   padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //     children: [
                //       _bookingCategory(Icons.beach_access, "Holiday", "2 bookings"),
                //       _bookingCategory(Icons.directions_boat, "Cruise", "3 bookings"),
                //     ],
                //   ),
                // ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: TabBar(
                    controller: _tabController,
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.blueAccent,
                    indicator: BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    tabs: const [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Tab(text: "Upcoming"),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Tab(text: "Completed"),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Tab(text: "Cancelled"),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildBookingList(),
                      Center(child: Text("No Completed Bookings")),
                      Center(child: Text("No Cancelled Bookings")),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _bookingCategory(IconData icon, String title, String count) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: Colors.blueAccent,
          radius: 25,
          child: Icon(icon, color: Colors.white, size: 30),
        ),
        const SizedBox(height: 5),
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(count, style: TextStyle(color: Colors.grey[600])),
      ],
    );
  }

  Widget _buildBookingList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: bookingList.length,
      itemBuilder: (context, index) {
        final booking = bookingList[index];
        print("buildBooking List $booking");
        return Card(
          color: Colors.white70,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 4,
          margin: const EdgeInsets.only(bottom: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ClipRRect(
              //   borderRadius:
              //       const BorderRadius.vertical(top: Radius.circular(12)),
              //   child: Image.asset(booking["image"]!,
              //       fit: BoxFit.cover, height: 150, width: double.infinity),
              // ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(booking["package_name"] ?? "N/a",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(booking["travel_date_from"].toString() ?? "N/a",
                        style: TextStyle(color: Colors.grey[600])),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.train, color: Colors.blueAccent),
                        const SizedBox(width: 8),
                        Text(booking["payment_status"] ?? "N/a"),
                        const Spacer(),
                        Text(booking["destination_name"] ?? "N/a"),
                      ],
                    ),
                    const Divider(height: 20, thickness: 1),
                    Row(
                      children: [
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(booking["travel_date_from"] ?? "N/a",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              Text(booking["fromTime"] ?? "N/A")
                            ]),
                        const Spacer(),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(booking["travel_date_to"] ?? "N/a",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              Text(booking["toTime"] ?? "N/A")
                            ]),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red),
                            child: const Text("Download Ticket",
                                style: TextStyle(color: Colors.white))),
                        ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange),
                            child: const Text("Modify Booking",
                                style: TextStyle(color: Colors.white))),
                      ],
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
