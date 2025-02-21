import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:holdidaymakers/widgets/appLargetext.dart';
import 'package:holdidaymakers/widgets/responciveButton.dart';

class PaxDetails extends StatefulWidget {
  final ValueChanged<Map<String, dynamic>> onSelectionChanged;

  const PaxDetails({super.key, required this.onSelectionChanged});        //required this.onSelectionChanged

  @override
  _PaxDetailsState createState() => _PaxDetailsState();
}

class _PaxDetailsState extends State<PaxDetails> {
  List<Map<String, dynamic>> mapData(List<Map<String, dynamic>> originalData) {
    return originalData.map((item) {
      // Check if paxAges is a list, otherwise initialize it as an empty list
      List<String> paxAges = [];
      if (item['paxAges'] is List) {
        paxAges = List<String>.from(
            item['paxAges'].map((age) => age.toString()));
      }

      return {
        'paxCount': item['paxCount'].toString(),
        'paxAges': paxAges,
      };
    }).toList();
  }

  bool update = false;
  String? errorMessage;
  List<Map<String, dynamic>> roomDetails = [
    {"paxCount": 2, "paxAges": <String>["21", "21"]}
  ];
  final ScrollController _scrollController = ScrollController();

  Map<String, dynamic> totalSummary = {
    "totalPaxCount": 2,
    "totalRooms": 1, 
    "paxAges": <String>["21","21"],
    "totalData": [{"paxCount": "2", "paxAges": ["21", "21"]}],
  };

  bool _validateRooms() {
    for (var room in roomDetails) {
      if (!room["paxAges"].any((age) => int.parse(age) >= 21)) {
        return false; // If no pax is 21 or older, return false
      }
    }
    return true;
  }

  void _updateTotalSummary() {
    int totalPaxCount = 0;
    List<String> paxAges = [];

    for (var room in roomDetails) {
      totalPaxCount += room["paxCount"] as int;
      paxAges.addAll(List<String>.from(room["paxAges"]));
    }

    // Validate room conditions
    bool isValid = _validateRooms();

    setState(() {
      errorMessage = isValid ? null : "Atleast one 21 year old pax should be there in each room";
      totalSummary = {
        "totalPaxCount": totalPaxCount,
        "totalRooms": roomDetails.length,
        "paxAges": paxAges,
        "totalData": List.from(roomDetails)
      };
    });
  }

  void _openBottomDrawer(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: false,  // Prevents dismissing by tapping outside
      enableDrag: false,      // Prevents swipe-down dismissal
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(50))),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return SizedBox(
              height: 600,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(child: AppLargeText(text: 'Select Occupancy', size: 24)),
                    const SizedBox(height: 10),

                    // Show error message if validation fails
                    if (errorMessage != null)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          errorMessage!,
                          style: TextStyle(color: Colors.red, fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),

                    Expanded(
                      child: ListView.builder(
                        controller: _scrollController,
                        itemCount: roomDetails.length,
                        itemBuilder: (context, index) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  AppLargeText(text: 'State Room ${index + 1}', size: 20),
                                  if (roomDetails.length > 1)
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          roomDetails.removeAt(index);
                                          _updateTotalSummary();
                                        });
                                      },
                                      child: Container(
                                        width: 20,
                                        height: 20,
                                        decoration: BoxDecoration(
                                          color: Colors.red,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(Icons.remove, color: Colors.white, size: 18),
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 5),

                              // Pax Count Dropdown
                              _buildDropdownRow(
                                'No. of Pax',
                                roomDetails[index]["paxCount"].toString(),
                                List.generate(4, (i) => (i + 1).toString()),
                                    (value) {
                                  setState(() {
                                    roomDetails[index]["paxCount"] = int.parse(value);
                                    roomDetails[index]["paxAges"] =
                                        List.generate(int.parse(value), (i) => (21 + i).toString());
                                    _updateTotalSummary();
                                  });
                                },
                              ),

                              // Pax Age Dropdowns
                              Column(
                                children: List.generate(
                                  roomDetails[index]["paxCount"],
                                      (childIndex) => Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 5),
                                      _buildDropdownRow(
                                        'Pax ${childIndex + 1} Age',
                                        roomDetails[index]["paxAges"][childIndex],
                                        List.generate(100, (i) => (i + 1).toString()),
                                            (value) {
                                          setState(() {
                                            roomDetails[index]["paxAges"][childIndex] = value;
                                            _updateTotalSummary();
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Divider(thickness: 1, color: Colors.grey.shade300),
                              const SizedBox(height: 10),
                            ],
                          );
                        },
                      ),
                    ),

                    if (roomDetails.length < 3)
                      Center(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            setState(() {
                              roomDetails.add({
                                "paxCount": 2,
                                "paxAges": ["21", "22"]
                              });
                              _updateTotalSummary();
                              Future.delayed(Duration(milliseconds: 300), () {
                                _scrollController.animateTo(
                                  _scrollController.position.maxScrollExtent,
                                  duration: Duration(milliseconds: 300),
                                  curve: Curves.easeOut,
                                );
                              });
                            });
                          },
                          icon: Icon(Icons.add),
                          label: Text("Add Room"),
                        ),
                      ),

                    const SizedBox(height: 10),

                    GestureDetector(
                      onTap: () {
                        if (_validateRooms()) {
                          widget.onSelectionChanged(totalSummary);
                          Navigator.pop(context);
                          print('======================');
                          print(totalSummary);
                          print('======================');
                        } else {
                          setState(() {
                            errorMessage = "At least one 21-year-old pax should be there in each room";
                          });
                        }
                      },
                      child: Align(
                        alignment: Alignment.center,
                        child: responciveButton(text: 'DONE'),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildDropdownRow(String label, String selectedValue,
      List<String> options, ValueChanged<String> onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppLargeText(text: label, size: 18),
        _buildDropdown(selectedValue, options, onChanged),
      ],
    );
  }

  Widget _buildDropdown(String selectedValue, List<String> options,
      ValueChanged<String> onChanged) {
    return Container(
      height: 40,
      width: 70,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(width: 1, color: Colors.grey),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedValue,
          items: options.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Center(
                child: Text(item,
                    style: TextStyle(fontSize: 14, color: Colors.black)),
              ),
            );
          }).toList(),
          onChanged: (String? newValue) {
            if (newValue != null) {
              onChanged(newValue);
            }
          },
          icon: Icon(Icons.arrow_drop_down, color: Colors.blue.shade400),
          dropdownColor: Colors.white,
          isExpanded: true,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          update = true;
        });
        _openBottomDrawer(context);
      },
      child: Container(
        height: 58,
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(9),
          child: Row(
            children: [
              Icon(FontAwesomeIcons.users, size: 20),
              const SizedBox(width: 13),
              Text('${totalSummary['totalPaxCount']} Pax,${totalSummary['totalRooms']} State Room'),
            ],
          ),
        ),
      ),
    );
  }
}
