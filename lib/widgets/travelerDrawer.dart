import 'package:flutter/material.dart';
import 'package:holdidaymakers/widgets/appLargetext.dart';
import 'package:holdidaymakers/widgets/responciveButton.dart';

class Travelerdrawer extends StatefulWidget {
  const Travelerdrawer({super.key});

  @override
  _TravelerdrawerState createState() => _TravelerdrawerState();
}

class _TravelerdrawerState extends State<Travelerdrawer> {
  bool update = false;
  String roomValue = '01';
  String adultValue = '01';
  String childValue = '01';

  // Function to open the bottom drawer
  void _openBottomDrawer(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(50)),
      ),
      builder: (context) {
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
                        Navigator.pop(context); // Close the bottom sheet
                      },
                    ),
                    AppLargeText(text: 'Room $roomValue', size: 30),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppLargeText(text: 'Rooms', size: 20),
                    DrawerDropdown(
                      initialDropdownValue: roomValue,
                      onValueChanged: (value) {
                        roomValue = value;
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppLargeText(text: 'Adults', size: 20),
                    DrawerDropdown(
                      initialDropdownValue: adultValue,
                      onValueChanged: (value) {
                        adultValue = value;
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppLargeText(text: 'Children', size: 20),
                    DrawerDropdown(
                      initialDropdownValue: childValue,
                      onValueChanged: (value) {
                        childValue = value;
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 70),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      update = true;
                    });
                    Navigator.pop(context); // Close the drawer
                  },
                  child: Align(alignment: Alignment.center,
                  child: responciveButton(text: 'DONE'),)
                ),
              ],
            ),
          ),
        );
      },
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
              Icon(
                Icons.location_on,
                size: 30,
              ),
              const SizedBox(width: 5),
              Text(
                update ? '$adultValue ADULTS, $roomValue ROOM' : '2 ADULTS, 1 ROOM',
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DrawerDropdown extends StatefulWidget {
  final String initialDropdownValue;
  final ValueChanged<String> onValueChanged;

  const DrawerDropdown({
    super.key,
    required this.initialDropdownValue,
    required this.onValueChanged,
  });

  @override
  State<DrawerDropdown> createState() => _DrawerDropdownState();
}

class _DrawerDropdownState extends State<DrawerDropdown> {
  late String dropdownValue;

  @override
  void initState() {
    super.initState();
    dropdownValue = widget.initialDropdownValue;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 70,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(width: 1, color: Colors.grey),
      ),
      child: DropdownButton<String>(
        value: dropdownValue,
        items: ['01', '02', '03', '04'].map((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Center(
              child: Text(
                item,
                style: TextStyle(fontSize: 14, color: Colors.black),
              ),
            ),
          );
        }).toList(),
        onChanged: (String? newValue) {
          if (newValue != null) {
            setState(() {
              dropdownValue = newValue;
              widget.onValueChanged(newValue); // Notify parent widget
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
}
