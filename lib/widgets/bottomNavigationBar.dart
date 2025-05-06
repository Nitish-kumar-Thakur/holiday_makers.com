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
    double iconSize = MediaQuery.of(context).size.width * 0.06;
    double barWidth = MediaQuery.of(context).size.width * 0.6;

    return Positioned(
      left: MediaQuery.of(context).size.width * 0.2,
      right: MediaQuery.of(context).size.width * 0.2,
      bottom: 30, // Floating position
      child: Container(
        width: barWidth,
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(50),
          border: Border.all(color: Colors.grey.shade400, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNavItem(FontAwesomeIcons.house, "Home", 0, iconSize),
            _buildNavItem(FontAwesomeIcons.user, "Account", 1, iconSize),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int itemIndex, double iconSize) {
    bool isSelected = index == itemIndex;

    return GestureDetector(
      onTap: () => onTapped(itemIndex),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            child: Icon(
              icon,
              size: iconSize,
              color: isSelected ? const Color(0xFF0071BC) : Colors.black54,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: isSelected ? const Color(0xFF0071BC) : Colors.black54,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
