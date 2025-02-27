// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:razorpay_flutter/razorpay_flutter.dart';
// import 'add_payment_method.dart'; // Import the AddPaymentMethod file

// class PaymentMethod extends StatefulWidget {
//   PaymentMethod({super.key});

//   @override
//   State<PaymentMethod> createState() => _PaymentMethodState();
// }

// class _PaymentMethodState extends State<PaymentMethod> {
//   Razorpay _razorpay = Razorpay();

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
//     _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
//     _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: Icon(Icons.arrow_back, color: Colors.black),
//         backgroundColor: Colors.white,
//         elevation: 0,
//       ),
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Padding(
//             padding: const EdgeInsets.only(left: 20, top: 10),
//             child: Text(
//               'Payment Methods',
//               style: TextStyle(
//                 color: Colors.black,
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//           const SizedBox(height: 50),
//           Expanded(
//             child: ListView(
//               children: [
//                 buildPaymentOption(
//                   context,
//                   'img/visa.png',
//                   'Visa',
//                 ),
//                 buildPaymentOption(
//                   context,
//                   'img/mastercard.png',
//                   'MasterCard',
//                 ),
//                 buildPaymentOption(
//                   context,
//                   'img/amex.png',
//                   'American Express',
//                 ),
//                 buildPaymentOption(
//                   context,
//                   'img/paypal.png',
//                   'PayPal',
//                 ),
//                 buildPaymentOption(
//                   context,
//                   'img/diners.png',
//                   'Diners',
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//       backgroundColor: Colors.white,
//     );
//   }

//   Widget buildPaymentOption(
//       BuildContext context, String iconPath, String title) {
//     return GestureDetector(
//       onTap: () {
//         var options = {
//           'key': 'rzp_test_rl9tnknBb0p6Sx',
//           'amount': 10000,
//           'name': 'Acme Corp.',
//           'description': 'Fine T-Shirt',
//           'prefill': {'contact': '8888888888', 'email': 'test@razorpay.com'}
//         };
//         _razorpay.open(options);
//         // Navigate to AddPaymentMethod screen on tap
//         // Navigator.push(
//         //   context,
//         //   MaterialPageRoute(builder: (context) => AddPaymentMethod()),
//         // );
//       },
//       child: Padding(
//         padding: const EdgeInsets.symmetric(vertical: 10),
//         child: Container(
//           height: 70, // Increased height for the option
//           decoration: BoxDecoration(
//             color: Colors.grey.shade100,
//           ),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Row(
//                 children: [
//                   const SizedBox(width: 10), // Left padding for icon
//                   Image.asset(
//                     iconPath,
//                     width: 40,
//                     height: 40,
//                     fit: BoxFit.contain,
//                   ),
//                   const SizedBox(width: 20), // Space between icon and text
//                   Text(
//                     title,
//                     style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.w500,
//                       color: Colors.grey.shade700,
//                     ),
//                   ),
//                 ],
//               ),
//               Padding(
//                 padding:
//                     const EdgeInsets.only(right: 10), // Right padding for arrow
//                 child: Icon(
//                   Icons.arrow_forward_ios,
//                   size: 16,
//                   color: Colors.grey,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   void _handlePaymentSuccess(PaymentSuccessResponse response) {
//     // Do something when payment succeeds
//     Fluttertoast.showToast(msg: "Payment Sucess");
//   }

//   void _handlePaymentError(PaymentFailureResponse response) {
//     // Do something when payment fails
//     Fluttertoast.showToast(msg: "Payment Failure");
  
//   }
//   void _handleExternalWallet(ExternalWalletResponse response) {
//   // Do something when an external wallet was selected
//   Fluttertoast.showToast(msg: "Payment Sucess");
// }
//   @override
//   void dispose() {
//     // Clean up Razorpay when the widget is disposed
//     _razorpay.clear();
//     super.dispose();
//   }
// }
