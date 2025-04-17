import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class TourSelectionModalFIT extends StatefulWidget {
  final List<Map<String, dynamic>> tours;
  // Function(Map<String, dynamic>) onSelectTour;
  final ValueChanged<Map<String, dynamic>> onSelectionChanged;


  const TourSelectionModalFIT({super.key, 
    required this.tours,
    required this.onSelectionChanged
  });

  @override
  // ignore: library_private_types_in_public_api
  _TourSelectionModalFITState createState() => _TourSelectionModalFITState();
}

class _TourSelectionModalFITState extends State<TourSelectionModalFIT> {
  Map<int, bool> isExpanded = {}; // Track which inclusion are expanded

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "SELECT TOUR",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.black),
                  onPressed: () => Navigator.pop(context),
                )
              ],
            ),
          ),

          // Content Section
          Expanded(
            child: widget.tours.isEmpty
                ? Center(
              child: Text(
                "No tours available",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
              ),
            )
                : ListView.builder(
              itemCount: widget.tours.length,
              itemBuilder: (context, index) {
                final Map<String,dynamic> tour = widget.tours[index];
                bool expanded = isExpanded[index] ?? false; // Check if the tour is expanded
                const int maxLength = 100; // Maximum characters before truncating
                String inclusion = tour['inclusion'];

                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          tour['images'] ?? "",
                          height: 150,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              "img/launch_image.png",
                              height: 150,
                              width: double.infinity,
                              fit: BoxFit.contain,
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        tour['service'],
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                      Text(
                        tour['city_name'],
                        style: const TextStyle(fontSize: 14, color: Colors.black45),
                      ),
                      Text(
                        "Duration: ${tour['duration']}",
                        style: const TextStyle(fontSize: 14, color: Colors.black),
                      ),
                      Text(
                        "Timings: ${tour['timings']}",
                        style: const TextStyle(fontSize: 14, color: Colors.black45),
                      ),
                      Text(
                        "Tour Category: ${tour['tour_category']}",
                        style: const TextStyle(fontSize: 14, color: Colors.black),
                      ),
                      // const SizedBox(height: 5),

                      // inclusion with Read More Feature
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Html(
                            data: expanded
                                ? inclusion
                                : (inclusion.length > maxLength
                                  ? inclusion.substring(0, maxLength) + "..."
                                  : inclusion),
                            style: {
                              "body": Style(
                                fontSize: FontSize(12),
                                color: Colors.black,
                                textAlign: TextAlign.justify,  // Justify the text
                                margin: Margins.zero,  // Removes extra margins
                                padding: HtmlPaddings.zero, // Removes extra padding
                              ),
                            },
                          ),
                          if (inclusion.length > maxLength) // Show Read More only if text is long
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  isExpanded[index] = !expanded;
                                });
                              },
                              child: Text(
                                expanded ? "Read Less" : "Read More",
                                style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                              ),
                            ),
                        ],
                      ),

                      const SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "AED ${tour['Per_totalAmount']}/person",
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF0071BC)),
                            onPressed: () {
                              widget.onSelectionChanged(tour);
                              Navigator.pop(context);
                              // print(tour.runtimeType);

                            },
                            child: const Text("SELECT", style: TextStyle(color: Colors.white)),
                          )
                        ],
                      )
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
