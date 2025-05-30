import 'package:HolidayMakers/widgets/appLargetext.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:HolidayMakers/pages/Cruise/cruise_deals_page.dart';
import 'package:HolidayMakers/utils/api_handler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shimmer/shimmer.dart';

class CruisePackageDetails extends StatefulWidget {
  final String? packageId;

  const CruisePackageDetails({super.key, required this.packageId});

  @override
  State<CruisePackageDetails> createState() => _CruisePackageDetailsState();
}

class _CruisePackageDetailsState extends State<CruisePackageDetails> {
  int currentPage = 0;
  Map<String, dynamic> packageData = {};
  List<Map<String, dynamic>> image = [];
  bool isLoading = true;
  String package_id = "";

  @override
  void initState() {
    super.initState();
    package_id = widget.packageId ?? "";
    _fetchPackageDetails();
  }

  Future<void> _fetchPackageDetails() async {
    try {
      final response = await APIHandler.getCruiseDeal(package_id);
      setState(() {
        packageData = response;

        image = List<Map<String, dynamic>>.from(response['cruise_gallery'].map(
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
          Icon(icon, size: 30, color: Colors.black),
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
    final screenHeight = MediaQuery.of(context).size.height;
    final inclusionList = (packageData['inclusion_list'] as List<dynamic>?) ?? [];
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
                  : Stack(children: [
                      Container(
                          height: screenHeight * 0.35,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(image.isEmpty? "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQD4qmuiXoOrmp-skck7b7JjHA8Ry4TZyPHkw&s":image[index]["image"]),
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
                    ]);
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
                            packageData['cruise_details']['cruise_name'] ??
                                "Unknown Package",
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          // Location
                          Text(
                            packageData['cruise_details']['country_name'] ?? "Unknown Location",
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Info Chips
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _InfoChip(
                                icon: FontAwesomeIcons.sailboat,
                                label: packageData['cruise_details']['dep_date']
                                        ?.toString() ??
                                    "N/A",
                              ),
                              // _InfoChip(
                              //   icon: Icons.location_on,
                              //   label: "${packageData['distance'] ?? '0'} km",
                              // ),
                              _InfoChip(
                                icon: Icons.access_time,
                                label:
                                    "${packageData['cruise_details']['duration'] ?? 'N/A'} avail.",
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
                                    decoration: BoxDecoration(color: Colors.grey.shade50),
                                    padding: const EdgeInsets.all(10),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        AppLargeText(
                                          text: 'INCLUSIONS',
                                          size: 25,
                                        ),
                                        const SizedBox(height: 10),
                                        Container(
                                          child: SingleChildScrollView(
                                            scrollDirection: Axis.horizontal, // Make it horizontally scrollable
                                            child: Wrap(
                                              spacing: 10, // Horizontal space between items
                                              runSpacing: 10, // Vertical space between rows
                                              alignment: WrapAlignment.start, // Align items to the start
                                              children: inclusionList.map<Widget>((inclusion) {
                                                return buildInclusionCard(inclusion['class'], inclusion['name']);
                                              }).toList(),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  if (packageData['cruise_details'] !=
                                      null) ...[
                                    // Package Overview Section
                                    if (packageData['cruise_details']
                                                ['cruise_overview'] !=
                                            null &&
                                        packageData['cruise_details']
                                                ['cruise_overview']
                                            .trim()
                                            .isNotEmpty) ...[
                                      Text(
                                        "Overview",
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      Html(
                                        data: packageData['cruise_details']
                                                ['cruise_overview'] ??
                                            "",
                                        style: {
                                          "ul": Style(
                                              padding: HtmlPaddings.symmetric(
                                                  horizontal: 8, vertical: 0)),
                                          "li": Style(
                                              textAlign: TextAlign.justify,
                                              fontSize: FontSize.medium,
                                              margin: Margins.only(bottom: 4)),
                                          "p": Style(
                                              textAlign: TextAlign.justify,
                                              fontSize: FontSize.medium),
                                        },
                                      ),
                                      const SizedBox(height: 10),
                                    ],

                                    // Package Highlights Section
                                    if (packageData['cruise_details']
                                                ['cruise_highlight'] !=
                                            null &&
                                        packageData['cruise_details']
                                                ['cruise_highlight']
                                            .trim()
                                            .isNotEmpty) ...[
                                      Text(
                                        "Highlights",
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      Html(
                                        data: packageData['cruise_details']
                                                ['cruise_highlight'] ??
                                            "",
                                        style: {
                                          "ul": Style(
                                              padding: HtmlPaddings.symmetric(
                                                  horizontal: 8, vertical: 0)),
                                          "li": Style(
                                              textAlign: TextAlign.justify,
                                              fontSize: FontSize.medium,
                                              margin: Margins.only(bottom: 4)),
                                          "p": Style(
                                              textAlign: TextAlign.justify,
                                              fontSize: FontSize.medium),
                                        },
                                      ),
                                      const SizedBox(height: 10),
                                    ],

                                    // Package Inclusions Section
                                    if (packageData['cruise_details']
                                                ['cruise_inclusion_others'] !=
                                            null &&
                                        packageData['cruise_details']
                                                ['cruise_inclusion_others']
                                            .trim()
                                            .isNotEmpty) ...[
                                      Text(
                                        "Inclusions",
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      Html(
                                        data: packageData['cruise_details']
                                                ['cruise_inclusion_others'] ??
                                            "",
                                        style: {
                                          "ul": Style(
                                              padding: HtmlPaddings.symmetric(
                                                  horizontal: 8, vertical: 0)),
                                          "li": Style(
                                              textAlign: TextAlign.justify,
                                              fontSize: FontSize.medium,
                                              margin: Margins.only(bottom: 4)),
                                          "p": Style(
                                              textAlign: TextAlign.justify,
                                              fontSize: FontSize.medium),
                                        },
                                      ),
                                      const SizedBox(height: 10),
                                    ],
                                    // Package Terms Section
                                    if (packageData['cruise_details']
                                                ['cruise_terms'] !=
                                            null &&
                                        packageData['cruise_details']
                                                ['cruise_terms']
                                            .trim()
                                            .isNotEmpty) ...[
                                      Text(
                                        "Terms and Conditions",
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      Html(
                                        data: packageData['cruise_details']
                                                ['cruise_terms'] ??
                                            "",
                                        style: {
                                          "ul": Style(
                                              padding: HtmlPaddings.symmetric(
                                                  horizontal: 8, vertical: 0)),
                                          "li": Style(
                                              textAlign: TextAlign.justify,
                                              fontSize: FontSize.medium,
                                              margin: Margins.only(bottom: 4)),
                                          "p": Style(
                                              textAlign: TextAlign.justify,
                                              fontSize: FontSize.medium),
                                        },
                                      ),
                                      const SizedBox(height: 10),
                                    ],
                                  ] else ...[
                                    Center(
                                      child: Padding(
                                        padding: EdgeInsets.all(16.0),
                                        child: Text(
                                          "No package details available.",
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Color(0xFF0071BC)),
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 14),
                          // Fixed Bottom Button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
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
                                      builder: (context) => CruiseDealsPage(
                                          packageid: package_id)),
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
        const SizedBox(width: 4),
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
}