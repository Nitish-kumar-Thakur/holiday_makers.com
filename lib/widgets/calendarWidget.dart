import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import the intl package for date formatting

class Calendarwidget extends StatefulWidget {
  final ValueChanged<DateTime?> onDateSelected;

  const Calendarwidget({Key? key, required this.onDateSelected}) : super(key: key);

  @override
  _CalendarwidgetState createState() => _CalendarwidgetState();
}

class _CalendarwidgetState extends State<Calendarwidget> {
  DateTime? _selectedDate; // Allow null initially

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
      widget.onDateSelected(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = _selectedDate != null
        ? DateFormat('dd MMM yy, EEE').format(_selectedDate!)
        : "Select"; // Show "Select" if no date is chosen

    return GestureDetector(
      onTap: () => _selectDate(context),
      child: Text(
        formattedDate, // Display formatted date or "Select"
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.black, // Adjust color for visibility
        ),
      ),
    );
  }
}
