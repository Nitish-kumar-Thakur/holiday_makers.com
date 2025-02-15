import 'package:flutter/material.dart';
import 'package:holdidaymakers/pages/FixedDeparturesPages/hotelsAccommodation.dart';
import 'package:holdidaymakers/utils/api_handler.dart';
import 'package:holdidaymakers/widgets/appLargetext.dart';
import 'package:holdidaymakers/widgets/responciveButton.dart';
import 'package:holdidaymakers/widgets/travelerDrawer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shimmer/shimmer.dart';

class DepartureDeals extends StatefulWidget {
  final String? packageId;
  const DepartureDeals({Key? key, this.packageId}) : super(key: key);

  @override
  _DepartureDealsState createState() => _DepartureDealsState();
}

class _DepartureDealsState extends State<DepartureDeals> {
  Map<String, dynamic> packageData = {};
  List<dynamic> packageList = [];
  bool isLoading = true;
  int selectedOption = 0;
  String? selectedRoom= "1";
  String? selectedAdult="2";
  String? selectedChild="0";
  List<String>? childrenAge;
  Map<String, dynamic>? selectedPackageData;
  List<dynamic> totalRoomsdata = [{"adult": "1", "child": "0", "childage": []}];

  @override
  void initState() {
    super.initState();
    _fetchPackageDetails();
    _fetchPackageCards();
  }

  Future<void> _fetchPackageDetails() async {
    final response = await APIHandler.getDepartureDeal(widget.packageId ?? "");
    setState(() {
      packageData = response;
      isLoading = false;
    });
  }

  Future<void> _fetchPackageCards() async {
    try {
      final response = await APIHandler.getFDCards(widget.packageId ?? "");
      setState(() {
        packageList = response['data'] ?? [];
        isLoading = false;
        selectedPackageData = packageList[0];
        selectedOption = 0;
      });
    } catch (e) {
      print("Error fetching package cards: $e");
    }
  }

  Widget buildInclusionCard(String iconClass, String label) {
    // Default icon in case no match is found
    IconData icon = FontAwesomeIcons.circleQuestion;

    // Map FontAwesome icon classes to Flutter icon
    if (iconClass == "fa fa-plane") {
      icon = FontAwesomeIcons.plane;
    } else if (iconClass == "fa fa-bed") {
      icon = FontAwesomeIcons.bed;
    } else if (iconClass == "fa fa-car") {
      icon = FontAwesomeIcons.car;
    } else if (iconClass == "fa fa-shield") {
      icon = FontAwesomeIcons.shieldHalved;
    } else if (iconClass == "fa fa-binoculars") {
      icon = FontAwesomeIcons.binoculars;
    } else if (iconClass == "far fa-daily-breakfast") {
      icon = FontAwesomeIcons.utensils;
    } else if (iconClass == "fa fa-user") {
      icon = FontAwesomeIcons.user;
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
          Icon(icon, size: 30, color: Colors.red),
          const SizedBox(height: 2),
          Text(
            label,
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
        title: Text(
          'Fixed Departures',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
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
                    // Package Selection Section
                    Text(
                      'Available Packages',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 10),

                    Column(
                      children: packageList.asMap().entries.map((entry) {
                        int index = entry.key;
                        var package = entry.value;

                        return Column(
                          children: [
                            PackageCard(
                              title: package['package_name'] ?? '',
                              departureDate:
                                  "${package['start_date']}-${package['start_month']}-${package['start_year']}",
                              arrivalDate:
                                  "${package['end_date']}-${package['end_month']}-${package['end_year']}",
                              duration:
                                  '${package['nights']} Nights / ${package['days']} Days',
                              price:
                                  '${package['currency']} ${package['price']}',
                              isSelected: selectedOption == index,
                              onSelect: () {
                                setState(() {
                                  selectedOption = index;
                                  selectedPackageData = package; // Store selected package data
                                });
                              },
                            ),
                            SizedBox(height: 10),
                          ],
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 24),

                    // Inclusion Section
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
                              spacing: 10, // Horizontal space between items
                              runSpacing: 10, // Vertical space between rows
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
                    SizedBox(height: 24),

                    // Traveler Selection
                    Text(
                      'SELECT TRAVELLERS',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 10),
                    Travelerdrawer(
                      onSelectionChanged: (Map<String, dynamic> selection) {
                        setState(() {
                          selectedRoom =
                              selection['totalRooms'].toString() ?? "1";
                          selectedAdult =
                              selection['totalAdults'].toString() ?? "1";
                          selectedChild =
                              selection['totalChildren'].toString() ?? "0";
                          childrenAge = selection['childrenAges'];
                          totalRoomsdata = selection["totalData"];
                        });
                      },
                    ),
                    SizedBox(height: 30),
                  ],
                ),
        ),
      ),

      // Bottom Navigation Button
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(bottom: 15),
        child: IconButton(
          onPressed: () {
            if (selectedPackageData != null) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      HotelsAccommodation(packageData: selectedPackageData!),
                ),
              );
            }
            print('====================================');
            print(totalRoomsdata);
            print('====================================');
            print(selectedRoom);
            print('====================================');
          },
          icon: responciveButton(text: 'SELECT'),
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

class PackageCard extends StatefulWidget {
  final String title;
  final String departureDate;
  final String arrivalDate;
  final String duration;
  final String price;
  final bool isSelected;
  final VoidCallback onSelect;

  const PackageCard({
    super.key,
    required this.title,
    required this.departureDate,
    required this.arrivalDate,
    required this.duration,
    required this.price,
    required this.isSelected,
    required this.onSelect,
  });

  @override
  State<PackageCard> createState() => _PackageCardState();
}

class _PackageCardState extends State<PackageCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onSelect,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[200]!,
          borderRadius: BorderRadius.circular(8),
          border:
          Border.all(color: widget.isSelected ? Colors.pinkAccent : Colors.grey[300]!),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      widget.price,
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
                        color: widget.isSelected ? Colors.pinkAccent : Colors.transparent,
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
                  widget.departureDate,
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
                        widget.duration,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: MediaQuery.of(context).size.width * 0.03,
                        ),
                      ),
                    ),
                  ),
                ),
                Text(
                  widget.arrivalDate,
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
