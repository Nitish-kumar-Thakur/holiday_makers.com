// import 'package:flutter/material.dart';
// import 'package:holdidaymakers/pages/FullyIndependentTraveler/flightPage1.dart';
// import 'package:holdidaymakers/pages/FullyIndependentTraveler/payment_method.dart';
// import 'package:holdidaymakers/widgets/appLargetext.dart';
// import 'package:holdidaymakers/widgets/appText.dart';

// class Offersdiscount extends StatefulWidget {
//   final int index;
//   const Offersdiscount({super.key, this.index = 1});

//   @override
//   State<Offersdiscount> createState() => _OffersdiscountState();
// }

// class _OffersdiscountState extends State<Offersdiscount> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar( backgroundColor: Colors.white,
//         title: const Text('OFFERS & DISCOUNTS'),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () {
//             Navigator.pop(context); // Navigate back to the previous page
//           },
//         ),
//       ),
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: ListView.builder(
//             itemCount: 5, // Number of offers
//             itemBuilder: (_, index) {
//               return const OfferCard();
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }

// class OfferCard extends StatelessWidget {
//   const OfferCard({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 4,
//       margin: const EdgeInsets.symmetric(vertical: 8.0),
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: SizedBox(
//         height: 200,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Image Section
//             Container(
//               height: 130,
//               decoration: BoxDecoration(
//                 borderRadius: const BorderRadius.vertical(
//                   top: Radius.circular(10),
//                 ),
//                 image: const DecorationImage(
//                   image: AssetImage('img/offer1.png'),
//                   fit: BoxFit.cover,
//                 ),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Row(
//                   crossAxisAlignment: CrossAxisAlignment.end,
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     AppLargeText(
//                       text: 'Valid till Dec 16, 2025',
//                       size: 13,
//                       color: Colors.white,
//                     ),
//                     IconButton(
//                       onPressed: () {
//                         // Add share functionality here
//                       },
//                       icon: const Icon(
//                         Icons.share,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),

//             // Offer Details and Button Section
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   // Offer Details
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       AppText(
//                         text: 'Flat 12% OFF (Up to Rs.1,800)',
//                         size: 13,
//                         color: Colors.black,
//                       ),
//                       AppText(
//                         text: 'On Domestic Flights',
//                         size: 10,
//                         color: Colors.grey,
//                       ),
//                     ],
//                   ),

//                   // Book Now Button
//                   ElevatedButton(
//                     onPressed: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => PaymentMethod()));// Add booking functionality here
//                     },
//                     style: ElevatedButton.styleFrom(
//                       minimumSize: const Size(90, 40),
//                       backgroundColor: Colors.redAccent,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                     ),
//                     child: AppLargeText(
//                       text: 'BOOK NOW',
//                       color: Colors.white,
//                       size: 13,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
