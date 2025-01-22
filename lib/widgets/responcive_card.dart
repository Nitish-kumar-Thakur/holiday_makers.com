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
          Container(
            height: 120,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              image: DecorationImage(
  image: NetworkImage(image),
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
              borderRadius: BorderRadius.circular(20),
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