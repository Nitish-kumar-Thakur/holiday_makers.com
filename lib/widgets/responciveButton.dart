import 'package:flutter/material.dart';
import 'package:HolidayMakers/widgets/appLargetext.dart';

class responciveButton extends StatelessWidget {
  final bool? isResponcive;
  final String text;
  final double border;
  final Color color;
  final Color textColor;
  final double buttonShadow;
  responciveButton({
    super.key,
    this.isResponcive,
    required this.text,
    this.border = 20,
    this.color = const Color(0xFF0071BC),
    this.textColor = Colors.white,
    this.buttonShadow = 0.4,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(buttonShadow), // Shadow color
              blurRadius: 8, // Controls how soft the shadow is
              offset: Offset(0, 4), // X and Y offset;
            )
          ]),
      width: 335,
      height: 56,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AppLargeText(
            text: text,
            color: textColor,
            size: 20,
          )
        ],
      ),
    );
  }
}
