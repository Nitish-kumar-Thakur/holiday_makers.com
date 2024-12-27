import 'package:flutter/material.dart';

class Learn extends StatefulWidget {
  const Learn({super.key});

  @override
  State<Learn> createState() => _LearnState();
}

class _LearnState extends State<Learn> {
  int currentPage = 0; // Track current page index
  int _selectedIndex = 0; // Track selected bottom nav item index

  // Function to switch between pages based on the selected index
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  
  late PageController controller;
  @override
  void initState() {
    controller = PageController(
      viewportFraction: 0.40,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
              height: 200,
              child: PageView.builder(
                  itemCount: 8,
                  controller: controller,
                  itemBuilder: (_, index) {
                    return Align(
                      alignment: Alignment.centerLeft,
                      child: 
                      AnimatedBuilder(
                    animation: controller,
                    builder: (context, child) {
                      return child!;
                    },child: Container(
            height: 200, width: 200,
            margin: EdgeInsets.only(top: 30,left: 10,right: 20,bottom: 10),
                decoration: BoxDecoration(
                
                image: DecorationImage(image: AssetImage('img/recomended.png'))),
          ),)
                    );
                  }))
        ],
      ),
      

          bottomNavigationBar: BottomAppBar(
  elevation: 0, // Removes shadow
  color: Colors.white, // Background color
  child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceAround, // Space items evenly
    children: [
      Row( mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
         icon:_selectedIndex==2? Image.asset('img/home1.png',height: 25,width: 25):
        Image.asset('img/home.png', height: 25,width: 25,),
        onPressed: () => _onItemTapped(0),
      ),
      SizedBox(width: 20,),
      IconButton(
        icon: _selectedIndex==1? Image.asset('img/search1.png', height: 25,width: 25,):
         Image.asset('img/search.png', height: 25,width: 25,),
        onPressed: () => _onItemTapped(1),
      ),  
        ],
      ),
      Row( mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
        icon:_selectedIndex==2? Image.asset('img/message1.png',height: 25,width: 25):
        Image.asset('img/message.png', height: 25,width: 25,),
        onPressed: () => _onItemTapped(2),
      ),
      SizedBox(width: 20,),
      IconButton(
        icon:_selectedIndex==2? Image.asset('img/user1.png',height: 25,width: 25):
        Image.asset('img/user.png', height: 25,width: 25,),
        onPressed: () => _onItemTapped(3),
      ),
          
        ],
      )
    ],
  ),
),
    );
  }
}
