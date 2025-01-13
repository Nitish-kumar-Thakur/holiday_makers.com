import 'package:flutter/material.dart';
import 'package:holdidaymakers/pages/Cruise/CurisesHome.dart';
import 'package:holdidaymakers/pages/FixedDeparturesPages/departuresHome.dart';
import 'package:holdidaymakers/pages/searchBarpage.dart';
import 'package:holdidaymakers/widgets/bottomNavigationBar.dart';
import 'package:holdidaymakers/widgets/notifications.dart';
import 'package:holdidaymakers/widgets/profile_page.dart';

class CurisesMain extends StatefulWidget {
  const CurisesMain({super.key});

  @override
  State<CurisesMain> createState() => _CurisesMainState();
}

class _CurisesMainState extends State<CurisesMain> {
  List pages = [
    CurisesHome(),
    SearchPage(),
    Notifications(),
    ProfilePage()
  ];
  int currentPage = 0; // Track current page index
  int _selectedIndex = 0; // Track selected bottom nav item index

  // Function to switch between pages based on the selected index
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBarPage(
          index: _selectedIndex, onTapped: _onItemTapped),
          body: pages[_selectedIndex],
    );
  }
}
