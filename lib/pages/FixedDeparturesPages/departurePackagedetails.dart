import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:holdidaymakers/pages/FixedDeparturesPages/departureDeals.dart';
import 'package:holdidaymakers/utils/api_handler.dart';
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
  List<Map<String,dynamic>> image=[];
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
      final response = await APIHandler.getDepartureDeal(package_id ?? "");
      setState(() {
        packageData = response['package_details'] ?? {};

        image = List<Map<String, dynamic>>.from(
            response['package_gallery'].map((item) => {
            'image': item['image'],
            'alt_text': item['alt_text']}));


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
                  : Container(
                height: 300,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(image[index]["image"]),
                    fit: BoxFit.cover,
                  ),
                ),
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
            top: 40,
            left: 16,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.pop(context);
              },
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
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
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
                    Text(
                      packageData['location'] ?? "Unknown Location",
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
                          icon: Icons.star,
                          label: packageData['rating']?.toString() ??
                              "4.8/5.0",
                        ),
                        _InfoChip(
                          icon: Icons.location_on,
                          label: "${packageData['distance'] ?? '0'} km",
                        ),
                        _InfoChip(
                          icon: Icons.access_time,
                          label: "${packageData['availability'] ?? 'N/A'} avail.",
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
                            if (packageData['package_overview'] != null && packageData['package_overview']!.trim().isNotEmpty) ...[
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
                                    padding: HtmlPaddings.symmetric(horizontal: 8, vertical: 0),
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
                            if (packageData['package_terms'] != null && packageData['package_terms']!.trim().isNotEmpty) ...[
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
                                    padding: HtmlPaddings.symmetric(horizontal: 8, vertical: 0),
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
                            if (packageData['package_highlight'] != null && packageData['package_highlight']!.trim().isNotEmpty) ...[
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
                                    padding: HtmlPaddings.symmetric(horizontal: 8, vertical: 0),
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
                            if (packageData['package_inclusion_others'] != null && packageData['package_inclusion_others']!.trim().isNotEmpty) ...[
                              Text(
                                "Package Inclusions",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              Html(
                                data: packageData['package_inclusion_others']!,
                                style: {
                                  "ul": Style(
                                    padding: HtmlPaddings.symmetric(horizontal: 8, vertical: 0),
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
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
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
                                builder: (context) => DepartureDeals(packageId: package_id)),
                          );
                        },
                        child: const Text(
                          "Book A Trip",
                          style: TextStyle(fontSize: 22, color: Colors.white),
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
        Icon(icon, color: Colors.red, size: 20),
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
