import 'package:flutter/material.dart';

class MyBookings extends StatefulWidget {
  const MyBookings({super.key});

  @override
  _MyBookingsState createState() => _MyBookingsState();
}

class _MyBookingsState extends State<MyBookings> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, String>> bookings = [
    {
      "image": "img/aus1.jpg",
      "title": "Lucknow - Delhi",
      "date": "10 Jan - 13 Jan",
      "train": "Lucknow Mail",
      "passenger": "Melissa Peters",
      "from": "New Delhi (NDLS)",
      "fromTime": "22:00 - Fri, 10 Jan 25",
      "to": "Lucknow (LKO)",
      "toTime": "06:40 - Sat, 11 Jan 25"
    },
    {
      "image": "img/can1.jpg",
      "title": "Mumbai - Pune",
      "date": "15 Feb - 18 Feb",
      "train": "Deccan Express",
      "passenger": "John Doe",
      "from": "Mumbai (CST)",
      "fromTime": "07:00 - Sat, 15 Feb 25",
      "to": "Pune (PUNE)",
      "toTime": "10:30 - Sat, 15 Feb 25"
    },
    {
      "image": "img/cyp1.jpg",
      "title": "Chennai - Bangalore",
      "date": "20 Mar - 25 Mar",
      "train": "Shatabdi Express",
      "passenger": "Alice Smith",
      "from": "Chennai (MAS)",
      "fromTime": "06:00 - Wed, 20 Mar 25",
      "to": "Bangalore (SBC)",
      "toTime": "09:45 - Wed, 20 Mar 25"
    }
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
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
      body: Column(
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
      itemCount: bookings.length,
      itemBuilder: (context, index) {
        final booking = bookings[index];
        return Card(
          color: Colors.white70,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 4,
          margin: const EdgeInsets.only(bottom: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.asset(booking["image"]!, fit: BoxFit.cover, height: 150, width: double.infinity),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(booking["title"]!, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(booking["date"]!, style: TextStyle(color: Colors.grey[600])),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.train, color: Colors.blueAccent),
                        const SizedBox(width: 8),
                        Text(booking["train"]!),
                        const Spacer(),
                        Text(booking["passenger"]!),
                      ],
                    ),
                    const Divider(height: 20, thickness: 1),
                    Row(
                      children: [
                        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(booking["from"]!, style: TextStyle(fontWeight: FontWeight.bold)), Text(booking["fromTime"]!)]),
                        const Spacer(),
                        Column(crossAxisAlignment: CrossAxisAlignment.end, children: [Text(booking["to"]!, style: TextStyle(fontWeight: FontWeight.bold)), Text(booking["toTime"]!)]),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(onPressed: () {}, style: ElevatedButton.styleFrom(backgroundColor: Colors.red), child: const Text("Download Ticket", style: TextStyle(color: Colors.white))),
                        ElevatedButton(onPressed: () {}, style: ElevatedButton.styleFrom(backgroundColor: Colors.orange), child: const Text("Modify Booking", style: TextStyle(color: Colors.white))),
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
