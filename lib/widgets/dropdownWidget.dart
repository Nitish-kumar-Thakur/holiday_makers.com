import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';

class Dropdownwidget extends StatelessWidget {
  final String? selectedValue;
  final List<Map<String, String>> items;
  final String hintText;
  final ValueChanged<String?> onChanged;
  final Color txtcolor;
  final Color bgColor;
  final bool search;

  const Dropdownwidget(
      {Key? key,
      required this.selectedValue,
      required this.items,
      required this.hintText,
      required this.onChanged,
      this.bgColor = const Color(0xFFF2F2F2),
      this.txtcolor = Colors.black,
      this.search = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // List<String> cityNames = items.map((city) => city["name"] ?? "").toList();
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0, bottom: 4.0),
                child: Text(
                  hintText,
                  style: TextStyle(
                    color: txtcolor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              DropdownSearch<String>(
                popupProps: PopupProps.menu(
                  showSearchBox: search
                ),
                items: (filter, infiniteScrollProps) =>
                    items.map((item) => item["name"] ?? "").toList(),
                selectedItem: selectedValue != null
                    ? items.firstWhere(
                        (item) => item["id"] == selectedValue)["name"]
                    : null,
                decoratorProps: DropDownDecoratorProps(
                  decoration: InputDecoration(
                    hintText: "Select",
                    prefixIcon: Icon(Icons.location_on, size: 30),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.white, width: 1),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.white, width: 1),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.grey, width: 1),
                    ),
                    fillColor: bgColor,
                    filled: true,
                  ),
                ),
                onChanged: (String? newValue) {
                  String? selectedId = items.firstWhere(
                      (item) => item["name"] == newValue,
                      orElse: () => {"id": ""})["id"];
                  onChanged(selectedId);
                },
              )
            ],
          ),
        ),
      ],
    );
  }
}
