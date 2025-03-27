import 'package:flutter/material.dart';

class BlogDetailsPage extends StatelessWidget {
  final String? image; // Nullable image
  final String title;
  final String description;

  const BlogDetailsPage({
    super.key,
    required this.image,
    required this.title,
    required this.description,
  });

      Widget _buildTopCurve() {
    return Padding(
      padding: const EdgeInsets.only(top: 50), // 20% of the screen height
      child: CustomPaint(
        size: Size(double.infinity, 0), // Height of the curved area
        painter: CirclePainter(radius: 200),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Colors.white,
      //   elevation: 0,
      //   leading: IconButton(
      //     icon: Icon(Icons.arrow_back, color: Colors.black),
      //     onPressed: () => Navigator.pop(context),
      //   ),
      //   title: Text(
      //     'Blog Details',
      //     style: TextStyle(color: Colors.black),
      //   ),
      //   centerTitle: true,
      // ),
      // backgroundColor: Colors.grey[100],
      body: Container( color: Colors.white,
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
                    backgroundColor: Colors.grey.withOpacity(0.6),  // Transparent grey background
                    child: Text(
                      '<',  // Use "<" symbol
                      style: TextStyle(
                        color: Colors.white,  // White text color
                        fontSize: 24,  // Adjust font size as needed
                        fontWeight: FontWeight.bold,  // Make the "<" bold if needed
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Text('BLOGS DETAILS',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white)
                )
              ],
            ),
            Expanded(child: 
            SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Blog image or fallback
              ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: image != null && image!.isNotEmpty
                    ? Image.network(
                  image!, // Display the image
                  width: double.infinity,
                  height: 200.0,
                  fit: BoxFit.cover,
                )
                    : Container(
                  width: double.infinity,
                  height: 200.0,
                  color: Colors.grey[300], // Grey background as fallback
                  child: Icon(
                    Icons.image_not_supported,
                    color: Colors.grey[600],
                    size: 60.0,
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              // Blog title
              Text(
                title, // Dynamic title
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.0),
              // Blog description
              Text(
                description, // Full description
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.grey[800],
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),)
          ],
        ),
      )
    );
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
