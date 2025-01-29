import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// First Container (Fixed width)
            Container(
              width: 750,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Header with Search Bar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Home",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey),
                      ),
                      Container(
                        width: 260,
                        height: 30,
                        decoration: BoxDecoration(
                          color: Colors.purple,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: TextField(
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: "Search",
                            hintStyle: TextStyle(color: Colors.white54),
                            border: InputBorder.none,
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 10),
                            suffixIcon: Container(
                              height: double.infinity,
                              width: 40,
                              child: Align(
                                alignment: Alignment.center,
                                child: IconButton(
                                  icon: Icon(Icons.search, color: Colors.white),
                                  onPressed: () {},
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),

                  /// Featured Project Section
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.purple, Colors.blue],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("ETHEREUM 2.0",
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.white70)),
                              Text(
                                "Trending project and high rating project created by team.",
                                style: TextStyle(color: Colors.white),
                              ),
                              SizedBox(height: 10),
                              ElevatedButton(
                                  onPressed: () {}, child: Text("Learn More"))
                            ],
                          ),
                        ),
                        Image.asset("assets/illustration.png", width: 150),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),

                  /// Projects & Creators Section
                  Row(
                    children: [
                      /// All Projects Section
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("All Projects",
                                style: TextStyle(
                                    fontSize: 20, color: Colors.black)),
                            SizedBox(height: 10),
                            Container(
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.blueGrey,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                children: [
                                  projectTile(
                                      "Technology behind the Blockchain",
                                      "Project #1"),
                                  projectTile(
                                      "Technology behind the Blockchain",
                                      "Project #2"),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 20),

                      /// Top Creators Section
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Top Creators",
                                style: TextStyle(
                                    fontSize: 20, color: Colors.black)),
                            SizedBox(height: 10),
                            Container(
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.blueGrey,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                children: [
                                  creatorTile("@maddison_c21", 9821),
                                  creatorTile("@karl_wil02", 7032),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(width: 20),

            /// Second Container (Expanded to take extra width)
            Expanded(
              child: Container(
                height: MediaQuery.of(context).size.height,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          
                          children: [
                            Padding(padding: EdgeInsets.all(5),
                            child: Icon(Icons.card_travel,),),
                            Padding(padding: EdgeInsets.all(5),
                            child: Icon(Icons.card_travel,),),
                            Padding(padding: EdgeInsets.all(5),
                            child: Icon(Icons.card_travel,),),
                          ],
                        ),
                        Padding(padding: EdgeInsets.only(right: 30),
                            child: Icon(Icons.abc,),),
                      ],
                    ),
                    SizedBox(height: 8),
                    Expanded(
                        child: Container(
                      decoration: BoxDecoration(color: Colors.black),
                      // child: Column(children: [
                      //   Text("data")
                      // ],),
                    ))
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget projectTile(String title, String projectNumber) {
    return ListTile(
      tileColor: Colors.black26,
      title: Text(title, style: TextStyle(color: Colors.white)),
      subtitle: Text(projectNumber, style: TextStyle(color: Colors.white70)),
      trailing: Icon(Icons.arrow_forward_ios, color: Colors.white),
    );
  }

  Widget creatorTile(String name, int rating) {
    return ListTile(
      tileColor: Colors.black26,
      title: Text(name, style: TextStyle(color: Colors.white)),
      trailing: Text(rating.toString(), style: TextStyle(color: Colors.white)),
    );
  }
}
