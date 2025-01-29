import 'package:flutter/material.dart';
import 'package:holdidaymakers/pages/Cruise/CurisesHome.dart';
import 'package:holdidaymakers/pages/FixedDeparturesPages/departuresHome.dart';
import 'package:holdidaymakers/pages/FullyIndependentTraveler/homePage.dart';
import 'package:holdidaymakers/pages/FullyIndependentTraveler/independentTravelerPage.dart';
import 'package:holdidaymakers/pages/searchBarpage.dart';
import 'package:holdidaymakers/widgets/bottomNavigationBar.dart';
import 'package:holdidaymakers/widgets/notifications.dart';
import 'package:holdidaymakers/widgets/profile_page.dart';

class Mainpage extends StatefulWidget {
  const Mainpage({super.key});

  @override
  State<Mainpage> createState() => _MainpageState();
}

class _MainpageState extends State<Mainpage> {
  List<Widget> pages = [
    HomePage(),
    IndependentTravelerPage(),
    CurisesHome(),
    DeparturesHome(),
    ProfilePage()
  ];

  int _selectedIndex = 0; // Track current selected index
  List<int> _historyStack = []; // Stack to track navigation history

  // Function to switch between pages
  void _onItemTapped(int index) {
    if (_selectedIndex != index) {
      _historyStack.add(_selectedIndex); // ✅ Store the current page before switching
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
            _selectedIndex = _historyStack.removeLast(); // Go back to the last visited page
          });
          return false; // Prevent app from closing
        }
        return true; // Allow app exit if no history left
      },
      child: Scaffold(
        bottomNavigationBar: BottomNavigationBarPage(
          index: _selectedIndex,
          onTapped: _onItemTapped,
        ),
        body: pages[_selectedIndex],
      ),
    );
  }
}
