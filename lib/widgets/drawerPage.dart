import 'package:flutter/material.dart';
import 'package:holdidaymakers/widgets/appLargetext.dart';
import 'package:holdidaymakers/widgets/appText.dart';

class Drawerpage extends StatelessWidget {
  Drawerpage({super.key});
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
  Widget build(BuildContext context) {
    return Drawer(
        backgroundColor: Colors.white,
        child: Padding(
          padding: EdgeInsets.only(top: 40, left: 15, right: 15),
          child: Column(
            children: [
              Container(
                height: 110,
                decoration: BoxDecoration(
                    color: Colors.lightBlueAccent,
                    borderRadius: BorderRadius.circular(20)),
                child: Row(
                  children: [
                    Container(
                      height: 85,
                      width: 85,
                      margin: EdgeInsets.only(left: 10, right: 10),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              offset: Offset(
                                  4, 4), // Shadow offset (horizontal, vertical)
                              blurRadius:
                                  6, // Blur radius to create a soft shadow
                              spreadRadius: 2,
                            )
                          ]),
                    ),
                    AppLargeText(
                      text: 'Emul',
                      color: Colors.white,
                      size: 27,
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                height: 100,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.grey.shade300, width: 1)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SmalCircle(
                          image: 'img/Profile.png',
                        ),
                        AppLargeText(
                          text: 'My Profile',
                          size: 10,
                        )
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SmalCircle(
                          image: 'img/manageAccount.png',
                        ),
                        AppLargeText(
                          text: 'Manage Account',
                          size: 10,
                        )
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SmalCircle(
                          image: 'img/changePassword.png',
                        ),
                        AppLargeText(
                          text: 'Change Password',
                          size: 10,
                        )
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
        height: 120,
        // width: 285,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey.shade300, width: 1)),
        child: Padding(
          padding: EdgeInsets.only(left: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppLargeText(
                text: "Deals",
                size: 20,
              ),
              SizedBox(
                height: 3,
              ),
              ChildContainer(image: "img/traveler.png", text: "Fully Independent Traveler",),
              SizedBox(
                height: 3,
              ),
              ChildContainer(image: "img/traveler.png", text: 'Fixed Departures'),
              SizedBox(
                height: 3,
              ),
              ChildContainer(image: "img/cruise.png", text: "Cruise"),
            ],
          ),
        )),
        SizedBox(
                height: 20,
              ),
        Container(
        height: 100,
        // width: 285,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey.shade300, width: 1)),
        child: Padding(
          padding: EdgeInsets.only(left: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppLargeText(
                text: "My Trip",
                size: 20,
              ),
              SizedBox(
                height: 3,
              ),
              ChildContainer(image: "img/booking.png", text: "My Booking",),
              SizedBox(
                height: 3,
              ),
              ChildContainer(image: "img/Wallet.png", text: 'Wallet'),
            ],
          ),
        )),
        SizedBox(
                height: 20,
              ),
        Container(
        height: 120,
        // width: 285,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey.shade300, width: 1)),
        child: Padding(
          padding: EdgeInsets.only(left: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppLargeText(
                text: "About",
                size: 20,
              ),
              SizedBox(
                height: 3,
              ),
              ChildContainer(image: "img/article.png", text: "Article & Blogs",),
              SizedBox(
                height: 3,
              ),
              ChildContainer(image: "img/helpCenter.png", text: 'Help Center'),
              SizedBox(
                height: 3,
              ),
              ChildContainer(image: "img/signOut.png", text: "Sign Out"),
            ],
          ),
        ))
            ],
          ),
        ));
  }
}
class ChildContainer extends StatelessWidget {
  final String image;
  final String text;
  const ChildContainer({
    super.key,
    required this.image,
    required this.text
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(height: 20, width: 20,
        decoration: BoxDecoration(image: DecorationImage(image: AssetImage(image,),)),)
        ,
        SizedBox(
          width: 5,
        ),
        AppText(
          text: text,
          color: Colors.black,
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
      height: 60,
      width: 60,
      decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black12, // Shadow offset (horizontal, vertical)
              blurRadius: 4, // Blur radius to create a soft shadow
              spreadRadius: 2,
            )
          ]),
      child: Image.asset(image),
    );
  }
}
