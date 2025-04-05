// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:HolidayMakers/Controller/ConnectivityService.dart';

// class NoInternetPage extends StatefulWidget {
//   @override
//   _NoInternetPageState createState() => _NoInternetPageState();
// }

// class _NoInternetPageState extends State<NoInternetPage> {
//   bool _isChecking = false; // Track if we are checking the connection

//   void _retryConnection(BuildContext context) async {
//     setState(() {
//       _isChecking = true; // Show loading indicator
//     });

//     // Call manual check
//     await Provider.of<ConnectivityService>(context, listen: false).manualCheck();

//     setState(() {
//       _isChecking = false; // Hide loading indicator
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Image.asset('img/connectionLost.png', height: 250),
//             SizedBox(height: 20),
//             Text(
//               'No Internet Connection',
//               style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 10),
//             Padding(
//               padding: EdgeInsets.all(10),
//               child: Text(
//                 'Please check your internet connection and try again.',
//                 textAlign: TextAlign.center,
//                 style: TextStyle(fontSize: 16, color: Colors.grey[600]),
//               ),
//             ),
//             SizedBox(height: 30),

//             _isChecking
//                 ? CircularProgressIndicator() // Show loading while checking
//                 : ElevatedButton(
//                     onPressed: () => _retryConnection(context),
//                     child: Text('Retry'),
//                   ),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';
import 'package:HolidayMakers/Controller/ConnectivityService.dart';

class NoInternetPage extends StatefulWidget {
  @override
  _NoInternetPageState createState() => _NoInternetPageState();
}

class _NoInternetPageState extends State<NoInternetPage> {
  bool _isChecking = false;

void _retryConnection(BuildContext context) async {
  print("🔄 Retry button pressed. Checking internet...");

  setState(() {
    _isChecking = true;
  });

Provider.of<ConnectivityService>(context, listen: false).manualCheck();


  setState(() {
    _isChecking = false;
  });

  if (Provider.of<ConnectivityService>(context, listen: false).isOnline) {
    print("✅ Internet is back! Navigating to the last page...");
    Get.back();
  } else {
    print("❌ Still offline. Staying on NoInternetPage.");
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('img/connectionLost.png', height: 250),
            SizedBox(height: 20),
            Text(
              'No Internet Connection',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                'Please check your internet connection and try again.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
            ),
            SizedBox(height: 30),
            _isChecking
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () => _retryConnection(context),
                    child: Text('Retry'),
                  ),
          ],
        ),
      ),
    );
  }
}
