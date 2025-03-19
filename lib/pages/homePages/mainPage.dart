import 'package:flutter/material.dart';
import 'package:HolidayMakers/pages/Cruise/CurisesHome.dart';
import 'package:HolidayMakers/pages/FixedDeparturesPages/departuresHome.dart';
import 'package:HolidayMakers/pages/homePages/homePage.dart';
import 'package:HolidayMakers/pages/FullyIndependentTraveler/independentTravelerPage.dart';
import 'package:HolidayMakers/widgets/bottomNavigationBar.dart';
import 'package:HolidayMakers/widgets/profile_page.dart';

class Mainpage extends StatefulWidget {
  const Mainpage({super.key});

  @override
  State<Mainpage> createState() => _MainpageState();
}

class _MainpageState extends State<Mainpage> {
  int _selectedIndex = 0;
  final List<int> _historyStack = [];

  final List<Widget> _pages = [
    HomePage(),
    IndependentTravelerPage(),
    CurisesHome(),
    DeparturesHome(),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    if (_selectedIndex != index) {
      _historyStack.add(_selectedIndex);
    }
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_historyStack.isNotEmpty) {
          setState(() {
            _selectedIndex = _historyStack.removeLast();
          });
          return false; // Prevent app from closing
        }
        return true; // Allow app exit
      },
      child: Scaffold(
        bottomNavigationBar: BottomNavigationBarPage(
          index: _selectedIndex,
          onTapped: _onItemTapped,
        ),
        body: IndexedStack(
          index: _selectedIndex,
          children: _pages,
        ),
      ),
    );
  }
}
