import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:holdidaymakers/pages/FixedDeparturesPages/hotelsAccommodation.dart';
import 'package:holdidaymakers/utils/api_handler.dart';
import 'package:holdidaymakers/widgets/appLargetext.dart';
import 'package:holdidaymakers/widgets/mainCarousel.dart';
import 'package:holdidaymakers/widgets/responciveButton.dart';
import 'package:holdidaymakers/widgets/travelerDrawer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class DepartureDeals extends StatefulWidget {
  final String? packageId;
  const DepartureDeals({Key? key, this.packageId}) : super(key: key);

  @override
  _DepartureDealsState createState() => _DepartureDealsState();
}

class _DepartureDealsState extends State<DepartureDeals> {
  Map<String, dynamic> packageData = {};
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    _fetchPackageDetails();
  }

  Future<void> _fetchPackageDetails() async {
    final response = await APIHandler.getDepartureDeal(widget.packageId ?? "");
    setState(() {
      packageData = response;
      isLoading = false;
    });
  }

  DateTime? selectedDate;
  int selectedOption = 0;
  String? selectedRoom;
  String? selectedAdult;
  String? selectedChild;
  List<String>? childrenAge;

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
          Icon(icon, size: 30, color: Colors.blue),
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
                    // Cruise Options Section
                    PackageCard(
                      title:
                          packageData['package_details']['package_name'] ?? '',
                      departureDate:
                          packageData['package_details']['dep_date'] ?? '',
                      arrivalDate:
                          packageData['package_details']['arrival_date'] ?? '',
                      duration:
                          packageData['package_details']['duration'] ?? '',
                      price:
                          '${packageData['package_details']['currency']} ${packageData['package_details']['discounted_price'].toString()}' ??
                              '',
                      image: List<Map<String, dynamic>>.from(
                        packageData['package_gallery'].map((item) => {
                              'image': item['image'],
                              'alt_text': item['alt_text']
                            }),
                      ),
                      isSelected: selectedOption == 0,
                      onSelect: () {
                        setState(() {
                          selectedOption = 0;
                        });
                      },
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
                        });
                      },
                    ),
                    SizedBox(height: 30),

                    // Hotel Card Section
                  ],
                ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(bottom: 15),
        child: IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          HotelsAccommodation(packageData: packageData)));
            },
            icon: responciveButton(text: 'SELECT')),
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
  final List<Map<String, dynamic>> image;
  final bool isSelected;
  final VoidCallback onSelect;

  const PackageCard(
      {super.key,
      required this.title,
      required this.departureDate,
      required this.arrivalDate,
      required this.duration,
      required this.price,
      required this.isSelected,
      required this.onSelect,
      required this.image});

  @override
  State<PackageCard> createState() => _PackageCardState();
}

class _PackageCardState extends State<PackageCard> {
  int currentPage = 0;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onSelect,
      child: Container(
        // padding: EdgeInsets.all(16  ),
        decoration: BoxDecoration(
          color: Colors.grey[200]!,
          borderRadius: BorderRadius.circular(8),
          // border:
          //     Border.all(color: widget.isSelected ? Colors.yellow : Colors.grey[300]!),
        ),
        child: Column(
          children: [
            CarouselSlider.builder(
              itemCount: widget.image.length,
              itemBuilder: (context, index, realIndex) {
                return Container(
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: NetworkImage(widget.image[index]["image"]),
                      fit: BoxFit.fill,
                    ),
                  ),
                );
              },
              options: CarouselOptions(
                height: 200.0,
                autoPlay: widget.image.length > 1 ? true : false,
                autoPlayInterval: const Duration(milliseconds: 2500),
                autoPlayAnimationDuration: const Duration(milliseconds: 900),
                enlargeCenterPage: true,
                viewportFraction: 1.0,
                aspectRatio: 16 / 9,
                onPageChanged: (index, carouselPageChangedReason) {
                  setState(() {
                    currentPage = index;
                  });
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedSmoothIndicator(
                  activeIndex: currentPage,
                  count: widget.image.length,
                  effect: WormEffect(
                    dotHeight: 10,
                    dotWidth: 10,
                    activeDotColor: Colors.red,
                    dotColor: Colors.blue.shade200.withOpacity(0.5),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 230,
                        child: Text(
                          widget.title,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: MediaQuery.of(context).size.width * 0.05,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            widget.price,
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.05,
                            ),
                          ),
                          // SizedBox(width: 8),
                          // Container(
                          //   height: 10,
                          //   width: 10,
                          //   decoration: BoxDecoration(
                          //     shape: BoxShape.circle,
                          //     color: widget.isSelected ? Colors.yellow : Colors.transparent,
                          //     border: Border.all(color: Colors.yellow),
                          //   ),
                          // ),
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
                          fontSize: MediaQuery.of(context).size.width * 0.04,
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
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.03,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Text(
                        widget.arrivalDate,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: MediaQuery.of(context).size.width * 0.04,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
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
