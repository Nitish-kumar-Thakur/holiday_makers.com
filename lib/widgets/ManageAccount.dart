import 'package:flutter/material.dart';

class ManageAccount extends StatefulWidget {
  @override
  _ManageAccountState createState() => _ManageAccountState();
}

class _ManageAccountState extends State<ManageAccount> {
  List<String> values = ['Value 1', 'Value 2', 'Value 3'];
  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back)),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Back Arrow

            // Title
            Container(
              margin: EdgeInsets.only(left: 15, top: 10),
              child: Text(
                "Manage Account",
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // Delete/Deactivate Section
            Container(
              margin: EdgeInsets.only(top: 30, left: 15, right: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        "Delete/Deactivate",
                        style: TextStyle(fontSize: 25),
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
                      border: Border.all(color: Colors.grey,
                      width: 2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedValue,
                        isExpanded: true,
                        hint: Text(
                          "Select",
                          style: TextStyle(fontSize: 20),
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
                ],
              ),
            ),

            // Reason Section
            Container(
              margin: EdgeInsets.only(top: 40, left: 15, right: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        "Reason",
                        style: TextStyle(fontSize: 25),
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
                      // hintText: "Enter your reason here...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Save Changes Button
            Container(
              margin: EdgeInsets.only(top: 60, left: 15, right: 15),
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  print("Save Changes button pressed");
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  minimumSize: Size(100, 60),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
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
            Container(
              margin: EdgeInsets.only(top: 40, left: 15, right: 15),
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
                    borderRadius: BorderRadius.circular(10),
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
    );
  }
}
