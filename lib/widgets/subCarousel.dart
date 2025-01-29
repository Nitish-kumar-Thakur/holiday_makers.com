import 'dart:math';
import 'package:flutter/material.dart';
import 'package:holdidaymakers/pages/Cruise/cruise_deals_page.dart';
import 'package:holdidaymakers/pages/FixedDeparturesPages/departureDeals.dart';

class Subcarousel extends StatefulWidget {
  final List<Map<String, dynamic>> lists;
  final String title;
  final double width;

  const Subcarousel({
    super.key,
    required this.lists,
    required this.title,
    this.width = 130,
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
            return GestureDetector(
              onTap: () {
                print(item["id"].toString());
                if (item["id"] == "cruise") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CruiseDealsPage()),
                  );
                } else if (item["id"] == "FD") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DepartureDeals()),
                  );
                }
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: widget.title == "Winter Holidays"
                    ? _buildWinterHolidayImage(item['image'])
                    : _buildStandardImage(item['image']),
              ),
            );
          },
        ),
      ),
    );
  }

  // Widget for regular images
  Widget _buildStandardImage(String imageUrl) {
    return Container(
      width: widget.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: DecorationImage(
          image: NetworkImage(imageUrl),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  // Widget for images with animated snowflakes
  Widget _buildWinterHolidayImage(String imageUrl) {
    return Stack(
      children: [
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
        Positioned.fill(
          child: CustomPaint(
            painter: SnowPainter(animation: _controller),
          ),
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
