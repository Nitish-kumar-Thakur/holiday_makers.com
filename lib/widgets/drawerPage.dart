import 'package:HolidayMakers/pages/homePages/mainPage.dart';
import 'package:HolidayMakers/pages/login&signup/Test.dart';
import 'package:HolidayMakers/widgets/Blogs.dart';
import 'package:HolidayMakers/widgets/MyBookings.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:HolidayMakers/widgets/help_center_page.dart';
import 'package:HolidayMakers/widgets/terms_and_conditions_page.dart';
import 'package:HolidayMakers/widgets/testimonials_page.dart';
import 'package:HolidayMakers/utils/shared_preferences_handler.dart';
import 'package:HolidayMakers/widgets/ChangePasswordScreen.dart';
import 'package:HolidayMakers/widgets/ManageAccount.dart';
import 'package:HolidayMakers/widgets/appLargetext.dart';
import 'package:HolidayMakers/widgets/appText.dart';
import 'package:HolidayMakers/widgets/profile_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Drawerpage extends StatefulWidget {
  const Drawerpage({super.key});

  @override
  State<Drawerpage> createState() => _DrawerpageState();
}

class _DrawerpageState extends State<Drawerpage> {
  String profileImg = "";
  String firstName = "";
  bool isProfileEmpty = false;

  @override
  void initState() {
    super.initState();
    _loadProfileDetails();
  }

  Future<void> _loadProfileDetails() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      profileImg = prefs.getString("profileImg") ?? "";
      firstName = prefs.getString("first_name") ?? "";
      firstName = firstName.isNotEmpty
          ? firstName[0].toUpperCase() + firstName.substring(1)
          : firstName;
      isProfileEmpty = firstName.trim().isEmpty;
    });
  }

  void _showSignOutDialog(BuildContext context) { 
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          "Sign Out",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text("Are you sure you want to sign out?"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop(); // Close the dialog

              await SharedPreferencesHandler.signOut(); // Clear stored user data

              // Navigate to Mainpage and clear all previous routes
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => Mainpage()), 
                (Route<dynamic> route) => false, // Remove all previous screens
              );
            },
            child: Text("Yes"),
          ),
        ],
      );
    },
  );
}

