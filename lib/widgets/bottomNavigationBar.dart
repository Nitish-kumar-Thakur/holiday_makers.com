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
      showSelectedLabels: false, // ❌ Hide labels
      showUnselectedLabels: false, // ❌ Hide labels
      iconSize: iconSize.clamp(20, 40), // Keep icons within a reasonable range
      elevation: 5, // Slight elevation for better UI
      items: [
        _buildNavItem(FontAwesomeIcons.house, 0, iconSize),
        _buildNavItem(FontAwesomeIcons.magnifyingGlass, 1, iconSize),
        _buildNavItem(FontAwesomeIcons.bell, 2, iconSize),
        _buildNavItem(FontAwesomeIcons.user, 3, iconSize),
      ],
    );
  }

  BottomNavigationBarItem _buildNavItem(
      IconData icon, int itemIndex, double iconSize) {
    return BottomNavigationBarItem(
      icon: Icon(
        icon,
        size: iconSize,
        color: index == itemIndex ? Colors.blue : Colors.black54,
      ),
      label: "", // ✅ Empty label to avoid errors
    );
  }
}
