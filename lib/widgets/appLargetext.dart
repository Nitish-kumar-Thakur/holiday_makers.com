import 'package:flutter/material.dart';

class AppLargeText extends StatelessWidget {
  final double size;
  final String text;
  final Color color;

  AppLargeText({
    super.key,
    required this.text,
    this.size = 30,
    this.color = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    // Get the text scale factor from the device
    double textScaleFactor = MediaQuery.of(context).textScaleFactor;

    return Text(
      text,
      style: TextStyle(
        fontSize: size, 
        color: color, 
        fontWeight: FontWeight.bold
      ),
      textAlign: TextAlign.center,
      textScaleFactor: textScaleFactor, // Apply the text scale factor
    );
  }
}