void _showLoginDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          "Login",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text("You need to log in to access your account."),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog

              // Navigate to the login screen
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => LoginPage())); // Replace with Login page
            },
            child: Text("Login"),
          ),
        ],
      );
    },
  );
}


  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Drawer(
      child: Container(
        color: Colors.white, // Background color
        child: Padding(
          padding: EdgeInsets.only(top: screenWidth * 0.1, left: 0, right: screenWidth * 0.04), // Dynamic top padding and right padding
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // Align items to the left
            children: [
              // Profile Header
              Container(
                height: screenWidth * 0.2, // Height based on screen width
                decoration: BoxDecoration(
                  color: Colors.grey.shade300, // Background of the whole list container
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(screenWidth * 0.05),
                    bottomRight: Radius.circular(screenWidth * 0.05),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.only(left: screenWidth * 0.04),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: screenWidth * 0.07, // Dynamic circle avatar size
                        backgroundImage: profileImg.trim().isNotEmpty
                            ? NetworkImage(profileImg)
                            : AssetImage("img/placeholder.png"),
                      ),
                      SizedBox(width: screenWidth * 0.03),
                      AppLargeText(
                        text: firstName.trim().isEmpty ? "Hi, There" : firstName,
                        color: Colors.black, // Text color changed to black
                        size: screenWidth * 0.06, // Dynamic text size
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: screenWidth * 0.02),

              // Quick Actions Section
              Container(
                padding: EdgeInsets.symmetric(vertical: screenWidth * 0.03),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _iconButton(FontAwesomeIcons.user, "My Profile",
                            () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => firstName.trim().isEmpty
                                  ? LoginPage()
                                  : ProfilePage()),
                        ),
                        textColor: Colors.blue),
                    _iconButton(FontAwesomeIcons.userPen, "Manage Account",
                            () => Navigator.push(context,
                            MaterialPageRoute(builder: (context) => ManageAccount())),
                        textColor: Colors.blue),
                    _iconButton(FontAwesomeIcons.unlock, "Change Password",
                            () => Navigator.push(context,
                            MaterialPageRoute(builder: (context) => ChangePasswordScreen())),
                        textColor: Colors.blue),
                  ],
                ),
              ),

              SizedBox(height: screenWidth * 0.01),

              // My Trip Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: AppLargeText(
                  text: 'My Trips',
                  size: screenWidth * 0.06,
                  color: Colors.blue, // Text color changed to blue
                ),
              ),
              Center(
                child: Container(
                  width: screenWidth * 0.8, // Responsive width
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100, // Gray background
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(screenWidth * 0.05),
                      bottomRight: Radius.circular(screenWidth * 0.05),
                    ),
                  ),
                  padding: EdgeInsets.symmetric(vertical: screenWidth * 0.02),
                  child: Column(
                    children: [
                      _listItem(FontAwesomeIcons.newspaper, "My Booking",
                              () => Navigator.push(context,
                              MaterialPageRoute(builder: (context) => firstName.trim().isEmpty
                                  ? LoginPage():MyBookings()))),
                      _listItem(FontAwesomeIcons.wallet, "Wallet", () {}),
                    ],
                  ),
                ),
              ),

              SizedBox(height: screenWidth * 0.02),

              // About Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: AppLargeText(
                  text: 'About',
                  size: screenWidth * 0.06,
                  color: Colors.blue, // Text color changed to blue
                ),
              ),
              Center(
                child: Container(
                  width: screenWidth * 0.85, // Responsive width
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100, // Gray background
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(screenWidth * 0.05),
                      bottomRight: Radius.circular(screenWidth * 0.05),
                    ),
                  ),
                  padding: EdgeInsets.symmetric(vertical: screenWidth * 0.03),
                  child: Column(
                    children: [
                      _listItem(FontAwesomeIcons.filePen, "Blogs", () => Navigator.push(context, MaterialPageRoute(builder: (context) => BlogsPage()))),
                      _listItem(FontAwesomeIcons.users, "Testimonials", () => Navigator.push(context, MaterialPageRoute(builder: (context) => TestimonialsPage()))),
                      _listItem(FontAwesomeIcons.buildingUser, "Company Profile", () {}),
                      _listItem(FontAwesomeIcons.fileLines, "Terms & Conditions", () => Navigator.push(context, MaterialPageRoute(builder: (context) => TermsAndConditionsPage()))),
                      _listItem(FontAwesomeIcons.computer, "Help Center", () => Navigator.push(context, MaterialPageRoute(builder: (context) => HelpCenterPage()))),
                      _listItem(FontAwesomeIcons.signOut, profileImg.trim().isEmpty ? "Log In" : "Sign Out",
                              () => profileImg.trim().isEmpty ? _showLoginDialog(context) : _showSignOutDialog(context)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

// Helper Widget for List Items
  Widget _listItem(IconData icon, String text, VoidCallback onTap) {
    final screenWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: Row(
          children: [
            Icon(icon, color: Colors.black, size: screenWidth * 0.05),
            SizedBox(width: 10),
            AppLargeText(text: text, size: screenWidth * 0.04, color: Colors.black), // Text color changed to black
          ],
        ),
      ),
    );
  }

// Helper Widget for Icon Buttons (For Profile Section)
  Widget _iconButton(IconData icon, String label, VoidCallback onTap, {Color textColor = Colors.black}) {
    return IconButton(
      onPressed: onTap,
      icon: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.black, size: 27), // Icon color changed to black
          SizedBox(height: 8),
          AppLargeText(text: label, size: 10, color: textColor), // Text color is customizable
        ],
      ),
    );
  }

}

class ChildContainer extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback? onTap;

  const ChildContainer(
      {super.key, required this.icon, required this.text, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: 15,
          ),
          SizedBox(width: 7),
          AppText(text: text, color: Colors.white, size: 14),
        ],
      ),
    );
  }
}

class SmalCircle extends StatelessWidget {
  final String image;

  const SmalCircle({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 40,
      child: Image.asset(
        image,
        fit: BoxFit.cover,
      ),
    );
  }
}
