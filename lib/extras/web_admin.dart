import 'package:flutter/material.dart';
import 'package:HolidayMakers/extras/home_page.dart';

class WebAdmin extends StatefulWidget {
  @override
  _WebAdminState createState() => _WebAdminState();
}

class _WebAdminState extends State<WebAdmin> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomePage(),
    EmployeesPage(),
    AttendancePage(),
    SummaryPage(),
    InformationPage(),
    WorkspacesPage(),
    FinancePage(),
    SettingsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          NavigationBar(
            onItemSelected: _onItemTapped,
            selectedIndex: _selectedIndex,
          ),
          Expanded(child: _pages[_selectedIndex]),
        ],
      ),
    );
  }
}

class NavigationBar extends StatelessWidget {
  final Function(int) onItemSelected;
  final int selectedIndex;

  NavigationBar({required this.onItemSelected, required this.selectedIndex});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 5, spreadRadius: 2)
        ],
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 220,
            child: DrawerHeader(
              decoration: BoxDecoration(border: null),
              child: Column(
                children: [
                  Icon(Icons.admin_panel_settings,
                      size: 30, color: Colors.black),
                  SizedBox(height: 10),
                  Divider(),
                  CircleAvatar(
                    maxRadius: 30,
                  ),
                  SizedBox(height: 10),
                  Text("Nitish Thakur",
                      style: TextStyle(color: Colors.black, fontSize: 13)),
                  SizedBox(height: 5),
                  Text("Admin",
                      style: TextStyle(color: Colors.black, fontSize: 13)),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                navItem(Icons.home, "Home", 0),
                navItem(Icons.people, "Employees", 1),
                navItem(Icons.access_time, "Attendance", 2),
                navItem(Icons.assessment, "Summary", 3),
                navItem(Icons.info, "Information", 4),
                navItem(Icons.workspaces_filled, "Workspaces", 5),
                navItem(Icons.account_balance, "Finance", 6),
                navItem(Icons.settings, "Settings", 7),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget navItem(IconData icon, String title, int index) {
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: Material(
        color: selectedIndex == index
            ? Colors.blue.withOpacity(0.2)
            : Colors.transparent,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12), bottomLeft: Radius.circular(12)),
        child: InkWell(
          onTap: () => onItemSelected(index),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12), bottomLeft: Radius.circular(12)),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12)),
              color: selectedIndex == index ? Colors.grey.shade200 : null,
            ),
            child: Row(
              children: [
                Icon(icon,
                    color: selectedIndex == index ? Colors.black : Colors.grey),
                SizedBox(width: 10),
                Text(
                  title,
                  style: TextStyle(
                    color: selectedIndex == index ? Colors.black : Colors.grey,
                    fontWeight: selectedIndex == index
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Placeholder pages for each section

class EmployeesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.grey.shade200),
      child:
          Center(child: Text("Employees Page", style: TextStyle(fontSize: 24))),
    );
  }
}

class AttendancePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.grey.shade200),
      child:
          Center(child: Text("Employees Page", style: TextStyle(fontSize: 24))),
    );
  }
}

class SummaryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.grey.shade200),
      child:
          Center(child: Text("Employees Page", style: TextStyle(fontSize: 24))),
    );
  }
}

class InformationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.grey.shade200),
      child:
          Center(child: Text("Employees Page", style: TextStyle(fontSize: 24))),
    );
  }
}

class WorkspacesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.grey.shade200),
      child:
          Center(child: Text("Employees Page", style: TextStyle(fontSize: 24))),
    );
  }
}

class FinancePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.grey.shade200),
      child:
          Center(child: Text("Employees Page", style: TextStyle(fontSize: 24))),
    );
  }
}

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.grey.shade200),
      child:
          Center(child: Text("Employees Page", style: TextStyle(fontSize: 24))),
    );
  }
}
