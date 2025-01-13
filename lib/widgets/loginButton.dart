import 'package:flutter/material.dart';
import 'package:holdidaymakers/widgets/appLargetext.dart';

class LoginButton extends StatelessWidget {
  final bool? isResponcive;
  final String text;
  final double border;
  final Color color;
  final Color textColor;
  final double buttonShadow;
  final String image;
  final double padding;
  LoginButton(
      {super.key,
      this.isResponcive,
      this.padding=0,
      required this.text,
      this.border = 50,
      this.color = const Color(0xFF3498DB),
      this.textColor = Colors.white,
      this.buttonShadow = 0.4,
      required this.image});

  @override
  Widget build(BuildContext context) {
    return Container( padding: EdgeInsets.only(left: padding),
      decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(buttonShadow), // Shadow color
              blurRadius: 8, // Controls how soft the shadow is
              offset: Offset(0, 4), // X and Y offset;
            )
          ]),
      width: 155,
      height: 56,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            child: Image.asset(image),
          ),
          Container( 
            padding: EdgeInsets.only(right: (35-padding)),
            child: AppLargeText(
              text: text,
              color: textColor,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}
