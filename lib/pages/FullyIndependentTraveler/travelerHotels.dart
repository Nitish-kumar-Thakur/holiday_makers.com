import 'package:flutter/material.dart';
import 'package:holdidaymakers/widgets/appLargetext.dart';
import 'package:holdidaymakers/widgets/appText.dart';

class Travelerhotels extends StatefulWidget {
  const Travelerhotels({super.key});

  @override
  State<Travelerhotels> createState() => _TravelerhotelsState();
}

class _TravelerhotelsState extends State<Travelerhotels> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
        children: [
          Container(height: 276, width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('img/hotel1.png'),fit: BoxFit.cover)),
              child: Padding(padding: EdgeInsets.only(top: 30),
              child: Column( crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  
                  IconButton(
                  icon: Icon(Icons.arrow_back,color: Colors.white,),
                  onPressed: () {
                    Navigator.pop(context); // Navigates back
                  },
                ),Padding(padding: EdgeInsets.all(20),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppLargeText(text: 'Grand Inn Baku',color: Colors.white,),
                    Row(children: [Icon(Icons.location_on, color: Colors.white, size: 30,),
                    AppText(text: 'Baku, Azerbaijan',color: Colors.white, size: 20,)],)
                  ],
                ),)
                

                ],
              ),
              )
              ),
              SizedBox(height: 20,),
              Container(width: double.infinity, decoration: BoxDecoration( color:Colors.grey.shade200),
              child: Padding(padding: EdgeInsets.all(15),
              child: Column( crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppLargeText(text: 'INCLUSION',size: 25,),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                    IconButton(onPressed: null, icon: Container(width: 71, height: 61,
                    decoration: BoxDecoration(color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      children: [ 
                        Container( height: 40,
                          decoration: BoxDecoration(
                          image: DecorationImage(image: AssetImage('img/flight.png'),
                           )
                        ),),
                  
                        AppLargeText(text: 'Flights',size: 12,)
                      ],
                    ),)),
                    IconButton(onPressed: null, icon: Container(width: 71, height: 61,
                    decoration: BoxDecoration(color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      children: [ 
                        Container( height: 40,
                          decoration: BoxDecoration(
                          image: DecorationImage(image: AssetImage('img/hotels.png'),
                           )
                        ),),
                  
                        AppLargeText(text: 'Hotels', size: 12,)
                      ],
                    ),)),
                    IconButton(onPressed: null, icon: Container(width: 71, height: 61,
                    decoration: BoxDecoration(color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      children: [ 
                        Container( height: 40,
                          decoration: BoxDecoration(
                          image: DecorationImage(image: AssetImage('img/transfers.png'),
                           )
                        ),),
                        AppLargeText(text: 'transfers', size: 12,)
                      ],
                    ),)),
                    IconButton(onPressed: null, icon: Container(width: 71, height: 61,
                    decoration: BoxDecoration(color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      children: [ 
                        Container( height: 40,
                          decoration: BoxDecoration(
                          image: DecorationImage(image: AssetImage('img/insurance.png'),
                           )
                        ),),
                        AppLargeText(text: 'insurance', size: 12,)
                      ],
                    ),)),  
                  ],),
                  Container(height: 400, width: double.infinity,
                  decoration: BoxDecoration(color: Colors.amber,
                  borderRadius: BorderRadius.circular(30)),
                  child: Column(
                    children: [
                      Container( height: 200,
                        decoration: BoxDecoration( borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30),),
                          image: DecorationImage(image: AssetImage('img/hotel1.png'),
                          fit: BoxFit.cover)
                        ),
                      )
                    ],
                  ),
                  )
                ],
              ),))
        ],
      ),
      )
    );
  }
}