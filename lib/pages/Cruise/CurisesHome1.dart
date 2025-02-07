// import 'package:flutter/material.dart';
// import 'package:holdidaymakers/widgets/learn.dart';
// import 'package:holdidaymakers/pages/Cruise/CurisesPackage.dart';
// import 'package:holdidaymakers/pages/Cruise/cruisePackagedetails.dart';
// import 'package:holdidaymakers/utils/api_handler.dart';
// import 'package:holdidaymakers/widgets/appLargetext.dart';
// import 'package:holdidaymakers/widgets/appText.dart';
// import 'package:holdidaymakers/widgets/drawerPage.dart';
// import 'package:holdidaymakers/widgets/dropdownWidget.dart';
// import 'package:holdidaymakers/widgets/mainCarousel.dart';
// import 'package:holdidaymakers/widgets/subCarousel.dart';
// import 'package:shared_preferences/shared_preferences.dart'; // For date formatting

// class CurisesHome1 extends StatefulWidget {
//   const CurisesHome1({super.key});

//   @override
//   State<CurisesHome1> createState() => _CurisesHome1State();
// }

// class _CurisesHome1State extends State<CurisesHome1> {
//   DateTime? selectedDate; // For storing the selected date
//   int selectedOption = 0; 
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
//    final TextEditingController countryController = TextEditingController();
//   final TextEditingController monthController = TextEditingController();
 
  
//   // Function to select date with customizations
//   // Future<void> _selectDate(BuildContext context) async {
//   //   final DateTime? picked = await showDatePicker(
//   //     context: context,
//   //     initialDate: DateTime.now(),
//   //     firstDate: DateTime.now(),
//   //     lastDate: DateTime(2030),
//   //     builder: (BuildContext context, Widget? child) {
//   //       return Theme(
//   //         data: ThemeData.light().copyWith(
//   //           primaryColor: Colors.blue, // Customizing the primary color
//   //            // Customizing the accent color
//   //           buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
//   //         ),
//   //         child: child!,
//   //       );
//   //     },
//   //   );
//   //   if (picked != null && picked != selectedDate) {
//   //     setState(() {
//   //       selectedDate = picked;
//   //     });
//   //   }
//   // }

//  List<Map<String, dynamic>> banner_list = [];
//      @override
//   void initState() {
//     super.initState();
//     _loadProfileDetails();
//     _fetchHomePageData(); // Fetch data on initialization
//   }
//     String profileImg = '';
//   bool isLoading = true; 

//   Future<void> _loadProfileDetails() async {
//     final prefs = await SharedPreferences.getInstance();
//     setState(() {
//       profileImg = prefs.getString("profileImg") ?? "";
//     });
//   }

//   Future<void> _fetchHomePageData() async {
//     try {
//       final data = await APIHandler.HomePageData();

//       setState(() {
//         banner_list = List<Map<String, dynamic>>.from(
//           data['data']['banner_list'].map((item) => {
//                 'img': item['img'],
//                 'mobile_img': item['mobile_img'],
//                 'link': item['link'],
//               }),
//         );
//         isLoading = false; // Data fetched, set loading to false
//       });
//     } catch (e) {
//       setState(() {
//         isLoading = false; // If error occurs, also stop loading
//       });
//       print('Error: $e');
//     }
//   }

//   // List of dynamic sections
//   final List<Map<String, dynamic>> sections = [
//     {
//       'title': 'Recommended',
//       'list': ['img/recomended1.png', 'img/recomended2.png', 'img/recomended3.png'],
//     },
//     {
//       'title': 'Winter Holidays',
//       'list': ['img/winter1.png', 'img/winter2.png', 'img/winter2.png'],
//     },
//     {
//       'title': 'Eid',
//       'list': ['img/winter1.png', 'img/winter2.png', 'img/winter2.png'],
//     },
//   ];

//   void navigateToSeeAll() {
//     Navigator.push(context, MaterialPageRoute(builder: (context) => const Curisespackage()));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       key: _scaffoldKey,
//       resizeToAvoidBottomInset: true,
//       backgroundColor: Colors.white,
//       drawer: Drawerpage(),
//       body:  isLoading
//           ? Center(
//               child: CircularProgressIndicator(color: Colors.red,), // Show loader until data is fetched
//             )
//           :SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Header Section
//             Container(
//               width: double.infinity,
//               height: 120,
//               decoration: const BoxDecoration(
//                 image: DecorationImage(
//                   image: AssetImage('img/homeBg.png'),
//                   fit: BoxFit.cover,
//                 ),
//               ),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   Container(
//                     height: 45,
//                     width: double.infinity,
//                     decoration: const BoxDecoration(
//                       color: Colors.white70,
//                       borderRadius: BorderRadius.only(
//                         topLeft: Radius.circular(100),
//                         topRight: Radius.circular(100),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 GestureDetector(
//                   onTap: () {
//                     _scaffoldKey.currentState?.openDrawer();
//                   },
//                   child: Padding(
//                           padding: const EdgeInsets.only(left: 20),
//                           child: CircleAvatar(
//                             backgroundImage: profileImg.isNotEmpty
//                                 ? NetworkImage(profileImg)
//                                 : const AssetImage('img/placeholder.png')
//                                     as ImageProvider,
//                             minRadius: 22,
//                             maxRadius: 22,
//                           ),
//                         ),
//                 ),
//                 Container(
//                   height: 40,
//                   width: 200,
//                   margin: const EdgeInsets.all(15),
//                   decoration: const BoxDecoration(
//                     image: DecorationImage(
//                       image: AssetImage('img/brandLogo.png'),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             Padding(
//               padding: EdgeInsets.all(10),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   AppLargeText(text: 'Curises', color: Colors.black, size: 20),
//                   SizedBox(height: 10),
//                   // Dropdownwidget(selectedValue: "selectedValue", items: [], hintText: "Select Country", onChanged: (value) => {},),
//                   SizedBox(height: 10),
//                   // Dropdownwidget(selectedValue: "selectedValue", items: [], hintText: "Select Month", onChanged: (value) => {},),
                  
//                 ],
//               ),
//             ),

//             // Main Carousel
//             Maincarousel(banner_list: banner_list),

//             // Dynamic Sections using ListView.builder
//             ListView.builder(
//               physics: const NeverScrollableScrollPhysics(),
//               shrinkWrap: true,
//               itemCount: sections.length,
//               itemBuilder: (context, index) {
//                 final section = sections[index];
//                 return Column(
//                   children: [
//                     Container(
//                       margin: const EdgeInsets.only(left: 15),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           AppText(
//                             text: section['title'],
//                             color: Colors.black,
//                             size: 16,
//                           ),
//                           GestureDetector(
//                             onTap: navigateToSeeAll,
//                             child: Padding(padding: EdgeInsets.only(right: 5),
//                             child: Row(
//                               children: [
//                                 AppText(
//                                   text: 'See All',
//                                   color: const Color(0xFF0775BD),
//                                   size: 15,
//                                 ),
//                                 const SizedBox(width: 1),
//                                 Image.asset('img/seeAll.png', height: 16),
//                               ],
//                             ),)
//                           ),
//                         ],
//                       ),
//                     ),
//                     Padding(padding: const EdgeInsets.only(left: 15), child: const Divider(color: Colors.grey)),
//                     Padding(
//                       padding: const EdgeInsets.only(left: 15),
//                       child: IconButton(onPressed: (){
//                       Navigator.push(context, MaterialPageRoute(builder: (context) => const CruisePackageDetails()));
//                     }, icon: Subcarousel2(lists: section['list'])),
//                     ),
//                     const SizedBox(height: 20),
//                   ],
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
