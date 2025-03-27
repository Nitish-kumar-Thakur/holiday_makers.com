import 'dart:math';
import 'package:flutter/material.dart';
import 'package:HolidayMakers/pages/Cruise/cruisePackagedetails.dart';
import 'package:HolidayMakers/pages/FixedDeparturesPages/departurePackagedetails.dart';
import 'package:intl/intl.dart';

class Subcarousel extends StatefulWidget {
  final List<Map<String, dynamic>> lists;
  final String title;
  final double width;

  const Subcarousel({
    super.key,
    required this.lists,
    required this.title,
    this.width = 250,
  });

  @override
  State<Subcarousel> createState() => _SubcarouselState();
}

class _SubcarouselState extends State<Subcarousel>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    // Initialize the AnimationController for snowflakes if needed
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10), // Slower animation duration
    );

    if (widget.title == "Winter Holidays") {
      _controller.repeat(); // Repeat animation only for "Winter Holidays"
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: SizedBox(
        height: 200, // Set the height for the carousel
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: widget.lists.length,
          itemBuilder: (context, index) {
            final item = widget.lists[index];
            print(item);
            return GestureDetector(
              onTap: () {
                print(item["id"].toString());
                if (item["id"] == "cruise") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CruisePackageDetails(
                              packageId: item["packageId"],
                            )),
                  );
                } else if (item["id"] == "FD") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DeparturePackageDetails(
                            packageId: item["packageId"])),
                  );
                }
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: widget.title == "Winter Holidays"
                    ? _buildWinterHolidayImage(
                        item['image'],
                        item['country'],
                        item['currency'],
                        item['price'].toString(),
                        item['tempPrice'].toString(),
                        item['dep_date'])
                    : _buildStandardImage(
                        item['image'],
                        item['country'],
                        item['currency'],
                        item['price'].toString(),
                        item['tempPrice'].toString(),
                        item['dep_date']),
              ),
            );
          },
        ),
      ),
    );
  }

  // Widget for regular images
  Widget _buildStandardImage(String imageUrl, String countryName,
      String currency, String price, String tempPrice, String date) {
    return Container(
      width: widget.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          // Background Image
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.network(
              imageUrl,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            ),
          ),

          // Overlay for better text visibility (optional)
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Colors.black.withOpacity(0.5), // Dark gradient at the bottom
                  Colors.transparent, // Transparent at the top
                ],
              ),
            ),
          ),

          // Date Label at Top Center
          Positioned(
            top: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius:
                      BorderRadius.only(topRight: Radius.circular(20)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 3,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  formatDate(date),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),

          // Country Name and Pricing Positioned at the Bottom
          Positioned(
            bottom: 40,
            right: 10,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  countryName,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 10,
            right: 10,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.yellow.shade700,
                borderRadius: BorderRadius.circular(2)
              ),
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: '$currency ',
                            style: TextStyle(
                              color: Colors.grey.shade900,
                              fontSize: 8,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          TextSpan(
                            text: '$tempPrice',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              decoration: TextDecoration.lineThrough,
                              decorationColor: Colors.red,
                              decorationThickness: 3,
                            ),
                          ),
                          TextSpan(
                            text: ' $price',
                            style: TextStyle(
                              color: Colors.grey.shade900,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ),
        ],
      ),
    );
  }

  // Widget for images with animated snowflakes
  Widget _buildWinterHolidayImage(String imageUrl, String countryName,
      String currency, String price, String tempPrice, String date) {
    return Stack(
      children: [
        // Background image
        Container(
          width: widget.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            image: DecorationImage(
              image: NetworkImage(imageUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),

        // Snow effect: Positioned over everything (image, text, etc.)
        Positioned.fill(
          child: CustomPaint(
            painter: SnowPainter(animation: _controller), // Snow effect
          ),
        ),

        // Overlay for better text visibility (optional)
        Positioned.fill(
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Colors.black.withOpacity(0.5), // Dark gradient at the bottom
                  Colors.transparent, // Transparent at the top
                ],
              ),
            ),
          ),
        ),

        // Date Label at Top Center
        Positioned(
          top: 0,
          right: 0,
          child: Center(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 7, vertical: 3),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.only(topRight: Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 3,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                formatDate(date),
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),

        // Country Name and Pricing Positioned at the Bottom
        Positioned(
          bottom: 40,
          right: 10,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                countryName,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        Positioned(
            bottom: 10,
            right: 10,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.yellow.shade700,
                  borderRadius: BorderRadius.circular(2)
              ),
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: '$currency ',
                            style: TextStyle(
                              color: Colors.grey.shade900,
                              fontSize: 8,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          TextSpan(
                            text: '$tempPrice',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              decoration: TextDecoration.lineThrough,
                              decorationColor: Colors.red,
                              decorationThickness: 3,
                            ),
                          ),
                          TextSpan(
                            text: ' $price',
                            style: TextStyle(
                              color: Colors.grey.shade900,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
        ),
      ],
    );
  }
}

// Snowflake Painter
class SnowPainter extends CustomPainter {
  final Animation<double> animation;
  final Random _random = Random();

  final int snowflakeCount = 20;
  final double fallSpeed = 0.1;
  final double driftSpeed = 0.2;

  late List<Offset> snowflakePositions;
  late List<double> snowflakeSpeeds;
  late List<double> snowflakeDrift;

  SnowPainter({required this.animation}) : super(repaint: animation) {
    snowflakePositions = List.generate(
      snowflakeCount,
      (_) => Offset(
        _random.nextDouble() * 300, // Random x
        _random.nextDouble() * 400, // Random y
      ),
    );

    snowflakeSpeeds = List.generate(
      snowflakeCount,
      (_) => _random.nextDouble() * fallSpeed + 0.5,
    );

    snowflakeDrift = List.generate(
      snowflakeCount,
      (_) => (_random.nextDouble() * 2 - 1) * driftSpeed,
    );
  }

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white60
      ..style = PaintingStyle.fill;

    for (int i = 0; i < snowflakeCount; i++) {
      final position = snowflakePositions[i];

      final updatedX = position.dx + snowflakeDrift[i];
      final updatedY = position.dy + snowflakeSpeeds[i];

      snowflakePositions[i] = Offset(
        updatedX < 0 ? size.width : (updatedX > size.width ? 0 : updatedX),
        updatedY > size.height ? 0 : updatedY,
      );

      canvas.drawCircle(snowflakePositions[i], 2, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

String formatDate(String dateString) {
  DateTime parsedDate = DateTime.parse(dateString);
  return DateFormat("d MMM yyyy").format(parsedDate);
}
