import 'package:HolidayMakers/pages/homePages/mainPage.dart';
import 'package:HolidayMakers/utils/api_handler.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ManageAccount extends StatefulWidget {
  @override
  _ManageAccountState createState() => _ManageAccountState();
}

class _ManageAccountState extends State<ManageAccount> {
  List<String> values = ['Delete', 'Deactivate'];
  String? selectedValue;
  String? userId;
  TextEditingController _reasonController = TextEditingController();
  String reason = '';

  void initState() {
    super.initState();
    // userId = prefs.getString('username');
    getDataFromPrefs();
  }

  Future<void> getDataFromPrefs() async{
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('user_id') ?? null;
  }

  Widget _buildTopCurve() {
    return Padding(
      padding: const EdgeInsets.only(top: 50), // 20% of the screen height
      child: CustomPaint(
        size: Size(double.infinity, 0), // Height of the curved area
        painter: CirclePainter(radius: 200),
      ),
    );
  }

  Future<void> _hitAPI() async {
    Map<String, dynamic> body = {
      "user_id": userId,
      "status": selectedValue == 'Delete' ? "-1" : null,
      // "status": "2",
      "reason": reason
    };

    if(selectedValue == null){
      Fluttertoast.showToast(msg: 'Please select an option.');
    } else if(selectedValue == 'Delete'){
      try {
        final response = await APIHandler.accountDeactivate(body); //widget.searchId
        // Ensure response contains expected keys and types
        if (response['status'] == true) {
          Fluttertoast.showToast(msg: response['message']);
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.clear();

          // Navigate to HomePage (replace with your home screen)
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => Mainpage()),
                (Route<dynamic> route) => false,
          );
        } else {
          Fluttertoast.showToast(msg: response['message']);
        }
      } catch (e) {
        print("Error deleting account: $e");
      }
    } else if(selectedValue == 'Deactivate'){
      try {
        // final response = await APIHandler.accountDeactivate(body); //widget.searchId
        // Ensure response contains expected keys and types
        // if (response['status'] == true) {
        //   Fluttertoast.showToast(msg: response['message']);
        //   SharedPreferences prefs = await SharedPreferences.getInstance();
        //   await prefs.clear();
        //
        //   // Navigate to HomePage (replace with your home screen)
        //   Navigator.pushAndRemoveUntil(
        //     context,
        //     MaterialPageRoute(builder: (context) => Mainpage()),
        //         (Route<dynamic> route) => false,
        //   );
        // } else {
        //   throw Exception("Invalid data structure: ${response.toString()}");
        // }
        Fluttertoast.showToast(msg: 'Account Deactivated Successfully');
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.clear();

        // Navigate to HomePage (replace with your home screen)
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => Mainpage()),
              (Route<dynamic> route) => false,
        );
      } catch (e) {
        print("Error deactivating account: $e");
      }
    }
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
                    ],
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: _reasonController, // Attach controller
                    onChanged: (value) {
                      setState(() {
                        reason = value; // Update the reason string on input change
                      });
                    },
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                  ),
                  // Save Changes Button
                  SizedBox(height: 60),
                  Container(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _hitAPI,
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
