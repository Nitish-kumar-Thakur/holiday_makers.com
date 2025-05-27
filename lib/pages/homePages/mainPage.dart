import 'package:HolidayMakers/pages/login&signup/Test.dart';
import 'package:flutter/material.dart';
import 'package:HolidayMakers/pages/homePages/homePage.dart';
import 'package:HolidayMakers/widgets/bottomNavigationBar.dart';
import 'package:HolidayMakers/widgets/profile_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Mainpage extends StatefulWidget {
  const Mainpage({super.key});

  @override
  State<Mainpage> createState() => _MainpageState();
}

class _MainpageState extends State<Mainpage> {
  int _selectedIndex = 0;
  final List<int> _historyStack = [];
  String firstName = "";
  List<Widget> _pages = [];
  bool isloading= false;
  bool isDrawerOpen = false;

  @override
  void initState() {
    super.initState();
    _loadProfileDetails();
  }

  Future<void> _loadProfileDetails() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      firstName = prefs.getString("first_name") ?? "";
      _pages = [
        HomePage(onDrawerToggle: (bool isOpen) {
          setState(() {
            isDrawerOpen = isOpen;
          });
        }),
        firstName.trim().isEmpty ? LoginPage(backbutton: true,) : ProfilePage(backbutton: true,),
      ];
    });
  }

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
          return false;
        }
        return true;
      },
      child: Scaffold(
        body: Stack(
          children: [
            IndexedStack(
              index: _selectedIndex,
              children: _pages,
            ),
            if (!isDrawerOpen)
              BottomNavigationBarPage(
                index: _selectedIndex,
                onTapped: _onItemTapped,
              ),
          ],
        ),

      ),
    );
  }
}
