// import 'package:flutter/material.dart';
// import 'package:HolidayMakers/pages/FixedDeparturesPages/hotelsAccommodation.dart';
// import 'package:HolidayMakers/utils/api_handler.dart';
// import 'package:HolidayMakers/widgets/responciveButton.dart';
// import 'package:HolidayMakers/widgets/travelerDrawer.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:shimmer/shimmer.dart';

// class DepartureDeals extends StatefulWidget {
//   final String? packageId;
//   const DepartureDeals({super.key, this.packageId});

//   @override
//   // ignore: library_private_types_in_public_api
//   _DepartureDealsState createState() => _DepartureDealsState();
// }

// class _DepartureDealsState extends State<DepartureDeals> {
//   Map<String, dynamic> packageData = {};
//   List<dynamic> inclusionList = [];
//   List<dynamic> activityList = [];
//   List<dynamic> packageList = [];
//   bool isLoading = true;
//   int selectedOption = 0;
//   String? selectedRoom = "1";
//   String? selectedAdult = "2";
//   String? selectedChild = "0";
//   List<String>? childrenAge;
//   Map<String, dynamic>? selectedPackageData;
//   List<dynamic> totalRoomsdata = [
//     {"adults": "2", "children": "0", "childrenAges": []}
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _fetchPackageDetails();
//     _fetchPackageCards();
//   }

//   Future<void> _fetchPackageDetails() async {
//     try {
//       final response =
//           await APIHandler.getDepartureDeal(widget.packageId ?? "");
//       setState(() {
//         packageData = response;
//         inclusionList = response["inclusion_list"];
//         activityList = response["activity_list"];
//       });
//     } catch (error) {
//       print("Error fetching package details: $error");
//       setState(() {
//         isLoading =
//             false; // Ensures loading state is updated even if an error occurs
//       });
//     }
//   }

//   Future<void> _fetchPackageCards() async {
//     try {
//       final response = await APIHandler.getFDCards(widget.packageId ?? "");
//       setState(() {
//         packageList = response['data'] ?? [];
//         isLoading = false;
//         selectedPackageData = packageList[0];
//         selectedOption = 0;
//       });
//     } catch (e) {
//       print("Error fetching package cards: $e");
//     }
//   }

//   Widget buildInclusionCard(String iconClass, String label) {
//     // Default icon in case no match is found
//     IconData icon = FontAwesomeIcons.circleQuestion;

//     // Map FontAwesome icon classes to Flutter icon
//     if (iconClass == "fa fa-plane") {
//       icon = FontAwesomeIcons.plane;
//     } else if (iconClass == "fa fa-bed") {
//       icon = FontAwesomeIcons.bed;
//     } else if (iconClass == "fa fa-car") {
//       icon = FontAwesomeIcons.car;
//     } else if (iconClass == "fa fa-shield") {
//       icon = FontAwesomeIcons.shieldHalved;
//     } else if (iconClass == "fa fa-binoculars") {
//       icon = FontAwesomeIcons.binoculars;
//     } else if (iconClass == "far fa-daily-breakfast") {
//       icon = FontAwesomeIcons.utensils;
//     } else if (iconClass == "fa fa-user") {
//       icon = FontAwesomeIcons.user;
//     }

