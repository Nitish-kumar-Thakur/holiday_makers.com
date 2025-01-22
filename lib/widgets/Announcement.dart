import 'package:flutter/material.dart';

class AnnouncementDialog {
  static void show(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent closing by tapping outside
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            width: 300, // Set width as needed
            height: 400, // Set height as needed
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              image: const DecorationImage(
                image: AssetImage('img/announcement.png'),
                fit: BoxFit.cover, // Adjust image scaling
              ),
            ),
            child: Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: const Icon(Icons.cancel, color: Colors.red, size: 30),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
