import 'package:flutter/material.dart';
import 'package:holdidaymakers/pages/FullyIndependentTraveler/travelerHotels.dart';
import 'package:holdidaymakers/widgets/appLargetext.dart';
import 'package:holdidaymakers/widgets/calendarWidget.dart';
import 'package:holdidaymakers/widgets/drawerPage.dart';
import 'package:holdidaymakers/widgets/dropdownWidget.dart';
import 'package:holdidaymakers/widgets/responciveButton.dart';
import 'package:holdidaymakers/widgets/travelerDrawer.dart';

class Independenttravelerpage extends StatefulWidget {
  const Independenttravelerpage({super.key});

  @override
  State<Independenttravelerpage> createState() =>
      _IndependenttravelerpageState();
}

class _IndependenttravelerpageState extends State<Independenttravelerpage> {
  final List<String> items = ['Option 1', 'Option 2', 'Option 3', 'Option 4'];
  String? selectedItem;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String dropdownValue = '1 night';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white,
        leading: IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () {
                    Navigator.pop(context); // Navigates back
                  },
                ),),
      key: _scaffoldKey,
      drawer: Drawerpage(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Page Title
                AppLargeText(
                  text: 'Fully Independent Traveler',
                  size: 24,
                  color: Colors.black,
                ),
                const SizedBox(height: 20),
                // Placeholder Box
                Dropdownwidget(
                  text: 'SELECT SOURCE',
                ),
                const SizedBox(height: 20),
                Dropdownwidget(
                  text: 'SELECT DESTINATION',
                ),
                const SizedBox(height: 20),
                Container(
                  height: 58,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(20)),
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Icon(
                          Icons.calendar_month,
                          size: 24,
                        ),
                        Column(
                          children: [
                            AppLargeText(
                              text: 'TRAVEL DATE',
                              color: Colors.black,
                              size: 14,
                            ),
                            Calendarwidget()
                          ],
                        ),
                        Container(
                          height: 25,
                          width: 80,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(width: 1, color: Colors.grey)),
                          child: DropdownButton<String>(
                            value: dropdownValue,
                            items: ['1 night', '2 night', '3 night', '4 night']
                                .map((String item) {
                              return DropdownMenuItem<String>(
                                value: item,
                                child: Center(child: Text(item)),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                dropdownValue = newValue!;
                              });
                            },
                            icon: SizedBox.shrink(),
                            isExpanded: true,
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        Calendarwidget()
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Travelerdrawer(),
                const SizedBox(height: 30),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Travelerhotels()));
                  },
                  child: responciveButton(text: 'SEARCH'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
  }
