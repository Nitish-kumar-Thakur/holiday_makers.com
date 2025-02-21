import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import the intl package for date formatting

class Learn1 extends StatefulWidget {
  @override
  _Learn1State createState() => _Learn1State();
}

class _Learn1State extends State<Learn1> {
  DateTime _selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('yyyy-MM-dd').format(_selectedDate); // Format the date

    return Scaffold(
      appBar: AppBar(
        title: const Text('Clickable Text Date Picker'),
      ),
      body: Container(
        child: GestureDetector(
          onTap: () => _selectDate(context),
          child: Text(
            "$formattedDate", // Display the formatted date
            style: const TextStyle(
              fontSize: 18,
              color: Colors.blue,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ),
    );
  }
}
