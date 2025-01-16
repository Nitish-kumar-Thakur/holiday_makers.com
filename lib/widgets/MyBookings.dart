import 'package:flutter/material.dart';
import 'package:holdidaymakers/widgets/Blogs.dart';
class MyBookings extends StatefulWidget {
  @override
  _MyBookingsState createState() => _MyBookingsState();
}

class _MyBookingsState extends State<MyBookings> {
  Color holidaysColor = Colors.white;
  Color cruiseColor = Colors.white;
  bool isUnderline = false;

  void _changeColor(String type) {
    setState(() {
      if (type == 'holidays') {
        holidaysColor = holidaysColor == Colors.white
            ? Colors.blueAccent.withOpacity(0.6)
            : Colors.white;
      } else if (type == 'cruise') {
        cruiseColor = cruiseColor == Colors.white
            ? Colors.blueAccent.withOpacity(0.6)
            : Colors.white;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
            color : Colors.white,
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Back Arrow
            Padding(
              padding: const EdgeInsets.only(top: 40, left: 10),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MakeBlog()),
                  );
                },
                child: Icon(Icons.arrow_back, size: 30),
              ),
            ),
            // Title Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "My Bookings",
                    style: TextStyle(fontSize: 30, color: Colors.grey),
                  ),
                  Text(
                    "View and manage all your bookings",
                    style: TextStyle(fontSize: 20, color: Colors.grey),
                  ),
                ],
              ),
            ),
            SizedBox(height: 40),
            // Holidays and Cruise Section
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Holidays Column
                _buildBookingCard(
                  type: 'holidays',
                  color: holidaysColor,
                  imagePath: 'assets/images/holidaystree.png',
                  title: 'Holidays',
                  bookings: '2 booking(s)',
                ),
                // Cruise Column
                _buildBookingCard(
                  type: 'cruise',
                  color: cruiseColor,
                  imagePath: 'assets/images/cruise-ship.png',
                  title: 'Cruise',
                  bookings: '2 booking(s)',
                ),
              ],
            ),
            // Tabs Section
            Container(
              margin: EdgeInsets.only(top: 20,bottom: 10),
              height: 60,
              color: Colors.blueAccent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildTab("Upcoming"),
                  _buildTab("Completed"),
                  _buildTab("Cancelled"),
                ],
              ),
            ),
            // Featured Booking Section
            _buildFeaturedBooking(),
            _buildProfileSection('assets/images/GroupTree.png', 'Lucknow'),
            // Detailed Booking Section
            _buildDetailedBooking(),
          ],
        ),
        ),
      ),
    );
  }

  Widget _buildBookingCard({
    required String type,
    required Color color,
    required String imagePath,
    required String title,
    required String bookings,
  }) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            _changeColor(type);
          },
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            height: 80,
            width: 100,
            decoration: BoxDecoration(
              color: color,
              border: Border.all(color: Colors.blue.withOpacity(0.5), width: 2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        SizedBox(height: 8),
        Text(
          title,
          style: TextStyle(fontSize: 16, color: Colors.grey[600], fontWeight: FontWeight.w600),
        ),
        Text(
          bookings,
          style: TextStyle(fontSize: 14, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildTab(String label) {
    return GestureDetector(
      onTap: () {
        print(label);
      },
      child: Text(
        label,
        style: TextStyle(
          color: Colors.white,
          fontSize: 25,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildFeaturedBooking() {
    return Container(
      // margin: EdgeInsets.only(le),
      height: 230,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: Image.asset(
              'assets/images/GroupTree.png',
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),
          Positioned(
            top: 100,
            left: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Lucknow & Delhi",
                  style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700),
                ),
                Text(
                  "10 Jan - 13 Jan",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                Text(
                  "2 Flights",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildProfileSection(String imagePath, String title) {
    return Container(
      margin: EdgeInsets.only(left: 15,top: 20),
      child: Row(
        children: [
          Container(
            height: 60,
            width: 60,
            margin: EdgeInsets.only(right: 15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40),
            ),
            child: ClipOval(
              child: Image.asset(
                imagePath,
                height: 60,
                width: 60,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 22,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailedBooking() {
    return Row(
      children: [
        Container(
          margin: EdgeInsets.only(left: 43),
          height: 390,
          width: 2,
          color: Colors.grey[600],
        ),
        Container(
          margin: EdgeInsets.only(left: 15),
          height: 380,
          width: 440,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                offset: Offset(0, 4),
                blurRadius: 6,
                spreadRadius: 2,
              ),
            ],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildBookingDetails(),
              _buildStatusSection(),
              Container(
                margin: EdgeInsets.only(left: 10,right: 10),
                height: 2,
                decoration: BoxDecoration(
                  color: Colors.grey[500]
                ),
              ),
              _buildActionButtons(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBookingDetails() {
    return Column(
      children: [
      Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                color: Colors.blueAccent.withOpacity(0.5),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Image.asset('assets/images/airoplane.png', fit: BoxFit.cover),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "12230",
                  style: TextStyle(fontSize: 20, color: Colors.grey[600]),
                ),
                Text(
                  "LUCKNOW MAIL",
                  style: TextStyle(fontSize: 20, color: Colors.grey[600]),
                ),
              ],
            ),
          ],
        ),
        Container(
          margin: EdgeInsets.only(right: 10),
          child: Text(
            "Melissa Peters",
            style: TextStyle(fontSize: 20, color: Colors.grey[600]),
          ),
        )
      ]),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("New Delhi (NDLS)",
                  style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 20,
                      fontWeight: FontWeight.w800
                  ),),
                Text("22:00",
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.grey[500]

                  ),),
                Text("Fri ,10 Jan 25",
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.grey[500]

                  ),),
              ],
            ),
            Icon(
              Icons.arrow_forward,
              size: 40,
            ),

            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text("Lucknow (LKO)",
                  style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 20,
                      fontWeight: FontWeight.w800
                  ),),
                Text("06:40",
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.grey[500]

                  ),),
                Text("Sat ,11 Jan 25",
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.grey[500]
                  ),),
              ],
            )
          ],
        ),
      ]
    );
  }

  Widget _buildStatusSection() {
    return Container(
      margin: EdgeInsets.all(10),
      height: 60,
      decoration: BoxDecoration(
        color: Colors.blueAccent.withOpacity(0.2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            width: 150,
            child: Text(
              "Check your ticket current status",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 18),
            ),
          ),
          InkWell(
            onTap: () {
              setState(() {
                isUnderline = !isUnderline;
              });
              print("Check Status Clicked");
            },
            child: Text(
              "Check Status",
              style: TextStyle(
                color: Colors.redAccent,
                fontSize: 25,
                fontWeight: FontWeight.w700,
                decoration: isUnderline ? TextDecoration.underline : TextDecoration.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Container(
      margin: EdgeInsets.all(10),
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              side: BorderSide(color: Colors.redAccent, width: 2),
            ),
            child: Text(
              "Download Ticket",
              style: TextStyle(color: Colors.redAccent, fontSize: 15, fontWeight: FontWeight.w900),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [Colors.orange, Colors.redAccent]),
              borderRadius: BorderRadius.circular(10),
            ),
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                foregroundColor: Colors.white,
              ),
              child: Text(
                "Modify Ticket",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


