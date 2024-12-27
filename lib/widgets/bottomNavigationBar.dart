import 'package:flutter/material.dart';

class BottomNavigationBarPage extends StatelessWidget {
  final int index;
  final Function(int) onTapped;
  const BottomNavigationBarPage({super.key,
  required this.index,
  required this.onTapped
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.white,
      currentIndex: index, // Set the selected index
      onTap: onTapped,
      type: BottomNavigationBarType.fixed,
      // selectedItemColor: Colors.blue,
      // unselectedItemColor: Colors.black,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      selectedFontSize: 0,
      unselectedFontSize: 0,
      iconSize: 40,
      elevation: 0, // Update the index on tap
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: index == 0
              ? Image.asset('img/home2.png')
              : Image.asset('img/home1.png'),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: index == 1
              ? Image.asset('img/search2.png')
              : Image.asset('img/search1.png'),
          label: 'Search',
        ),
        BottomNavigationBarItem(
          icon: index == 2
              ? Image.asset('img/message2.png')
              : Image.asset('img/message1.png'),
          label: 'Message',
        ),
        BottomNavigationBarItem(
          icon: index == 3
              ? Image.asset('img/user2.png')
              : Image.asset('img/user1.png'),
          label: 'Profile',
        ),
      ],
    );
  }
}
