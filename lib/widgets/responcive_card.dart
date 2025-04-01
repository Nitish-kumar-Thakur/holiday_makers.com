import 'package:flutter/material.dart';
class ResponsiveCard extends StatelessWidget {
  final String image;
  final String title;
  final String subtitle;
  final String price;
  final double screenWidth;

  const ResponsiveCard({
    Key? key,
    required this.image,
    required this.title,
    required this.subtitle,
    required this.price,
    required this.screenWidth
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Container (removed static height)
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                image: NetworkImage(image.isEmpty?"https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQD4qmuiXoOrmp-skck7b7JjHA8Ry4TZyPHkw&s":image,),
                fit: BoxFit.cover, // Adjusts image to fill the container
              ),
            ),
            // Allow the image to be flexible depending on the screen width and aspect ratio
            child: AspectRatio(
              aspectRatio: 16 / 9, // You can adjust this ratio to fit your needs
              child: Container(), // Empty container to preserve aspect ratio
            ),
          ),
          SizedBox(height: 8),

          // Subtitle text
          Padding(
            padding: EdgeInsets.only(left: screenWidth * 0.01),
            child: Text(
              subtitle,
              style: TextStyle(
                color: Color(0xFF0775BD),
                fontSize: screenWidth * 0.026,
              ),
            ),
          ),

          // Title text
          Padding(
            padding: EdgeInsets.only(left: screenWidth * 0.01),
            child: Text(
              title,
              style: TextStyle(
                fontSize: screenWidth * 0.028,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // Price text
          Padding(
            padding: EdgeInsets.only(left: screenWidth * 0.01),
            child: Text(
              price,
              style: TextStyle(
                fontSize: screenWidth * 0.026,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ResponsiveCard2 extends StatelessWidget {
  final String image;
  final String title;
  final String subtitle;
  final String price;
  final double screenWidth;

  const ResponsiveCard2({
    Key? key,
    required this.image,
    required this.title,
    required this.subtitle,
    required this.price,
    required this.screenWidth
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 120,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
  image: AssetImage(image),
  fit: BoxFit.fill,
  
),
            ),
          ),
          SizedBox(height: 4),
          Padding(
            padding: EdgeInsets.only(left: screenWidth * 0.01),
            child: Text(
              subtitle,
              style: TextStyle(
                color: Color(0xFF0775BD),
                fontSize: screenWidth * 0.020,
              ),
            ),
          ),
          Padding(
              padding: EdgeInsets.only(left: screenWidth * 0.01),
              child: Text(
                title,
                style: TextStyle(fontSize: screenWidth * 0.022, fontWeight: FontWeight.bold),
              )),
          Padding(
            padding: EdgeInsets.only(left: screenWidth * 0.01),
            child: Text(
              price,
              style: TextStyle(fontSize:screenWidth * 0.020,),
            ),
          ),
        ],
      ),
    );
  }
}