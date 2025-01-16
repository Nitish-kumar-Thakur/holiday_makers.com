import 'package:flutter/material.dart';
import 'package:holdidaymakers/pages/Cruise/CurisesHome.dart';
import 'package:holdidaymakers/pages/FixedDeparturesPages/departuresHome.dart';
import 'package:holdidaymakers/pages/FullyIndependentTraveler/mainPage.dart';
import 'package:holdidaymakers/widgets/ChangePassword.dart';
import 'package:holdidaymakers/widgets/ManageAccount.dart';
import 'package:holdidaymakers/widgets/appLargetext.dart';
import 'package:holdidaymakers/widgets/appText.dart';
import 'package:holdidaymakers/widgets/profile_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Drawerpage2 extends StatefulWidget {
  Drawerpage2({super.key});

  @override
  State<Drawerpage2> createState() => _Drawerpage2State();
}

class _Drawerpage2State extends State<Drawerpage2> {
  String profileImg = "";
  String firstName = "";
  List<Map<String, String>> data = [
    {
      "title": "Deals",
      "img1": "img/traveler.png",
      "img2": "img/cruise.png",
      "text1": "Fully Independent Traveler",
      "text2": "Fixed Departures",
      "text3": "Cruise",
    },
    {
      "title": "My Trip",
      "img1": "img/booking.png",
      "img2": "img/Wallet.png",
      "text1": "My Booking",
      "text2": "Wallet",
    },
    {
      "title": "About",
      "img1": "img/article.png",
      "img2": "img/helpCenter.png",
      "img3": "img/signOut.png",
      "text1": "Article & Blogs",
      "text2": "Help Center",
      "text3": "Sign Out",
    }
  ];

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
              color: Colors.black.withOpacity(0.2), // Inner shadow color
              offset: Offset(0, 4), // x = 0, y = 4
              blurRadius: 4, // Blur = 4
              spreadRadius: 0, // Spread = 0
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
                      Color(0xFF308BDC), // Hex color #308BDC
                      Color(0xFF0B70B4), // Hex color #0B70B4
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
                      color:
                          Colors.black.withOpacity(0.2), // Inner shadow color
                      offset: Offset(0, 4), // x = 0, y = 4
                      blurRadius: 4, // Blur = 4
                      spreadRadius: 0, // Spread = 0
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.only(left: 15),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(
                            profileImg), // Placeholder image
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      AppLargeText(
                        text: firstName,
                        color: Colors.white,
                        size: 24,
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: EdgeInsets.only(left: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProfilePage()));
                      },
                      icon: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SmalCircle(
                            image: 'img/Profile.png',
                          ),
                          AppLargeText(
                            text: 'My Profile',
                            size: 10,
                            color: Colors.white,
                          )
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ManageAccount()));
                      },
                      icon: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SmalCircle(
                            image: 'img/manageAccount.png',
                          ),
                          AppLargeText(
                            text: 'Manage Account',
                            size: 10,
                            color: Colors.white,
                          )
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ChangePasswordScreen()));
                      },
                      icon: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SmalCircle(
                            image: 'img/changePassword.png',
                          ),
                          AppLargeText(
                            text: 'Change Password',
                            size: 10,
                            color: Colors.white,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Divider(
                color: Colors.white,
              ),
              Padding(
                padding: EdgeInsets.only(left: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppLargeText(
                      text: "Deals",
                      size: 24,
                      color: Colors.white,
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Mainpage()));
                      },
                      child: ChildContainer(
                        image: "img/traveler.png",
                        text: "Fully Independent Traveler",
                      ),
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DeparturesHome()));
                      },
                      child: ChildContainer(
                          image: "img/traveler.png", text: 'Fixed Departures'),
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CurisesHome()));
                      },
                      child: ChildContainer(
                          image: "img/cruise.png", text: "Cruise"),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Divider(
                color: Colors.white,
              ),
              Padding(
                padding: EdgeInsets.only(left: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppLargeText(
                      text: "My Trip",
                      size: 24,
                      color: Colors.white,
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    ChildContainer(
                      image: "img/booking.png",
                      text: "My Booking",
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    ChildContainer(image: "img/Wallet.png", text: 'Wallet'),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Divider(color: Colors.white),
              Padding(
                padding: EdgeInsets.only(left: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppLargeText(
                      text: "About",
                      size: 24,
                      color: Colors.white,
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    ChildContainer(
                      image: "img/article.png",
                      text: "Article & Blogs",
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    ChildContainer(
                        image: "img/helpCenter.png", text: 'Help Center'),
                    SizedBox(
                      height: 3,
                    ),
                    ChildContainer(image: "img/signOut.png", text: "Sign Out"),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ChildContainer extends StatelessWidget {
  final String image;
  final String text;
  const ChildContainer({super.key, required this.image, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 20,
          width: 20,
          decoration: BoxDecoration(
              image: DecorationImage(
            image: AssetImage(
              image,
            ),
          )),
        ),
        SizedBox(
          width: 5,
        ),
        AppText(
          text: text,
          color: Colors.white,
          size: 14,
        )
      ],
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
