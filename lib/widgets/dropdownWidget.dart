import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

class Dropdownwidget extends StatefulWidget {
  final String text;
  const Dropdownwidget({super.key, required this.text});

  @override
  State<Dropdownwidget> createState() => _DropdownwidgetState();
}

class _DropdownwidgetState extends State<Dropdownwidget> {
  final dropDownKey = GlobalKey<DropdownSearchState>();
  List<String> issuingAuthorities = [
    "Authority 1",
    "Authority 2",
    "Authority 3",
    "Authority 4",
    "Authority 1",
    "Authority 2",
    "Authority 3",
    "Authority 4",
    "Authority 1",
    "Authority 2",
    "Authority 3",
    "Authority 4",
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Label Text
              Padding(
                padding: const EdgeInsets.only(left: 8.0, bottom: 4.0),
                child: Text(
                  widget.text,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold, // You can adjust this
                  ),
                ),
              ),
              // DropdownSearch widget
              DropdownSearch<String>(
                  key: dropDownKey,
                  selectedItem: "All",
                  items: (filter, infiniteScrollProps) => issuingAuthorities,
                  decoratorProps: DropDownDecoratorProps(
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.location_on,
                        size: 30,
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              20), // Circular border radius
                          borderSide: BorderSide(
                              color: Colors.white,
                              width: 1) // Remove border line
                          ),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              20), // Circular border radius
                          borderSide: BorderSide(
                              color: Colors.white,
                              width: 1) // Remove border line
                          ),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              20), // Circular border radius
                          borderSide: BorderSide(
                              color: Colors.grey,
                              width: 1) // Remove border line
                          ),
                      fillColor: Colors
                          .grey.shade200, // Background color of the input box
                      filled: true, // Enable the fill color
                    ),
                  ),
                  popupProps: PopupProps.menu(
                    showSearchBox: false,
                    // No search box
                  )),
            ],
          ),
        ),
      ],
    );
  }
}
