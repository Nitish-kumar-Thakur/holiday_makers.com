import 'package:flutter/material.dart';

class ReadMore extends StatefulWidget {
  _ReadMoreState createState() => _ReadMoreState();
}

class _ReadMoreState extends State<ReadMore> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(preferredSize: const Size.fromHeight(270), child: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
          flexibleSpace: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(top: 40, left: 10),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(Icons.arrow_back),
                ),
              ),
              // Image container with Stack
              Container(
                height: 240,
                width: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        'assets/images/readMore.png',
                        width: double.infinity, // Ensure the image fills the container
                        fit: BoxFit.cover, // Make sure the image fits the container properly
                      ),
                    ),
                    Positioned(
                      top: 10,
                      right: 10, // Adjusted to right to avoid overflow
                      child: Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Icon(Icons.copy, color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
      ),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child:  Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 50,
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Author Info
                  Container(
                    width: 140,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("By", style: TextStyle(color: Colors.grey[500], fontSize: 25)),
                        Text("Ram Roy", style: TextStyle(fontSize: 25)),
                      ],
                    ),
                  ),
                  // Social Icons
                  Container(
                    width: 180,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        _socialIcon('assets/images/instagram.png', "Instagram"),
                        _socialIcon('assets/images/facebook.png', "Facebook"),
                        _socialIcon('assets/images/linkedin.png', "LinkedIn"),
                        _rotatedIcon(Icons.link_rounded, 2.3708, "Link icon"),
                        _rotatedIcon(Icons.more_horiz, 1.5708, "More icon"),
                      ],
                    ),
                  )
                ],
              ),
            ),
            // Title section
            Container(
              margin: EdgeInsets.only(left: 20, top: 20),
              child: Text(
                "Make design system people want to use.",
                style: TextStyle(fontSize: 35, fontWeight: FontWeight.w800),
              ),
            ),
            // Description section
            Container(
              margin: EdgeInsets.only(left: 20, top: 20),
              child: Text(
                "Build a system that provides a unified set of UX, design rules and patterns.",
                style: TextStyle(fontSize: 23, fontWeight: FontWeight.w500),
              ),
            ),
            // Write text sections
            _buildWriteText(
              "For the last years I have continued to build and design applications web and mobile, "
                  "and I have learned how to deal with different departments and utilize their knowledge "
                  "in order to make better products and build better design systems that scale better and more efficiently.",
            ),
            _buildWriteText(
              "For the last years I have continued to build and design applications web and mobile, "
                  "and I have learned how to deal with different departments and utilize their knowledge "
                  "in order to make better products and build better design systems that scale better and more efficiently.",
            ),
            _buildWriteText(
              "For the last years I have continued to build and design applications web and mobile, "
                  "and I have learned how to deal with different departments and utilize their knowledge "
                  "in order to make better products and build better design systems that scale better and more efficiently.",
            ),
          ],
        ),
        ),
      )
    );
  }

  // Social Icon Gesture Detector Widget
  Widget _socialIcon(String assetPath, String message) {
    return GestureDetector(
      onTap: () {
        print("$message clicked");
      },
      child: Image.asset(assetPath,width: 20,height: 20,fit: BoxFit.contain,color: Colors.black,),
    );
  }

  // Rotated Icon Gesture Detector Widget
  Widget _rotatedIcon(IconData icon, double angle, String message) {
    return GestureDetector(
      onTap: () {
        print("$message clicked");
      },
      child: Transform.rotate(
        angle: angle, // Rotate the icon to the desired angle
        child: Icon(
          icon,
          color: Colors.black,
        ),
      ),
    );
  }

  // Text widget for displaying content
  Widget _buildWriteText(String content) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: Text(
        content,
        style: TextStyle(
          color: Colors.grey[600],
          fontSize: 20,
        ),
      ),
    );
  }
}
