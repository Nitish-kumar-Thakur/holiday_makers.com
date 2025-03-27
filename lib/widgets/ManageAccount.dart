import 'package:flutter/material.dart'; 

class ManageAccount extends StatefulWidget {
  @override
  _ManageAccountState createState() => _ManageAccountState();
}

class _ManageAccountState extends State<ManageAccount> {
  List<String> values = ['Value 1', 'Value 2', 'Value 3'];
  String? selectedValue;

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
      //   leading: IconButton(
      //       onPressed: () {
      //         Navigator.pop(context);
      //       },
      //       icon: Icon(Icons.arrow_back)),
      // ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTopCurve(),
            const SizedBox(height: 10),
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
                Text('MANAGE ACCOUNT',
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white)
                )
              ],
            ),


        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 60),
          child: Container(
            height: 550, // Increased height of the container (adjust as needed)
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('img/fitFormBG.png'), // Background image
                fit: BoxFit.cover, // Ensures the image covers the container
              ),
              borderRadius: BorderRadius.circular(20), // Rounded corners for the container
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(1), // Shadow color
                  offset: Offset(0, 4), // Shadow offset (vertical displacement)
                  blurRadius: 20, // Softens the shadow
                  spreadRadius: 1, // Extends the shadow
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.all(15), // Add padding around all content inside the container
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  // Delete/Deactivate Section
                  Row(
                    children: [
                      Text(
                        "Delete/Deactivate",
                        style: TextStyle(fontSize: 25, color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "*",
                        style: TextStyle(color: Colors.red, fontSize: 25),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 15.0),
                    decoration: BoxDecoration(
                      color: Colors.white, // Set background color to white
                      border: Border.all(color: Colors.white), // Border color
                      borderRadius: BorderRadius.circular(10), // Rounded corners
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedValue,
                        isExpanded: true,
                        hint: Text(
                          "Select",
                          style: TextStyle(fontSize: 20, color: Colors.black), // Adjust text color if needed
                        ),
                        items: values
                            .map(
                              (e) => DropdownMenuItem<String>(
                            value: e,
                            child: Text(e),
                          ),
                        )
                            .toList(),
                        onChanged: (v) {
                          setState(() {
                            selectedValue = v;
                          });
                        },
                      ),
                    ),
                  ),

                  // Reason Section
                  SizedBox(height: 40),
                  Row(
                    children: [
                      Text(
                        "Reason",
                        style: TextStyle(fontSize: 25, color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "*",
                        style: TextStyle(color: Colors.red, fontSize: 25),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  TextField(
                    decoration: InputDecoration(
                      filled: true, // Enable background fill color
                      fillColor: Colors.white, // Set background color to white
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.white), // Default border color
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.blue), // Border color when focused
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.white), // Border color when not focused
                      ),
                    ),
                  ),
                  // Save Changes Button
                  SizedBox(height: 60),
                  Container(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        print("Save Changes button pressed");
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF0071BC), 
                        foregroundColor: Colors.white,
                        minimumSize: Size(100, 60),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                      ),
                      child: Text(
                        "Save Changes",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  // Cancel Button
                  SizedBox(height: 40),
                  Container(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context); // Handle cancel action
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        minimumSize: Size(100, 60),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                      ),
                      child: Text(
                        "Cancel",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        )

        ],
        ),
      ),
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
    paint.color = Color(0xFF0D939E);
    canvas.drawCircle(Offset(centerX, radius - 600), radius + 400, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
