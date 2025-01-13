import 'package:flutter/material.dart';
import 'package:holdidaymakers/pages/FixedDeparturesPages/departurePackagedetails.dart';
import 'package:holdidaymakers/pages/FixedDeparturesPages/departuresPackages.dart';
import 'package:holdidaymakers/widgets/appLargetext.dart';
import 'package:holdidaymakers/widgets/appText.dart';
import 'package:holdidaymakers/widgets/drawerPage.dart';
import 'package:holdidaymakers/widgets/dropdownWidget.dart';
import 'package:holdidaymakers/widgets/mainCarousel.dart';
import 'package:holdidaymakers/widgets/subCarousel.dart';
import 'package:intl/intl.dart'; // For date formatting

class DeparturesHome extends StatefulWidget {
  const DeparturesHome({super.key});

  @override
  State<DeparturesHome> createState() => _DeparturesHomeState();
}

class _DeparturesHomeState extends State<DeparturesHome> {
  DateTime? selectedDate; // For storing the selected date
  int selectedOption = 0; 
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  
  // Function to select date with customizations
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.blue, // Customizing the primary color
             // Customizing the accent color
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  final List<String> offers = ['img/image1.png', 'img/image1.png', 'img/image1.png', 'img/image1.png'];

  // List of dynamic sections
  final List<Map<String, dynamic>> sections = [
    {
      'title': 'Recommended',
      'list': ['img/recomended1.png', 'img/recomended2.png', 'img/recomended3.png'],
    },
    {
      'title': 'Winter Holidays',
      'list': ['img/winter1.png', 'img/winter2.png', 'img/winter2.png'],
    },
    {
      'title': 'Eid',
      'list': ['img/winter1.png', 'img/winter2.png', 'img/winter2.png'],
    },
  ];

  void navigateToSeeAll() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => const Departurespackages()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      drawer: Drawerpage(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Container(
              width: double.infinity,
              height: 120,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('img/homeBg.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    height: 45,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white70,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(100),
                        topRight: Radius.circular(100),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    _scaffoldKey.currentState?.openDrawer();
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    margin: const EdgeInsets.only(top: 15, left: 30, bottom: 15),
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Container(
                  height: 40,
                  width: 200,
                  margin: const EdgeInsets.all(15),
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('img/brandLogo.png'),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppLargeText(text: 'Fixed Departure Deals', color: Colors.black, size: 20),
                  SizedBox(height: 10),
                  Dropdownwidget(text: 'Select Country'),
                  SizedBox(height: 10),
                  AppLargeText(text: 'SELECT DATE', size: 16),
                  GestureDetector(
                    onTap: () => _selectDate(context),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.grey[200],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.calendar_today_outlined, color: Colors.black54),
                              SizedBox(width: 8),
                              Text(
                                selectedDate != null
                                    ? DateFormat('dd MMM yyyy').format(selectedDate!)
                                    : '',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          Icon(Icons.arrow_drop_down, color: Colors.black54),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Main Carousel
            Maincarousel(imgList: offers),

            // Dynamic Sections using ListView.builder
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: sections.length,
              itemBuilder: (context, index) {
                final section = sections[index];
                return Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AppText(
                            text: section['title'],
                            color: Colors.black,
                            size: 16,
                          ),
                          GestureDetector(
                            onTap: navigateToSeeAll,
                            child: Padding(padding: EdgeInsets.only(right: 5),
                            child: Row(
                              children: [
                                AppText(
                                  text: 'See All',
                                  color: const Color(0xFF0775BD),
                                  size: 15,
                                ),
                                const SizedBox(width: 1),
                                Image.asset('img/seeAll.png', height: 16),
                              ],
                            ),)
                          ),
                        ],
                      ),
                    ),
                    Padding(padding: const EdgeInsets.only(left: 15), child: const Divider(color: Colors.grey)),
                    Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: IconButton(onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const DeparturePackageDetails()));
                    }, icon: Subcarousel(lists: section['list'])),
                    ),
                    const SizedBox(height: 20),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