//     return Container(
//       width: 75,
//       height: 70,
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(icon, size: 30, color: Colors.red),
//           const SizedBox(height: 2),
//           Text(
//             label,
//             style: TextStyle(
//                 fontSize: MediaQuery.of(context).size.width * 0.02,
//                 color: Colors.black),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(image: DecorationImage(image: AssetImage('img/departureDealsBG.png'), fit: BoxFit.fill)),
//       child: Scaffold(
//         backgroundColor: Colors.transparent,
//         appBar: AppBar(
//           backgroundColor: Colors.transparent,
//           leading: IconButton(
//             onPressed: () {
//               Navigator.pop(context);
//             },
//             icon: CircleAvatar(
//               backgroundColor: Colors.grey.withOpacity(0.6),  // Transparent grey background
//               child: Text(
//                 '<',  // Use "<" symbol
//                 style: TextStyle(
//                   color: Colors.white,  // White text color
//                   fontSize: 24,  // Adjust font size as needed
//                   fontWeight: FontWeight.bold,  // Make the "<" bold if needed
//                 ),
//               ),
//             ),
//           ),
//           title: Text(
//             'FIXED DEPARTURES',
//             style: TextStyle(
//               fontSize: 24,
//               fontWeight: FontWeight.bold,
//               color: Colors.white,
//             ),
//           ),
//         ),
//         body: Expanded(child:
//         SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: isLoading
//                 ? _buildShimmerEffect()
//                 : Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Package Selection Section
//                 Text(
//                   'SELECT DEPARTURE',
//                   style: TextStyle(
//                     fontSize: 24,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white,
//                   ),
//                 ),
//                 SizedBox(height: 10),

//                 Column(
//                   children: packageList.asMap().entries.map((entry) {
//                     int index = entry.key;
//                     var package = entry.value;

//                     return Column(
//                       children: [
//                         PackageCard(
//                           title: package['package_name'] ?? '',
//                           departureDate: "${package['dep_date']}",
//                           arrivalDate: "${package['arrival_date']}",
//                           duration: '${package['duration']}',
//                           price:
//                           '${package['currency']} ${package['price']}',
//                           isSelected: selectedOption == index,
//                           onSelect: () {
//                             setState(() {
//                               selectedOption = index;
//                               selectedPackageData =
//                                   package; // Store selected package data
//                             });
//                           },
//                         ),
//                         SizedBox(height: 10),
//                       ],
//                     );
//                   }).toList(),
//                 ),
//                 SizedBox(height: 24),

//                 // Traveler Selection
//                 Text(
//                   'SELECT TRAVELLERS',
//                   style: TextStyle(
//                     fontSize: 24,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white,
//                   ),
//                 ),
//                 SizedBox(height: 10),
//                 Travelerdrawer(
//                   onSelectionChanged: (Map<String, dynamic> selection) {
//                     setState(() {
//                       selectedRoom = selection['totalRooms'].toString();
//                       selectedAdult = selection['totalAdults'].toString();
//                       selectedChild = selection['totalChildren'].toString();
//                       childrenAge = selection['childrenAges'];
//                       totalRoomsdata = selection["totalData"];
//                       // print("@@@@@@@@@@@@@@@@@@@@@@@@");
//                       // print(selectedAdult);
//                       // print("@@@@@@@@@@@@@@@@@@@@@@@@@@");
//                     });
//                   },
//                 ),
//                 SizedBox(height: 30),
//               ],
//             ),
//           ),
//         ),),

