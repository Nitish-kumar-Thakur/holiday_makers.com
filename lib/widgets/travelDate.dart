import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For formatting the date

class TravelDateSelector extends StatefulWidget {
  const TravelDateSelector({super.key});

  @override
  State<TravelDateSelector> createState() => _TravelDateSelectorState();
}

class _TravelDateSelectorState extends State<TravelDateSelector> {
  // Controller for the text field
  TextEditingController dateController = TextEditingController();

  // Store the selected date
  DateTime? selectedDate;

  // Date format to display in the text field
  final DateFormat dateFormat = DateFormat('yyyy-MM-dd');

  // Function to show the date picker
  Future<void> _selectDate(BuildContext context) async {
    DateTime initialDate = selectedDate ?? DateTime.now();
    DateTime firstDate = DateTime(2000);
    DateTime lastDate = DateTime(2101);

    // Show the date picker
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
        dateController.text = dateFormat.format(pickedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Text to Date Selector')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: dateController,
              readOnly: true, // Make it read-only so user can only pick a date
              onTap: () => _selectDate(context),
              decoration: InputDecoration(
                border: null,
                filled: true,
                fillColor: Colors.grey.shade200,
                
              ),
            ),
          ],
        ),
      ),
    );
  }
}
