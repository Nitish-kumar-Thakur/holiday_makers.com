import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BottomNavigationBarPage extends StatelessWidget {
  final int index;
  final Function(int) onTapped;

  const BottomNavigationBarPage({
    super.key,
    required this.index,
    required this.onTapped,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double iconSize = screenWidth * 0.06; // Icon size based on screen width

    return BottomNavigationBar(
      backgroundColor: Colors.white,
      currentIndex: index,
      onTap: onTapped,
      type: BottomNavigationBarType.fixed,
      showSelectedLabels: true, // ❌ Hide labels
      showUnselectedLabels: true, // ❌ Hide labels
      selectedItemColor: Color(0xFF0071BC), // Color for selected label & icon
      unselectedItemColor: Colors.black54, // Color for unselected label & icon
      selectedLabelStyle: const TextStyle(fontSize: 12, color: Color(0xFF0071BC)), // Fixed size & color
      unselectedLabelStyle: const TextStyle(fontSize: 12, color: Colors.black54), // Fixed size & color// Fixed label size
      iconSize: iconSize.clamp(20, 40), // Keep icons within a reasonable range
      elevation: 5, // Slight elevation for better UI
      items: [
        _buildNavItem(FontAwesomeIcons.house, 0, iconSize, "Home"),
        _buildNavItem(FontAwesomeIcons.personWalkingLuggage, 1, iconSize,"FIT"),
        _buildNavItem(FontAwesomeIcons.sailboat, 2, iconSize, "Cruise"),
        _buildNavItem(FontAwesomeIcons.personHiking, 3, iconSize,"FD"),
        _buildNavItem(FontAwesomeIcons.user, 4, iconSize, "Account"),
      ],
    );
  }

  BottomNavigationBarItem _buildNavItem(
      IconData icon, int itemIndex, double iconSize, String label) {
    return BottomNavigationBarItem(
      icon: Icon(
        icon,
        size: iconSize,
        color: index == itemIndex ? Color(0xFF0071BC) : Colors.black54,
      ),
      label:  label, backgroundColor: index == itemIndex ? Color(0xFF0071BC) : Colors.black54, // ✅ Empty label to avoid errors
    );
  }
}
