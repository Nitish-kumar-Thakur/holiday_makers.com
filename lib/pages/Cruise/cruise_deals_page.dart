import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:holdidaymakers/pages/Cruise/cruise_deals_page2.dart';
import 'package:holdidaymakers/utils/api_handler.dart';
import 'package:holdidaymakers/widgets/appLargetext.dart';
import 'package:holdidaymakers/widgets/responciveButton.dart';
import 'package:shimmer/shimmer.dart';

class CruiseDealsPage extends StatefulWidget {
  final String packageid;
  const CruiseDealsPage({super.key, required this.packageid});

  @override
  _CruiseDealsPageState createState() => _CruiseDealsPageState();
}

class _CruiseDealsPageState extends State<CruiseDealsPage> {
  bool isLoading = true;
  Map<String, dynamic> packageData = {};
  Map<String, dynamic> cruiseCards = {};
  String cruiseId = "";
  int selectedOption = 0;
  Map<String, dynamic>? selectedCruiseData;

  @override
  void initState() {
    super.initState();
    _fetchPackageDetails();
  }

Future<void> _fetchPackageDetails() async {
  try {
    final response = await APIHandler.getCruiseDeal(widget.packageid);
    setState(() {
      packageData = response;
    });

    if (packageData['cruise_details']?['cruise_id'] != null) {
      cruiseId = packageData['cruise_details']['cruise_id'];
      await _fetchCruiseCards();
    }
  } catch (error) {
    print("Error fetching package details: $error");
    setState(() {
      isLoading = false;
    });
  }
}

Future<void> _fetchCruiseCards() async {
  try {
    final response = await APIHandler.getCruiseCards(cruiseId ?? "");
    setState(() {
      cruiseCards = response;
      if (cruiseCards['data'] != null && cruiseCards['data'].isNotEmpty) {
        selectedCruiseData = cruiseCards['data'][0];
      }
      isLoading = false;
    });
  } catch (error) {
    print("Error fetching cruise cards: $error");
    setState(() {
      isLoading = false;
    });
  }
}


  Widget buildInclusionCard(String iconClass, String label) {
    // Default icon in case no match is found
    IconData icon = FontAwesomeIcons.circleQuestion;

    // Map FontAwesome icon classes to Flutter icon
    if (iconClass == "fa fa-plane") {
      icon = FontAwesomeIcons.plane;
    } else if (iconClass.contains("fa-bed")) {
      icon = FontAwesomeIcons.bed;
    } else if (iconClass.contains("fa-theater")) {
      icon = FontAwesomeIcons.film;
    } else if (iconClass.contains("fa-kids")) {
      icon = FontAwesomeIcons.children;
    } else if (iconClass.contains("fa-pool")) {
      icon = FontAwesomeIcons.personSwimming;
    } else if (iconClass.contains("fa-meals")) {
      icon = FontAwesomeIcons.utensils;
    } else if (iconClass.contains("fa-shows")) {
      icon = FontAwesomeIcons.masksTheater;
    }

    return Container(
      width: 75,
      height: 70,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 30, color: Colors.blue),
          const SizedBox(height: 2),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: MediaQuery.of(context).size.width * 0.02,
                color: Colors.black),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final inclusionList =
        (packageData['inclusion_list'] as List<dynamic>?) ?? [];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: isLoading
              ? _buildShimmerEffect()
              : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Cruise Deals',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 10),
              Column(
                children: [
                  ...(cruiseCards['data'] as List<dynamic>? ?? [])
                      .asMap()
                      .entries
                      .map((entry) {
                    int index = entry.key;
                    var cruise = entry.value;

                    return Column(
                      children: [
                        CruiseOption(
                          title: cruise['cruise_name'] ?? '',
                          checkIn: "${cruise['dep_date'] ?? '00'}",
                          checkOut: "${cruise['arrival_date'] ?? '00'}",
                          duration: '${cruise['duration']}',
                          price: '${cruise['currency']} ${cruise['price']}',
                          isSelected: selectedOption == index,
                          onSelect: () {
                            setState(() {
                              selectedOption = index;
                              selectedCruiseData = cruise;
                            });
                          },
                        ),
                        SizedBox(height: 10),
                      ],
                    );
                  }).toList(),
                ],
              ),
              SizedBox(height: 12),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(color: Colors.grey.shade200),
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppLargeText(
                      text: 'INCLUSION',
                      size: 25,
                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        alignment: WrapAlignment.spaceEvenly,
                        children: inclusionList.map<Widget>((inclusion) {
                          return buildInclusionCard(
                              inclusion['class'], inclusion['name']);
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),

      // Placing the button at the bottom using bottomNavigationBar
      bottomNavigationBar: isLoading? null: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          width: double.infinity,
          child: IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CruiseDealsPage2(
                        selectedCruiseData: selectedCruiseData)),
              );
            },
            icon: responciveButton(text: 'SELECT'),
          ),
        ),
      ),
    );
  }

  Widget _buildShimmerEffect() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            height: 30,
            width: 200,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 20),

        // Cruise Option Shimmer
        Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            height: 100,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        SizedBox(height: 24),

        // Inclusion Section Shimmer
        Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            height: 150,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        SizedBox(height: 24),

        // Travelers Selection Shimmer
        Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            height: 50,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        SizedBox(height: 30),

        // Button Shimmer
        Align(
          alignment: Alignment.center,
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              height: 50,
              width: 150,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
      ],
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
          border: Border.all(
              color: isSelected ? Colors.pinkAccent : Colors.grey[300]!),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox( width: MediaQuery.of(context).size.width * 0.5,
                  child: Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
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
                        color:
                            isSelected ? Colors.pinkAccent : Colors.transparent,
                        border: Border.all(color: Colors.pinkAccent),
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
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(width: 1, color: Colors.grey)),
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(5),
                      child: Text(
                        duration,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: MediaQuery.of(context).size.width * 0.03,
                        ),
                      ),
                    ),
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
