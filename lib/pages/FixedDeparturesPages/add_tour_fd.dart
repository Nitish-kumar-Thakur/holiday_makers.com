import 'package:flutter/material.dart';
import 'package:holdidaymakers/pages/FixedDeparturesPages/booking_summary_fd.dart';
import 'package:holdidaymakers/pages/FixedDeparturesPages/tour_selection_modal_fd.dart';
import 'package:holdidaymakers/utils/api_handler.dart';
import 'package:holdidaymakers/widgets/appText.dart';
import 'package:holdidaymakers/widgets/responciveButton.dart';

class TourBookingPage extends StatefulWidget {
  final Map<String, dynamic> packageDetails;
  final Map<String, dynamic> selectedHotel;
  final List<Map<String, dynamic>> flightDetails;
  final List<dynamic> totalRoomsdata;
  final String searchId;

  const TourBookingPage({super.key, required this.packageDetails, required this.selectedHotel, required this.flightDetails, required this.totalRoomsdata, required this.searchId});

  @override
  _TourBookingPageState createState() => _TourBookingPageState();
}

class _TourBookingPageState extends State<TourBookingPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Map<String, dynamic>> selectedTours = [];
  List<Map<String, dynamic>> allTours = [];
  int numberOfDays = 1;
  Map<int, bool> isExpanded = {};
  String destination = "";
  List<Map<String, dynamic>> activityList = [];

  @override
  void initState() {
    super.initState();
    _fetchFDTourList();
    print(widget.packageDetails['duration']);

    List<String> parts = widget.packageDetails['duration'].split("|");
    String daysPart = parts[1].trim(); // "5 Days"
    numberOfDays = int.parse(daysPart.split(" ")[0]); // Extracting only the number

    _tabController = TabController(length: numberOfDays, vsync: this);
    // Add listener to update the UI when tab changes
    _tabController.addListener(() {
      if (_tabController.indexIsChanging || _tabController.index != null) {
        setState(() {});
      }
    });
  }

  Future<void> _fetchFDTourList() async {
    try {
      final response = await APIHandler.getFDTourList(widget.searchId ?? "");
      // final response = await APIHandler.getFDTourList('3649' ?? "");
      setState(() {
        allTours = List<Map<String, dynamic>>.from(response['data']['activity_list'] ?? []);
        destination = response['data']['destination'] ?? "";
      });
      // print('##########################################################');
      // print(widget.searchId);
      // print(allTours);
      // print('##########################################################');
    } catch (e) {
      print("Error fetching package cards: $e");
    }
  }

  void _openTourSelectionModal(int dayIndex) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Colors.transparent,
      builder: (context) {
        List<Map<String, dynamic>> availableTours = allTours.where((tour) =>
        !selectedTours.any((selected) => selected['activity_id'] == tour['activity_id'])).toList();

        return TourSelectionModal(
          tours: availableTours,
          onSelectionChanged: (selectedTour) {
            setState(() {
              selectedTours.add({
                'day': dayIndex + 1,
                ...selectedTour,
              });
            });
          },
        );
      },
    );
  }

  void _removeSelectedTour(int dayIndex) {
    setState(() {
      selectedTours.removeWhere((tour) => tour['day'] == dayIndex + 1);
    });
  }

  List<Map<String, dynamic>> _generateActivityList() {
    return selectedTours.map((tour) {
      return {
        'day': tour['day'],
        'activity_id': tour['activity_id'],
        'fixed_tour': tour['fixed_tour'],
      };
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Tours'), backgroundColor: Colors.blue),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,

              child: Row(
                children: List.generate(numberOfDays, (index) {
                  return GestureDetector(
                    onTap: () => setState(() => _tabController.index = index),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                      // margin: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                      margin: EdgeInsets.only(left: 4, right: 4, top: 12, bottom: 6),
                      decoration: BoxDecoration(
                        color: _tabController.index == index ? Colors.blue : Colors.white,
                        border: Border.all(color: Colors.blue),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text("Day ${index + 1}"),
                    ),
                  );
                }),
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: List.generate(numberOfDays, (index) {
                  Map<String, dynamic>? tourForDay = selectedTours.firstWhere(
                        (tour) => tour['day'] == index + 1,
                    orElse: () => {},
                  );

                  return SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: tourForDay.isEmpty
                          ? ElevatedButton(
                        onPressed: () => _openTourSelectionModal(index),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: Text("+ Add Tour", style: TextStyle(color: Colors.white, fontSize: 18)),
                      )
                          : Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: SingleChildScrollView( // Wrap the Column with SingleChildScrollView
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  tourForDay['images'] ?? "",
                                  height: 150,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Image.asset(
                                      "img/fb.jpg",
                                      height: 150,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                tourForDay['service'] ?? '',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                tourForDay['city_name'] ?? '',
                                style: const TextStyle(fontSize: 14, color: Colors.white),
                              ),
                              Text(
                                "Vendor: ${tourForDay['vendor_name'] ?? ''}",
                                style: const TextStyle(fontSize: 14, color: Colors.white70),
                              ),
                              Text(
                                "Duration: ${tourForDay['duration'] ?? ''}",
                                style: const TextStyle(fontSize: 14, color: Colors.white),
                              ),
                              Text(
                                "Timings: ${tourForDay['timings'] ?? ''}",
                                style: const TextStyle(fontSize: 14, color: Colors.white70),
                              ),
                              const SizedBox(height: 5),
                              // Inclusion with Read More Feature
                              StatefulBuilder(
                                builder: (context, setInnerState) {
                                  bool expanded = isExpanded[index] ?? false;
                                  String inclusion = tourForDay['inclusion'] ?? '';
                                  int maxLength = 100;
                              
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        expanded ? inclusion : (inclusion.length > maxLength ? inclusion.substring(0, maxLength) + "..." : inclusion),
                                        style: const TextStyle(fontSize: 12, color: Colors.white70),
                                        textAlign: TextAlign.justify,
                                      ),
                                      if (inclusion.length > maxLength)
                                        GestureDetector(
                                          onTap: () {
                                            setInnerState(() {
                                              isExpanded[index] = !expanded;
                                            });
                                          },
                                          child: Text(
                                            expanded ? "Read Less" : "Read More",
                                            style: TextStyle(color: Colors.yellow, fontWeight: FontWeight.bold),
                                            textAlign: TextAlign.justify,
                                          ),
                                        ),
                                    ],
                                  );
                                },
                              ),
                              // Text(
                              //   tourForDay['inclusion'] ?? '',
                              //   style: const TextStyle(fontSize: 14, color: Colors.white),
                              //   textAlign: TextAlign.justify,
                              // ),
                              // const SizedBox(height: 5),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "AED ${tourForDay['totalAmount'] ?? ''}",
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                                        onPressed: () => _removeSelectedTour(index),
                                        
                                        child:AppText(text:'Remove', color: Colors.white,),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: 
      Padding(
        padding: EdgeInsets.only(bottom: 24.0, left: 20, right: 20),
        child: GestureDetector(
          onTap: () {
            activityList = _generateActivityList();
            // print('#####################################################');
            // print(destination);
            // print(activityList);
            // print('#####################################################');
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BookingSummaryFD(packageDetails: widget.packageDetails,
                 selectedHotel: widget.selectedHotel,
                  flightDetails: widget.flightDetails, 
                  totalRoomsdata: widget.totalRoomsdata, searchId: widget.searchId,
                  activityList: activityList,
                  destination: destination)
              ),
            );
          },
          child: responciveButton(text: selectedTours.isEmpty ? 'Skip': 'Book Now'),
        )
      ),
    );
  }
}