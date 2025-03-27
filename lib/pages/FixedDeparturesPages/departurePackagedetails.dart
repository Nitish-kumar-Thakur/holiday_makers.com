import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:HolidayMakers/pages/FixedDeparturesPages/departureDeals.dart';
import 'package:HolidayMakers/utils/api_handler.dart';
import 'package:HolidayMakers/widgets/appLargetext.dart';
import 'package:shimmer/shimmer.dart';

class DeparturePackageDetails extends StatefulWidget {
  final String? packageId;

  const DeparturePackageDetails({super.key, this.packageId});

  @override
  State<DeparturePackageDetails> createState() =>
      _DeparturePackageDetailsState();
}

class _DeparturePackageDetailsState extends State<DeparturePackageDetails> {
  int currentPage = 0;
  Map<String, dynamic> packageData = {};
  List<dynamic> inclusionList = [];
  String countryName = "";
  String cityName = "";
  List<Map<String, dynamic>> image = [];

  bool isLoading = true;
  String packageId = "";
  @override
  void initState() {
    super.initState();
    packageId = widget.packageId ?? "";
    _fetchPackageDetails();
  }

  Future<void> _fetchPackageDetails() async {
    try {
      final response = await APIHandler.getDepartureDeal(packageId);
      setState(() {
        packageData = response['package_details'] ?? {};
        inclusionList = response["inclusion_list"];
        countryName = response["country_name"];
        cityName = response["city_name"];

        image = List<Map<String, dynamic>>.from(response['package_gallery'].map(
            (item) => {'image': item['image'], 'alt_text': item['alt_text']}));

        isLoading = false;
      });
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      print("Error fetching package details: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CarouselSlider.builder(
            itemCount: image.length,
            itemBuilder: (context, index, realIndex) {
              return isLoading
                  ? Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        height: 300,
                        width: double.infinity,
                        color: Colors.white,
                      ),
                    )
                  : Stack(
                      children: [
                        Container(
                          height: 300,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(image[index]["image"]),
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          height: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black.withOpacity(
                                    0.2), // Dark gradient at the bottom
                                Colors.transparent, // Transparent at the top
                              ],
                            ),
                          ),
                        )
                      ],
                    );
            },
            options: CarouselOptions(
              height: 300.0,
              autoPlay: true,
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
          // Background Image

          // Back Button
          Positioned(
            top: 50,
            left: 8,
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: CircleAvatar(
                backgroundColor: Colors.grey.withOpacity(0.6),  // Transparent grey background
                child: Text(
                  '<',  // Use "<" symbol
                  style: TextStyle(
                    color: Colors.white,  // White text color
                    fontSize: 24,  // Adjust font size as needed
                    fontWeight: FontWeight.bold,  // Make the "<" bold if needed
                  ),
                ),
              ),
            ),
          ),

          // Card Content
          DraggableScrollableSheet(
            initialChildSize: 0.7,
            minChildSize: 0.7,
            maxChildSize: 1.0,
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: isLoading
                    ? _buildShimmerEffect()
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Container(
                              height: 4,
                              width: 40,
                              color: Colors.grey[300],
                              margin: const EdgeInsets.only(bottom: 16),
                            ),
                          ),
                          // Package Name
                          Text(
                            packageData['package_name'] ?? "Unknown Package",
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          // Location
                          Row(
                            children: [
                              // Location icon
                              Icon(
                                Icons.location_on,
                                color: Color(0xFF0071BC), // Change the icon color as needed
                                size: 18, // Adjust the icon size if needed
                              ),
                              // Text with city and country
                              SizedBox(width: 8), // Adds space between the icon and the text
                              Text(
                                "$cityName, $countryName" ?? "Unknown Location",
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          // Info Chips
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _InfoChip(
                                icon: Icons.flight_takeoff,
                                label: packageData["dep_date"]?.toString() ??
                                    "4.8/5.0",
                              ),
                              // _InfoChip(
                              //   icon: Icons.location_on,
                              //   label: "${packageData['distance'] ?? '0'} km",
                              // ),
                              _InfoChip(
                                icon: Icons.access_time,
                                label: "${packageData['duration'] ?? 'N/A'}",
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          // Description & Scrollable Content
                          Expanded(
                            child: SingleChildScrollView(
                              controller: scrollController,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                        color: Colors.grey.shade50,
                                        borderRadius: BorderRadius.circular(15),
                                    ),
                                    padding: const EdgeInsets.all(10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        AppLargeText(
                                          text: 'INCLUSIONS',
                                          size: 25,
                                        ),
                                        const SizedBox(height: 10),
                                        Center(
                                          child: Wrap(
                                            spacing:
                                                10, // Horizontal space between items
                                            runSpacing:
                                                10, // Vertical space between rows
                                            alignment:
                                                WrapAlignment.spaceEvenly,
                                            children: inclusionList
                                                .map<Widget>((inclusion) {
                                              return buildInclusionCard(
                                                  inclusion['class'],
                                                  inclusion['name']);
                                            }).toList(),
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 24),
                                  if (packageData['package_overview'] != null &&
                                      packageData['package_overview']!
                                          .trim()
                                          .isNotEmpty) ...[
                                    Text(
                                      "Package Overview",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    Html(
                                      data: packageData['package_overview']!,
                                      style: {
                                        "ul": Style(
                                          padding: HtmlPaddings.symmetric(
                                              horizontal: 8, vertical: 0),
                                        ),
                                        "li": Style(
                                          textAlign: TextAlign.justify,
                                          fontSize: FontSize.medium,
                                          margin: Margins.only(bottom: 4),
                                        ),
                                        "p": Style(
                                          textAlign: TextAlign.justify,
                                          fontSize: FontSize.medium,
                                        ),
                                      },
                                    ),
                                    const SizedBox(height: 10),
                                  ],
                                  if (packageData['package_terms'] != null &&
                                      packageData['package_terms']!
                                          .trim()
                                          .isNotEmpty) ...[
                                    Text(
                                      "Package Terms",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    Html(
                                      data: packageData['package_terms']!,
                                      style: {
                                        "ul": Style(
                                          padding: HtmlPaddings.symmetric(
                                              horizontal: 8, vertical: 0),
                                        ),
                                        "li": Style(
                                          textAlign: TextAlign.justify,
                                          fontSize: FontSize.medium,
                                          margin: Margins.only(bottom: 4),
                                        ),
                                        "p": Style(
                                          textAlign: TextAlign.justify,
                                          fontSize: FontSize.medium,
                                        ),
                                      },
                                    ),
                                    const SizedBox(height: 10),
                                  ],
                                  if (packageData['package_highlight'] !=
                                          null &&
                                      packageData['package_highlight']!
                                          .trim()
                                          .isNotEmpty) ...[
                                    Text(
                                      "Package Highlights",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    Html(
                                      data: packageData['package_highlight']!,
                                      style: {
                                        "ul": Style(
                                          padding: HtmlPaddings.symmetric(
                                              horizontal: 8, vertical: 0),
                                        ),
                                        "li": Style(
                                          textAlign: TextAlign.justify,
                                          fontSize: FontSize.medium,
                                          margin: Margins.only(bottom: 4),
                                        ),
                                        "p": Style(
                                          textAlign: TextAlign.justify,
                                          fontSize: FontSize.medium,
                                        ),
                                      },
                                    ),
                                    const SizedBox(height: 10),
                                  ],
                                  if (packageData['package_inclusion_others'] !=
                                          null &&
                                      packageData['package_inclusion_others']!
                                          .trim()
                                          .isNotEmpty) ...[
                                    Text(
                                      "Package Inclusions",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    Html(
                                      data: packageData[
                                          'package_inclusion_others']!,
                                      style: {
                                        "ul": Style(
                                          padding: HtmlPaddings.symmetric(
                                              horizontal: 8, vertical: 0),
                                        ),
                                        "li": Style(
                                          textAlign: TextAlign.justify,
                                          fontSize: FontSize.medium,
                                          margin: Margins.only(bottom: 4),
                                        ),
                                        "p": Style(
                                          textAlign: TextAlign.justify,
                                          fontSize: FontSize.medium,
                                        ),
                                      },
                                    ),
                                    const SizedBox(height: 10),
                                  ],
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 14),
                          // Fixed Bottom Button
                          SizedBox(
                            width: double.infinity,
                            child: isLoading
                                ? null
                                : ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Color(0xFF0071BC),
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 13,
                                        horizontal: 80,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                DepartureDeals(
                                                    packageId: packageId)),
                                      );
                                    },
                                    child: const Text(
                                      "Book A Trip",
                                      style: TextStyle(
                                          fontSize: 22, color: Colors.white),
                                    ),
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

  Widget _InfoChip({required IconData icon, required String label}) {
    return Row(
      children: [
        Icon(icon, color: Color(0xFF0071BC), size: 20),
        const SizedBox(width: 5),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
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
            height: 24,
            width: 200,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            height: 16,
            width: 150,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
            3,
            (index) => Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                height: 30,
                width: 80,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            height: 150,
            width: double.infinity,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
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
        color: Color(0xFF009EE2).withOpacity(0.2),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Color(0xFF009EE2),  // Set border color to #009EE2
          width: 2,  // You can adjust the width of the border here
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 30, color: Colors.black),  // Change icon color to black
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width * 0.02,
              color: Colors.black,  // Change text color to black
            ),
          ),
        ],
      ),
    );

  }
}
