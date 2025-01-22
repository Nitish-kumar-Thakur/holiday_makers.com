import 'package:flutter/material.dart';
import 'package:holdidaymakers/widgets/appLargetext.dart';
import 'package:holdidaymakers/widgets/responciveButton.dart';

class Travelerdrawer extends StatefulWidget {
  final ValueChanged<List<Map<String, dynamic>>> onSelectionChanged;

  const Travelerdrawer({super.key, required this.onSelectionChanged});

  @override
  _TravelerdrawerState createState() => _TravelerdrawerState();
}

class _TravelerdrawerState extends State<Travelerdrawer> {
  bool update = false;
  int roomCount = 1;
  int adultCount = 1;
  int childCount = 0;

  // Function to dynamically calculate the available range for adults based on room count
  List<int> _getAdultsOptions(int roomCount) {
    int maxAdults = roomCount * 3;
    return List.generate(maxAdults - roomCount + 1, (index) => roomCount + index);
  }

  // Function to dynamically calculate the available range for children based on room count
  List<int> _getChildrenOptions(int roomCount) {
    int maxChildren = roomCount * 2;
    return List.generate(maxChildren + 1, (index) => index);
  }

  void _openBottomDrawer(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(50)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return SizedBox(
              height: 450,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.only(top: 20, left: 15, right: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.close),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        AppLargeText(text: 'Room $roomCount', size: 30),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _buildDropdownRow(
                      'Rooms',
                      roomCount,
                      List.generate(10, (index) => index + 1), // Room range: 1-10
                      (value) {
                        setState(() {
                          roomCount = value;
                          // Update dropdown options when room count changes
                          adultCount = roomCount; // Reset adult count based on room count
                          childCount = 0; // Reset child count to 0
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    _buildDropdownRow(
                      'Adults',
                      adultCount,
                      _getAdultsOptions(roomCount),
                      (value) {
                        setState(() {
                          adultCount = value;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    _buildDropdownRow(
                      'Children',
                      childCount,
                      _getChildrenOptions(roomCount),
                      (value) {
                        setState(() {
                          childCount = value;
                        });
                      },
                    ),
                    const SizedBox(height: 70),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          update = true;
                        });
                        widget.onSelectionChanged([
                          {'rooms': roomCount.toString()},
                          {'adults': adultCount.toString()},
                          {'children': childCount.toString()},
                        ]); // Send data to parent
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

  Widget _buildDropdownRow(String label, int selectedValue, List<int> options, ValueChanged<int> onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppLargeText(text: label, size: 20),
        _buildDropdown(selectedValue, options, onChanged),
      ],
    );
  }

  Widget _buildDropdown(int selectedValue, List<int> options, ValueChanged<int> onChanged) {
    return Container(
      height: 40,
      width: 70,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(width: 1, color: Colors.grey),
      ),
      child: DropdownButton<int>(
        value: selectedValue,
        items: options.map((int item) {
          return DropdownMenuItem<int>(
            value: item,
            child: Center(
              child: Text(item.toString(), style: TextStyle(fontSize: 14, color: Colors.black)),
            ),
          );
        }).toList(),
        onChanged: (int? newValue) {
          if (newValue != null) {
            setState(() {
              onChanged(newValue);
            });
          }
        },
        icon: Icon(Icons.arrow_drop_down, color: Colors.blue.shade400),
        underline: SizedBox(),
        isExpanded: true,
        dropdownColor: Colors.white,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _openBottomDrawer(context);
      },
      child: Container(
        height: 58,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(9),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.location_on, size: 30),
              const SizedBox(width: 5),
              Text(
                update ? '$adultCount ADULTS, $roomCount ROOM' : '1 ADULT, 1 ROOM',
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