//         // Bottom Navigation Button
//         bottomNavigationBar: isLoading
//             ? null
//             : Padding(
//           padding: EdgeInsets.only(bottom: 15),
//           child: IconButton(
//             onPressed: () {
//               if (selectedPackageData != null) {
//                 print("@@@@@@@@@@@@@@@@@@@@@@@@");
//                 print(totalRoomsdata);
//                 print(selectedPackageData);
//                 print("@@@@@@@@@@@@@@@@@@@@@@@@@@");
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => HotelsAccommodation(
//                         activityList: activityList,
//                         packageData: selectedPackageData!,
//                         totalRoomsdata: totalRoomsdata),
//                   ),
//                 );
//               }
//             },
//             icon: responciveButton(text: 'NEXT'),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildShimmerEffect() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Shimmer.fromColors(
//           baseColor: Colors.grey[300]!,
//           highlightColor: Colors.grey[100]!,
//           child: Container(
//             height: 30,
//             width: 200,
//             color: Colors.white,
//           ),
//         ),
//         SizedBox(height: 20),

//         // Cruise Option Shimmer
//         Shimmer.fromColors(
//           baseColor: Colors.grey[300]!,
//           highlightColor: Colors.grey[100]!,
//           child: Container(
//             height: 100,
//             width: double.infinity,
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(10),
//             ),
//           ),
//         ),
//         SizedBox(height: 24),

//         // Inclusion Section Shimmer
//         Shimmer.fromColors(
//           baseColor: Colors.grey[300]!,
//           highlightColor: Colors.grey[100]!,
//           child: Container(
//             height: 150,
//             width: double.infinity,
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(10),
//             ),
//           ),
//         ),
//         SizedBox(height: 24),

//         // Travelers Selection Shimmer
//         Shimmer.fromColors(
//           baseColor: Colors.grey[300]!,
//           highlightColor: Colors.grey[100]!,
//           child: Container(
//             height: 50,
//             width: double.infinity,
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(10),
//             ),
//           ),
//         ),
//         SizedBox(height: 30),

//         // Button Shimmer
//         Align(
//           alignment: Alignment.center,
//           child: Shimmer.fromColors(
//             baseColor: Colors.grey[300]!,
//             highlightColor: Colors.grey[100]!,
//             child: Container(
//               height: 50,
//               width: 150,
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(10),
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

// class PackageCard extends StatefulWidget {
//   final String title;
//   final String departureDate;
//   final String arrivalDate;
//   final String duration;
//   final String price;
//   final bool isSelected;
//   final VoidCallback onSelect;

//   const PackageCard({
//     super.key,
//     required this.title,
//     required this.departureDate,
//     required this.arrivalDate,
//     required this.duration,
//     required this.price,
//     required this.isSelected,
//     required this.onSelect,
//   });

//   @override
//   State<PackageCard> createState() => _PackageCardState();
// }

// class _PackageCardState extends State<PackageCard> {
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: widget.onSelect,
//       child: Container(
//         padding: EdgeInsets.symmetric(horizontal: 16, vertical: 25),
//         decoration: BoxDecoration(
//           color: Colors.grey[200]!,
//           borderRadius: BorderRadius.circular(20),
//           border: Border.all(
//               color: widget.isSelected ? Color(0xFF0071BC) : Colors.grey.shade200,
//             width: 2
//           ),
//         ),
//         child: Column(
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 SizedBox(
//                   width: MediaQuery.of(context).size.width *
//                       0.5, // 50% of screen width
//                   child: Text(
//                     widget.title.toUpperCase(),
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 16,
//                     ),
//                   ),
//                 ),
//                 Row(
//                   children: [
//                     Text(
//                       widget.price,
//                       style: TextStyle(
//                         color: Colors.red,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 16,
//                       ),
//                     ),
//                     SizedBox(width: 8),
//                     Container(
//                       height: 10,
//                       width: 10,
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         color: widget.isSelected
//                             ? Colors.blue
//                             : Colors.transparent,
//                         border: Border.all(color: Colors.blue),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//             SizedBox(height: 10),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               crossAxisAlignment: CrossAxisAlignment.start, // Align items properly
//               children: [
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       "Travel Details",
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 16,
//                         color: Colors.black,
//                       ),
//                     ),
//                     SizedBox(height: 4),
//                     Text(
//                       '${widget.departureDate} - ${widget.arrivalDate}',
//                       style: TextStyle(
//                         color: Colors.grey[600],
//                         fontSize: 14,
//                       ),
//                     ),
//                   ],
//                 ),
//                 Container(
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(50),
//                     border: Border.all(width: 1, color: Colors.grey),
//                   ),
//                   child: Center(
//                     child: Padding(
//                       padding: EdgeInsets.all(5),
//                       child: Text(
//                         widget.duration,
//                         style: TextStyle(
//                           color: Colors.grey[600],
//                           fontSize: MediaQuery.of(context).size.width * 0.03,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
