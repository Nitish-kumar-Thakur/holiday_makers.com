// import 'package:flutter/material.dart';
// import 'package:holdidaymakers/widgets/appLargetext.dart';
// import 'package:shimmer/shimmer.dart';

// class HotelsAccommodation extends StatefulWidget {
//   final Map<String, dynamic> packageData;
//   const HotelsAccommodation({super.key, required this.packageData});

//   @override
//   State<HotelsAccommodation> createState() => _HotelsAccommodationState();
// }

// class _HotelsAccommodationState extends State<HotelsAccommodation> {
//   bool isLoading = true;
//   int selectedHotelIndex = 0; // First hotel is selected by default

//   @override
//   void initState() {
//     super.initState();
//     Future.delayed(const Duration(milliseconds: 800), () {
//       if (mounted) {
//         setState(() {
//           isLoading = false;
//         });
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     List<Map<String, dynamic>> hotelList = [];
//     widget.packageData["hotel_details"]?.forEach((rating, hotels) {
//       hotelList.addAll(List<Map<String, dynamic>>.from(hotels));
//     });

//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//             onPressed: () {
//               Navigator.pop(context);
//             },
//             icon: Icon(Icons.arrow_back)),
//         title: AppLargeText(
//           text: 'Accommodation',
//           size: 24,
//         ),
//       ),
//       body: SingleChildScrollView(
//           child: hotelList.isEmpty
//               ? Center(child: AppLargeText(text: "Hotel Not Available"))
//               : SizedBox(
//                   height: MediaQuery.of(context).size.height * 0.9,
//                   child: ListView.builder(
//                     itemCount: hotelList.length,
//                     itemBuilder: (_, index) {
//                       return Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: isLoading
//                             ? HotelCardShimmer()
//                             : HotelCard(
//                                 hotel: hotelList[index],
//                                 isSelected: selectedHotelIndex == index,
//                                 onTap: () {
//                                   setState(() {
//                                     selectedHotelIndex = index;
//                                   });
//                                 },
//                               ),
//                       );
//                     },
//                   ),
//                 )),
//     );
//   }
// }

// class HotelCard extends StatelessWidget {
//   final Map<String, dynamic> hotel;
//   final bool isSelected;
//   final VoidCallback onTap;

//   const HotelCard({
//     super.key,
//     required this.hotel,
//     required this.isSelected,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final String roomType = hotel["room_category"];
//     final String mealType = hotel["meal_plan"];
//     final String price = hotel["price_per_person"].toString() ?? "N/A";
//     final int star = int.parse(hotel["rating"] ?? 3);

//     return Card(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//       elevation: 8,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           ClipRRect(
//             borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
//             child: Image.network(
//               hotel["image"],
//               fit: BoxFit.cover,
//               width: screenWidth,
//             ),
//           ),
//           Padding(
//             padding: EdgeInsets.all(screenWidth * 0.04),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           hotel["hotel"],
//                           style: TextStyle(
//                             fontSize: screenWidth * 0.035,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         SizedBox(height: 4),
//                         Text(
//                           hotel["city"],
//                           style: TextStyle(
//                             color: Colors.grey[600],
//                             fontSize: screenWidth * 0.035,
//                           ),
//                         ),
//                       ],
//                     ),
//                     Row(
//                       children: List.generate(star, (index) {
//                         return Icon(
//                           Icons.star,
//                           color: Colors.amber,
//                           size: screenWidth * 0.035,
//                         );
//                       }),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 10),
//                 Text(
//                   'AED $price',
//                   style: TextStyle(
//                     fontSize: screenWidth * 0.035,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black,
//                   ),
//                 ),
//                 Text(
//                   'Price Per Person',
//                   style: TextStyle(
//                     fontSize: screenWidth * 0.03,
//                     color: Colors.grey[600],
//                   ),
//                 ),
//                 SizedBox(height: screenWidth * 0.03),
//                 SizedBox(
//                   width: double.infinity,
//                   child: ElevatedButton(
//                     onPressed: onTap,
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: isSelected ? Colors.red : Colors.green,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                     ),
//                     child: Text(
//                       isSelected ? 'SELECTED' : 'SELECT',
//                       style: TextStyle(
//                           color: Colors.white, fontSize: screenWidth * 0.04),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
