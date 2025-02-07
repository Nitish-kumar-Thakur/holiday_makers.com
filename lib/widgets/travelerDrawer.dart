import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:holdidaymakers/widgets/appLargetext.dart';
import 'package:holdidaymakers/widgets/responciveButton.dart';

class Travelerdrawer extends StatefulWidget {
  final ValueChanged<Map<String, dynamic>> onSelectionChanged;

  const Travelerdrawer({super.key, required this.onSelectionChanged});

  @override
  _TravelerdrawerState createState() => _TravelerdrawerState();
}

class _TravelerdrawerState extends State<Travelerdrawer> {

  List<Map<String, dynamic>> mapData(List<Map<String, dynamic>> originalData) {
    return originalData.map((item) {
      // Check if childrenAges is a list, otherwise initialize it as an empty list
      List<String> childrenAges = [];
      if (item['childrenAges'] is List) {
        childrenAges = List<String>.from(
            item['childrenAges'].map((age) => age.toString()));
      }

      return {
        "adult": item['adults'].toString(),
        "child": item['children'].toString(),
        "childage": childrenAges,
      };
    }).toList();
  }

  bool update = false;
  List<Map<String, dynamic>> roomDetails = [
    {"adults": 1, "children": 0, "childrenAges": <String>[]}
  ];
  final ScrollController _scrollController = ScrollController();

  Map<String, dynamic> totalSummary = {
    "totalAdults": 1,
    "totalChildren": 0,
    "totalRooms": 1,
    "childrenAges": <String>[],
    "totalData": <List<Map<String, dynamic>>>[],
  };

  void _updateTotalSummary() {
    int totalAdults = 0;
    int totalChildren = 0;
    List<String> childrenAges = [];
    // print(roomDetails);

    for (var room in roomDetails) {
      totalAdults += room["adults"] as int;
      totalChildren += room["children"] as int;
      childrenAges.addAll(List<String>.from(room["childrenAges"]));
    }
    var data = mapData(roomDetails);
    // print('=---=====================');
    // print(data);
    // print('=---=====================');

    setState(() {
      totalSummary = {
        "totalAdults": totalAdults,
        "totalChildren": totalChildren,
        "totalRooms": roomDetails.length,
        "childrenAges": childrenAges,
        "totalData": mapData(roomDetails)
      };
    });
  }

  void _openBottomDrawer(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(50))),
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
                    Center(
                        child:
                            AppLargeText(text: 'Select Occupancy', size: 24)),
                    const SizedBox(height: 10),
                    Expanded(
                      child: ListView.builder(
                        controller: _scrollController,
                        itemCount: roomDetails.length,
                        itemBuilder: (context, index) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  AppLargeText(
                                      text: 'Room ${index + 1}', size: 20),
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
                                        child: Icon(Icons.remove,
                                            color: Colors.white, size: 18),
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 5),
                              _buildDropdownRow(
                                'Adults',
                                roomDetails[index]["adults"].toString(),
                                List.generate(3, (i) => (i + 1).toString()),
                                (value) {
                                  setState(() {
                                    roomDetails[index]["adults"] =
                                        int.parse(value);
                                    _updateTotalSummary();
                                  });
                                },
                              ),
                              const SizedBox(height: 5),
                              _buildDropdownRow(
                                'Children',
                                roomDetails[index]["children"].toString(),
                                List.generate(3, (i) => i.toString()),
                                (value) {
                                  setState(() {
                                    roomDetails[index]["children"] =
                                        int.parse(value);
                                    roomDetails[index]["childrenAges"] =
                                        List.generate(
                                            int.parse(value), (index) => "0");
                                    _updateTotalSummary();
                                  });
                                },
                              ),
                              if (roomDetails[index]["children"] > 0)
                                Column(
                                  children: List.generate(
                                    roomDetails[index]["children"],
                                    (childIndex) => Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: 5),
                                        _buildDropdownRow(
                                          'Child ${childIndex + 1} Age',
                                          roomDetails[index]["childrenAges"]
                                              [childIndex],
                                          List.generate(
                                              12, (i) => i.toString()),
                                          (value) {
                                            setState(() {
                                              roomDetails[index]["childrenAges"]
                                                  [childIndex] = value;
                                              _updateTotalSummary();
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              const SizedBox(height: 10),
                              Divider(
                                  thickness: 1, color: Colors.grey.shade300),
                              const SizedBox(height: 10),
                            ],
                          );
                        },
                      ),
                    ),
                    if (roomDetails.length < 10)
                      Center(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            setState(() {
                              roomDetails.add({
                                "adults": 1,
                                "children": 0,
                                "childrenAges": <String>[]
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
                    GestureDetector(
                      onTap: () {
                        widget.onSelectionChanged(totalSummary);
                        Navigator.pop(context);
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
              Text(update
                  ? '${totalSummary['totalRooms']} Room(s) Selected'
                  : 'Select Rooms and Adults'),
            ],
          ),
        ),
      ),
    );
  }
}
