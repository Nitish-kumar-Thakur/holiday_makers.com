import 'package:flutter/material.dart';
import 'package:HolidayMakers/widgets/appLargetext.dart';

class Notifications extends StatelessWidget {
  const Notifications({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.9,
          child: Align(
            alignment: Alignment.center,
            child: AppLargeText(
              text: 'Notifications',
              size: 24,
            ),
          ),
        ),
      ),
    ));
  }
}
