import 'package:HolidayMakers/pages/homePages/splashscreen.dart';
import 'package:flutter/material.dart';

class NoInternetPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("No Internet")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.wifi_off, size: 80, color: Colors.red),
            SizedBox(height: 20),
            Text("No Internet Connection", style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Restart app or check internet again
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Splashscreen()),
                );
              },
              child: Text("Retry"),
            ),
          ],
        ),
      ),
    );
  }
}
