import 'package:flutter/material.dart';
import 'package:holdidaymakers/widgets/ReadMore.dart';


class MakeBlog extends StatefulWidget {
  @override
  _MakeBlogState createState() => _MakeBlogState();
}

class _MakeBlogState extends State<MakeBlog> {
  String activeTab = "Popular"; // Track the currently active tab
  String query = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(200),
          child: AppBar(
            backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        flexibleSpace:Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [Padding(
            padding: const EdgeInsets.only(top: 40, left: 10),
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.arrow_back,
                size: 30,
              ),
            ),
          ),
            // Title Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Blogs",
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.grey,
                ),
              ),
            ),
            // Search Bar and Icon
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  width: 410,
                  height: 50,
                  margin: EdgeInsets.only(top: 30, left: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        spreadRadius: 2,
                        offset: Offset(0, 4),
                      ),
                    ],
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        query = value;
                      });
                    },
                    decoration: InputDecoration(
                      suffixIcon: Icon(Icons.search),
                      hintText: "Search",
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 30),
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 6,
                        spreadRadius: 2,
                        offset: Offset(0, 4),
                      ),
                    ],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Image.asset(
                    'assets/images/heroicons.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),
            // Tabs Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                buildTab("Popular"),
                buildTab("Creative"),
                buildTab("UI/UX Design"),
                buildTab("Product"),
              ],
            ),],
        ) ,
      ))
      ,body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            // Profile Details Section
            _buildProfileDetailsSection(
              'assets/images/useProfile.png',
              "Ram Roy",
              "Nature is a source of endless beauty and inspiration. "
                  "The gentle rustling of leaves, the soft chirping of birds, "
                  "and the vibrant colors of blooming flowers remind us of life’s simplicity.......",
            ),
            _buildProfileDetailsSection(
              'assets/images/useProfile.png',
              "Smith Roy",
              "Nature is a source of endless beauty and inspiration. "
                  "The gentle rustling of leaves, the soft chirping of birds, "
                  "and the vibrant colors of blooming flowers remind us of life’s simplicity.......",
            ),
            _buildProfileDetailsSection(
              'assets/images/useProfile.png',
              "Smith Roy",
              "Nature is a source of endless beauty and inspiration. "
                  "The gentle rustling of leaves, the soft chirping of birds, "
                  "and the vibrant colors of blooming flowers remind us of life’s simplicity.......",
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTab(String title) {
    return InkWell(
      onTap: () {
        setState(() {
          activeTab = title; // Set the active tab
        });
        print("$title clicked");
      },
      child: Text(
        title,
        style: TextStyle(
          fontSize: 20,
          color: activeTab == title ? Colors.black : Colors.grey[400],
          decoration:
          activeTab == title ? TextDecoration.underline : TextDecoration.none,
        ),
      ),
    );
  }

  Widget _buildProfileDetailsSection(String profileImagePath, String title, String content) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            spreadRadius: 2,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  ClipOval(
                    child: Image.asset(
                      profileImagePath,
                      height: 60,
                      width: 60,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 20,),
                  Icon(Icons.verified_outlined)
                ],
              ),
              Text(
                "2 hr ago",
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
          SizedBox(height: 10),
          Text(
            "Make design system people want to use.",
            style: TextStyle(fontSize: 25, color: Colors.grey[900],
                fontWeight: FontWeight.w800),
          ),
          SizedBox(height: 10),
          Text(
            content,
            style: TextStyle(fontSize: 16, color: Colors.grey[700]),
          ),

          SizedBox(height: 10),
          ElevatedButton(onPressed: (){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ReadMore()),
            );
          },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15), // Adjust the radius as needed
                ),
              ),
              child: Text("Read more",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: 25
          ),))
        ],
      ),
    );
  }
}
