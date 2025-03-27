// import 'package:HolidayMakers/Tabby/PaymentWebView.dart';
// import 'package:HolidayMakers/Tabby/TabbyPaymentService.dart';
// import 'package:HolidayMakers/Tabby/TelrPaymentService.dart';
// import 'package:HolidayMakers/pages/homePages/mainPage.dart';
// import 'package:HolidayMakers/utils/api_handler.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';

// class PaymentScreen extends StatefulWidget {
//   final Map<String, dynamic> sbAPIResponseBody;
//   final Map<String, dynamic> BSData;

//   const PaymentScreen(
//       {super.key, required this.sbAPIResponseBody, required this.BSData});
//   @override
//   _PaymentScreenState createState() => _PaymentScreenState();
// }

// class _PaymentScreenState extends State<PaymentScreen> {
//   List<dynamic> paymentMethods = [];
//   Map<String, dynamic> sbAPIResponse = {};
//   String? transactionRef;

//   @override
//   void initState() {
//     super.initState();
//     print(widget.BSData);
//     print(widget.sbAPIResponseBody);
//     paymentMethods = widget.BSData['payment_options'];
//   }

//   bool _loading = false;

//   void startPayment(String paymentMethod) async {
//     setState(() {
//       _loading = true;
//     });

//     String? checkoutUrl;

//     if (paymentMethod == "Tabby") {
//       checkoutUrl = await TabbyPaymentService.createTabbySession(100.0);
//     } else if (paymentMethod == "Telr") {
//       checkoutUrl = await TelrPaymentService.createTelrSession();
//     }

//     setState(() {
//       _loading = false;
//     });

//     if (checkoutUrl != null) {
//       String? result = await Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => PaymentWebView(paymentUrl: checkoutUrl.toString()),
//         ),
//       );

//       if (paymentMethod == "Telr" && result == "success" && transactionRef != null) {
//         // If Telr is selected, check the payment status after WebView closes
//         String paymentStatus = await TelrPaymentService.checkPaymentStatus(transactionRef!);

//         if (paymentStatus == "success") {
//           Fluttertoast.showToast(msg: "✅ Payment Successful!");
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(builder: (context) => Mainpage()),
//           );
//         } else if (paymentStatus == "declined") {
//           Fluttertoast.showToast(msg: "❌ Payment Declined!");
//         } else if (paymentStatus == "pending") {
//           Fluttertoast.showToast(msg: "⌛ Payment Pending!");
//         } else {
//           Fluttertoast.showToast(msg: "⚠️ Payment Failed!");
//         }
//       } else if (result == "success") {
//         // If Tabby is selected, just show success
//         Fluttertoast.showToast(msg: "✅ Payment Successful!");
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => Mainpage()),
//         );
//       } else {
//         Fluttertoast.showToast(msg: "❌ Payment Failed or Canceled!");
//       }
//     } else {
//       Fluttertoast.showToast(msg: "⚠️ Failed to initiate payment.");
//     }
//   }

//   // void handleCred(String paymentType) {
//   //   print(paymentType);
//   // }

//   Future<void> _saveBooking(String paymentType) async {
//     widget.sbAPIResponseBody['payment_type'] = paymentType;
//     print(widget.sbAPIResponseBody);
//     try {
//       final response = await APIHandler.fdSaveBooking(widget.sbAPIResponseBody);
//       if (response["status"] == true) {
//         setState(() {
//           sbAPIResponse = response;
//         });
//         startPayment(paymentType);
//       }
//     } catch (e) {
//       print("Error fetching booking data: $e");
//     }
//   }

//   Widget _buildTopCurve() {
//     return Padding(
//       padding: const EdgeInsets.only(top: 50), // 20% of the screen height
//       child: CustomPaint(
//         size: Size(double.infinity, 0), // Height of the curved area
//         painter: CirclePainter(radius: 200),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Column(
//         children: [
//           _buildTopCurve(),
//           const SizedBox(height: 10),
//           Row(
//             children: [
//               IconButton(
//                 onPressed: () {
//                   Navigator.pop(context);
//                 },
//                 icon: CircleAvatar(
//                   backgroundColor: Colors.grey
//                       .withOpacity(0.6), // Transparent grey background
//                   child: Text(
//                     '<', // Use "<" symbol
//                     style: TextStyle(
//                       color: Colors.white, // White text color
//                       fontSize: 24, // Adjust font size as needed
//                       fontWeight: FontWeight.bold, // Make the "<" bold
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 10),
//               Text(
//                 'SELECT PAYMENT METHOD',
//                 style: TextStyle(
//                   fontSize: 26,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white,
//                 ),
//               ),
//             ],
//           ),

//           // ListView for payment methods
//           Expanded(
//             child: ListView.builder(
//               itemCount: paymentMethods.length,
//               itemBuilder: (context, index) {
//                 final paymentMethod = paymentMethods[index];

//                 return Padding(
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//                   child: Card(
//                     color: Colors.grey.shade100,
//                     elevation: 5,
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(vertical: 8),
//                       child: ListTile(
//                         leading: Image.network(
//                           paymentMethod['payment_logo'] ?? '',
//                           width: 100, // Adjust the size of the image
//                           height: 100,
//                           fit: BoxFit.cover,
//                         ),
//                         title: Text(paymentMethod['label'] ?? ''),
//                         onTap: () {
//                           // Handle payment method selection
//                           _saveBooking(paymentMethod['payment_type']);
//                         },
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class CirclePainter extends CustomPainter {
//   final double radius;

//   CirclePainter({required this.radius});

//   @override
//   void paint(Canvas canvas, Size size) {
//     Paint paint = Paint()..style = PaintingStyle.fill;

//     // We can use FontAwesome icon positioning logic here.
//     double centerX = size.width / 2;

//     // Draw the largest circle (dark blue)
//     paint.color = Color(0xFF0D939E);
//     canvas.drawCircle(Offset(centerX, radius - 600), radius + 400, paint);
//   }

//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) {
//     return false;
//   }
// }
