import 'package:flutter/material.dart';
import 'package:holdidaymakers/pages/FixedDeparturesPages/hotelsAccommodation.dart';
import 'package:holdidaymakers/widgets/appLargetext.dart';
import 'package:holdidaymakers/widgets/appText.dart';
import 'package:holdidaymakers/widgets/responciveButton.dart';
import 'package:holdidaymakers/widgets/travelerDrawer.dart';
import 'package:intl/intl.dart'; // For date formatting

class DepartureDeals extends StatefulWidget {
  const DepartureDeals({super.key});

  @override
  _DepartureDealsState createState() => _DepartureDealsState();
}

class _DepartureDealsState extends State<DepartureDeals> {
  DateTime? selectedDate; // For storing the selected date
  int selectedOption = 0; // To track the selected cruise option

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }
  Widget buildInclusionCard(String imagePath, String label) {
    return Container(
      width: 71,
      height: 61,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 40,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(imagePath),
              ),
            ),
          ),
          const SizedBox(height: 4),
          AppText(
            text: label,
            size: 12,
            color: Colors.black,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {Navigator.pop(context);},
        ),
        
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Fixed Departures',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 20),
              // Select Date Section
              GestureDetector(
                onTap: () => _selectDate(context),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey[200],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.calendar_today_outlined,
                              color: Colors.black54),
                          SizedBox(width: 8),
                          Text(
                            selectedDate != null
                                ? DateFormat('dd MMM yyyy').format(selectedDate!)
                                : 'SELECT DATE',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      Icon(Icons.arrow_drop_down, color: Colors.black54),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),
              // Cruise Options Section
              CruiseOption(
                title: 'SIR BANIYAS : HIT CRUISE',
                checkIn: '07 Dec 24, Sat',
                checkOut: '09 Dec 24, Mon',
                duration: '3 Night / 4 Days',
                price: 'AED 2,377',
                isSelected: selectedOption == 0,
                onSelect: () {
                  setState(() {
                    selectedOption = 0;
                  });
                },
              ),
              SizedBox(height: 24),
              // Inclusion Section
              SizedBox(height: 12),
              Container(
                width: double.infinity,
              decoration: BoxDecoration(color: Colors.grey.shade200),
              padding: const EdgeInsets.all(10),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppLargeText(
                      text: 'INCLUSION',
                      size: 25,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        buildInclusionCard('img/flight.png', 'Flights'),
                        buildInclusionCard('img/hotels.png', 'Hotels'),
                        buildInclusionCard('img/transfers.png', 'Transfers'),
                        buildInclusionCard('img/insurance.png', 'Insurance'),
                      ],
                    ),
                ],
              ),
              ),
              SizedBox(height: 24),
              Text(
                'Fixed Departures',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 10),
              Travelerdrawer(),
              SizedBox(height: 30),
              Align(alignment: Alignment.center, 
              child: IconButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => HotelsAccommodation()));
              }, icon: responciveButton(text: 'SELECT')),)
              
              // Hotel Card Section

            ],
          ),
        ),
      ),
    );
  }
}

class CruiseOption extends StatelessWidget {
  final String title;
  final String checkIn;
  final String checkOut;
  final String duration;
  final String price;
  final bool isSelected;
  final VoidCallback onSelect;

  CruiseOption({
    required this.title,
    required this.checkIn,
    required this.checkOut,
    required this.duration,
    required this.price,
    required this.isSelected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSelect,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[200]!,
          borderRadius: BorderRadius.circular(8),
          border:
              Border.all(color: isSelected ? Colors.yellow : Colors.grey[300]!),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      price,
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(width: 8),
                    Container(
                      height: 10,
                      width: 10,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isSelected ? Colors.yellow : Colors.transparent,
                        border: Border.all(color: Colors.yellow),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  checkIn,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
                Text(
                  duration,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
                Text(
                  checkOut,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class InclusionIcons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final inclusions = [
      {'icon': Icons.bed, 'label': 'Accomodation'},
      {'icon': Icons.restaurant, 'label': 'Meals'},
      {'icon': Icons.theaters, 'label': 'Theater'},
      {'icon': Icons.child_care, 'label': 'Kids Club'},
      {'icon': Icons.pool, 'label': 'Pool'},
      {'icon': Icons.tv, 'label': 'Entertainment'},
    ];

    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              'INCLUSION',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 10),
          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 1.2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: inclusions.length,
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 3,
                      offset: Offset(1, 1),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      inclusions[index]['icon'] as IconData,
                      size: 40,
                      color: Colors.black,
                    ),
                    SizedBox(height: 4),
                    Text(
                      inclusions[index]['label'] as String,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class HotelCard extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String type;
  final double rating;
  final String price;

  HotelCard({
    required this.imageUrl,
    required this.name,
    required this.type,
    required this.rating,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            ),
            child: Image.asset(
              imageUrl,
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      type,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.amber, size: 14),
                        SizedBox(width: 4),
                        Text(
                          rating.toString(),
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(
                      price,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
