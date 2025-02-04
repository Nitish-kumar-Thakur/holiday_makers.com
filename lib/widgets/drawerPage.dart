import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:holdidaymakers/widgets/help_center_page.dart';
import 'package:holdidaymakers/pages/Cruise/CurisesHome.dart';
import 'package:holdidaymakers/pages/Cruise/CurisesHome1.dart';
import 'package:holdidaymakers/pages/FixedDeparturesPages/departuresHome.dart';
import 'package:holdidaymakers/pages/FixedDeparturesPages/departuresHome1.dart';
import 'package:holdidaymakers/pages/FullyIndependentTraveler/mainPage.dart';
import 'package:holdidaymakers/pages/introPage.dart';
import 'package:holdidaymakers/widgets/terms_and_conditions_page.dart';
import 'package:holdidaymakers/widgets/terms_and_conditions_page1.dart';
import 'package:holdidaymakers/widgets/testimonials_page.dart';
import 'package:holdidaymakers/utils/shared_preferences_handler.dart';
import 'package:holdidaymakers/widgets/ChangePassword.dart';
import 'package:holdidaymakers/widgets/ManageAccount.dart';
import 'package:holdidaymakers/widgets/appLargetext.dart';
import 'package:holdidaymakers/widgets/appText.dart';
import 'package:holdidaymakers/widgets/profile_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Drawerpage extends StatefulWidget {
  Drawerpage({super.key});

  @override
  State<Drawerpage> createState() => _DrawerpageState();
}

class _DrawerpageState extends State<Drawerpage> {
  String profileImg = "";
  String firstName = "";

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
      firstName = firstName.isNotEmpty ? firstName[0].toUpperCase() + firstName.substring(1) : firstName;
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
              onPressed: () {
                // Perform sign-out logic here
                Navigator.of(context).pop();
                SharedPreferencesHandler.signOut(); // Close the dialog
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => IntroPage())); // Redirect to login screen or relevant page
              },
              child: Text("Yes"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF0B77BF), // Hex color #0B77BF
              Color(0xFF0A64A0), // Hex color #0A64A0
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              offset: Offset(0, 4),
              blurRadius: 4,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.only(top: 40, left: 0, right: 15),
          child: Column(
            children: [
              Container(
                height: 80,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF308BDC),
                      Color(0xFF0B70B4),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      offset: Offset(0, 4),
                      blurRadius: 4,
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.only(left: 15),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(profileImg),
                      ),
                      SizedBox(width: 10),
                      AppLargeText(
                        text: firstName,
                        color: Colors.white,
                        size: 24,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.only(left: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ProfilePage()),
                        );
                      },
                      icon: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(FontAwesomeIcons.user,  color: Colors.white, size: 27,),
                          SizedBox(height: 8,),
                          AppLargeText(
                            text: 'My Profile',
                            size: 10,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ManageAccount()),
                        );
                      },
                      icon: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(FontAwesomeIcons.userPen , color: Colors.white, size: 27,),
                          SizedBox(height: 8,),
                          AppLargeText(
                            text: 'Manage Account',
                            size: 10,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ChangePasswordScreen()),
                        );
                      },
                      icon: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(FontAwesomeIcons.unlock, color: Colors.white, size: 27,),
                          SizedBox(height: 8,),
                          AppLargeText(
                            text: 'Change Password',
                            size: 10,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              // Divider(color: Colors.white),
              // Padding(
              //   padding: EdgeInsets.only(left: 15),
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       AppLargeText(text: "Deals", size: 24, color: Colors.white),
              //       SizedBox(height: 3),
              //       GestureDetector(
              //         onTap: () {
              //           Navigator.push(
              //             context,
              //             MaterialPageRoute(builder: (context) => Mainpage()),
              //           );
              //         },
              //         child: ChildContainer(image: "img/traveler.png", text: "Fully Independent Traveler"),
              //       ),
              //       SizedBox(height: 3),
              //       GestureDetector(
              //         onTap: () {
              //           Navigator.push(
              //             context,
              //             MaterialPageRoute(builder: (context) => DeparturesHome()),
              //           );
              //         },
              //         child: ChildContainer(image: "img/traveler.png", text: 'Fixed Departures'),
              //       ),
              //       SizedBox(height: 3),
              //       GestureDetector(
              //         onTap: () {
              //           Navigator.push(
              //             context,
              //             MaterialPageRoute(builder: (context) => CurisesHome()),
              //           );
              //         },
              //         child: ChildContainer(image: "img/cruise.png", text: "Cruise"),
              //       ),
              //     ],
              //   ),
              // ),
              // SizedBox(height: 20),
              Divider(color: Colors.white),
              Padding(
                padding: EdgeInsets.only(left: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppLargeText(text: "My Trip", size: 24, color: Colors.white),
                    SizedBox(height: 3),
                    ChildContainer(icon: FontAwesomeIcons.newspaper, text: "My Booking"),
                    SizedBox(height: 3),
                    ChildContainer(icon: FontAwesomeIcons.wallet, text: 'Wallet'),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Divider(color: Colors.white),
              Padding(
                padding: EdgeInsets.only(left: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppLargeText(text: "About", size: 24, color: Colors.white),
                    SizedBox(height: 3),
                    ChildContainer(icon: FontAwesomeIcons.filePen, text: "Blogs",
                    onTap: (){}),
                    SizedBox(height: 3),
                    ChildContainer(icon: FontAwesomeIcons.users,text: "Testimonials", onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => TestimonialsPage()),
                        );
                    },),
                    SizedBox(height: 3),
                    ChildContainer(icon: FontAwesomeIcons.buildingUser, text: "Company Profile"),
                    SizedBox(height: 3),
                    ChildContainer(icon: FontAwesomeIcons.fileLines, text: "Terms & Conditions", onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => TermsAndConditionsPage()),
                        );
                    },),
                    SizedBox( height: 3),
                    ChildContainer(icon: FontAwesomeIcons.computer, text: "Help Center", onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => HelpCenterPage()),
                        );
                    },),
                    SizedBox(height: 3),
                    ChildContainer(icon: FontAwesomeIcons.signOut, text: "Sign Out",
                      onTap: () => _showSignOutDialog(context)
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ChildContainer extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback? onTap;

  const ChildContainer({super.key, required this.icon, required this.text, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 15,),
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
