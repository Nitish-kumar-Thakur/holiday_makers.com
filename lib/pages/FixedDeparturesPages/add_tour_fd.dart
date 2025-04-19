import 'package:flutter/material.dart';
import 'package:HolidayMakers/pages/FixedDeparturesPages/booking_summary_fd.dart';
import 'package:HolidayMakers/pages/FixedDeparturesPages/tour_selection_modal_fd.dart';
import 'package:HolidayMakers/utils/api_handler.dart';
import 'package:HolidayMakers/widgets/appText.dart';
import 'package:HolidayMakers/widgets/responciveButton.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart' as dom;

class TourBookingPage extends StatefulWidget {
  final Map<String, dynamic> packageDetails;
  final Map<String, dynamic> selectedHotel;
  final List<Map<String, dynamic>> flightDetails;
  final List<dynamic> totalRoomsdata;
  final List<dynamic> fixedActivities;
  final String searchId;
  final bool isOnwardConnecting;
  final bool isReturnConnecting;

  const TourBookingPage(
      {super.key,
      required this.packageDetails,
      required this.selectedHotel,
      required this.flightDetails,
      required this.totalRoomsdata,
      required this.searchId,
      required this.fixedActivities,
      required this.isOnwardConnecting,
      required this.isReturnConnecting
      });

  @override
  _TourBookingPageState createState() => _TourBookingPageState();
}

class _TourBookingPageState extends State<TourBookingPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Map<String, dynamic>> selectedTours = [];
  List<Map<String, dynamic>> allTours = [];
  int numberOfDays = 1;
  Map<int, bool> isExpanded = {};
  String destination = "";
  List<Map<String, dynamic>> activityList = [];
  Map<int, int> totalMinutesPerDay = {};
  Set<int> unselectableDays = {}; // Tracks days that are blocked due to multi-day tours

  @override
  void initState() {
    super.initState();

    // Fetch available tours
    _fetchFDTourList();

    // Extract number of days from package details
    List<String> parts = widget.packageDetails['duration'].split("|");
    String daysPart = parts[1].trim(); // "5 Days"
    numberOfDays =
        int.parse(daysPart.split(" ")[0]); // Extracting only the number

    // Initialize tab controller
    _tabController = TabController(length: numberOfDays, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        int newIndex = _tabController.index;

        if (unselectableDays.contains(newIndex + 1)) {
          // Prevent the selection of unselectable days
          Future.delayed(Duration(milliseconds: 100), () {
            _tabController.index = _tabController.previousIndex;
          });
          Fluttertoast.showToast(msg: "This day is part of a multi-day tour and cannot be selected.");
        } else {
          setState(() {}); // Ensure UI updates
        }
      }
    });

    // **Prepopulate selectedTours with fixedActivities & track total duration**
    for (var fixedActivity in widget.fixedActivities[0]['activity']) {
      int day = int.parse(fixedActivity['day']);
      int fixedActivityDuration =
          _extractDurationInMinutes(fixedActivity['duration']);
      int durationInDays = fixedActivity['duration_in_days'] ?? 0;

      selectedTours.add({
        'day': day,
        'activity_id': fixedActivity['activity_id'],
        'service': fixedActivity['service'],
        'vendor_name': fixedActivity['vendor_name'],
        'duration': fixedActivity['duration'],
        'timings': fixedActivity['timings'],
        'images': fixedActivity['images'],
        'city_name': fixedActivity['city_name'],
        'inclusion': fixedActivity['inclusion'],
        'totalAmount': fixedActivity['totalAmount'],
        'fixed_tour': "Yes",
        'duration_in_days': durationInDays,
      });

      // Add the fixed tour duration to totalMinutesPerDay
      totalMinutesPerDay[day] =
          (totalMinutesPerDay[day] ?? 0) + fixedActivityDuration;

      // Mark the additional days as unavailable
      for (int i = 1; i < durationInDays; i++) {
        unselectableDays.add(day + i);
      }
    }
  }

  Future<void> _fetchFDTourList() async {
    try {
      final response = await APIHandler.getFDTourList(widget.searchId ?? "");
      // final response = await APIHandler.getFDTourList('3649' ?? "");
      setState(() {
        allTours = List<Map<String, dynamic>>.from(
            response['data']['activity_list'] ?? []);
        destination = response['data']['destination'] ?? "";
      });
      // print('##########################################################');
      // print(widget.searchId);
      // print(allTours);
      // print('##########################################################');
    } catch (e) {
      print("Error fetching tour list: $e");
    }
  }

  // void _openTourSelectionModal(int dayIndex) {
  //   showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true,
  //     shape: RoundedRectangleBorder(
  //       borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
  //     ),
  //     backgroundColor: Colors.transparent,
  //     builder: (context) {
  //       List<Map<String, dynamic>> availableTours = allTours.where((tour) =>
  //       !selectedTours.any((selected) => selected['activity_id'] == tour['activity_id'])).toList();
  //
  //       return TourSelectionModal(
  //         tours: availableTours,
  //         onSelectionChanged: (selectedTour) {
  //           setState(() {
  //             selectedTours.add({
  //               'day': dayIndex + 1,
  //               ...selectedTour,
  //             });
  //           });
  //         },
  //       );
  //     },
  //   );
  // }

  int _extractDurationInMinutes(String duration) {
    RegExp regex = RegExp(r'(\d+)\s*Hours?|\b(\d+)\s*Minutes?\b');
    Iterable<RegExpMatch> matches = regex.allMatches(duration);

    int totalMinutes = 0;

    for (var match in matches) {
      if (match.group(1) != null) {
        totalMinutes +=
            int.parse(match.group(1)!) * 60; // Convert hours to minutes
      }
      if (match.group(2) != null) {
        totalMinutes += int.parse(match.group(2)!); // Add minutes directly
      }
    }

    return totalMinutes;
  }

  // void _openTourSelectionModal(int dayIndex) {
  //   if (unselectableDays.contains(dayIndex + 1)) {
  //     Fluttertoast.showToast(msg: "You cannot add tours on this day as it is part of a multi-day tour.");
  //     return;
  //   }
  //
  //   showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true,
  //     shape: RoundedRectangleBorder(
  //       borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
  //     ),
  //     backgroundColor: Colors.transparent,
  //     builder: (context) {
  //       List<Map<String, dynamic>> availableTours = allTours.where((tour) {
  //         return !selectedTours.any(
  //             (selected) => selected['activity_id'] == tour['activity_id']);
  //       }).toList();
  //
  //       return TourSelectionModal(
  //         tours: availableTours,
  //         onSelectionChanged: (selectedTour) {
  //           int newTourDurationMinutes =
  //               _extractDurationInMinutes(selectedTour['duration']);
  //           int currentTotalMinutes = totalMinutesPerDay[dayIndex + 1] ?? 0;
  //
  //           if (currentTotalMinutes + newTourDurationMinutes > 480) {
  //             Fluttertoast.showToast(msg: "Cannot add more than 8 hours of tours per day.");
  //             return;
  //           }
  //
  //           setState(() {
  //             selectedTours.add({
  //               'day': dayIndex + 1,
  //               ...selectedTour,
  //             });
  //             totalMinutesPerDay[dayIndex + 1] =
  //                 currentTotalMinutes + newTourDurationMinutes;
  //           });
  //         },
  //       );
  //     },
  //   );
  // }

  void _openTourSelectionModal(int dayIndex) {
    if (unselectableDays.contains(dayIndex + 1)) {
      Fluttertoast.showToast(msg: "You cannot add tours on this day as it is part of a multi-day tour.");
      return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Colors.transparent,
      builder: (context) {
        List<Map<String, dynamic>> availableTours = allTours.where((tour) {
          return !selectedTours.any(
                  (selected) => selected['activity_id'] == tour['activity_id']);
        }).toList();

        return TourSelectionModal(
          tours: availableTours,
          onSelectionChanged: (selectedTour) {
            int newTourDurationMinutes =
            _extractDurationInMinutes(selectedTour['duration']);
            int durationInDays = selectedTour['duration_in_days'] ?? 0;

            int currentTotalMinutes = totalMinutesPerDay[dayIndex + 1] ?? 0;

            // Check if it's a combo tour (spans multiple days)
            if (durationInDays > 1) {
              int selectedDay = dayIndex + 1;
              List<int> targetDays = List.generate(durationInDays, (i) => selectedDay + i);

              // Check if combo tour goes beyond package duration
              if (selectedDay + durationInDays - 1 > numberOfDays) {
                Fluttertoast.showToast(
                    msg: "Tour duration exceeds your package duration.");
                return;
              }

              // Get list of all used days from selectedTours
              Set<int> usedDays = selectedTours.map((t) => t['day'] as int).toSet();

              // Check if combo tour overlaps any of the used days
              bool overlapExists = targetDays.any((day) => usedDays.contains(day));

              if (overlapExists) {
                Fluttertoast.showToast(
                    msg: "Cannot add this tour as it overlaps a tour on another day.");
                return;
              }

              // No conflicts — proceed
              for (int i = 1; i < durationInDays; i++) {
                unselectableDays.add(selectedDay + i);
              }

              setState(() {
                selectedTours.add({
                  'day': selectedDay,
                  ...selectedTour,
                });

                totalMinutesPerDay[selectedDay] =
                    currentTotalMinutes + newTourDurationMinutes;
              });
            }
            else {
              // Standard tour — enforce 8-hour rule
              if (currentTotalMinutes + newTourDurationMinutes > 480) {
                Fluttertoast.showToast(
                    msg: "Cannot add more than 8 hours of tours per day.");
                return;
              }

              setState(() {
                selectedTours.add({
                  'day': dayIndex + 1,
                  ...selectedTour,
                });

                totalMinutesPerDay[dayIndex + 1] =
                    currentTotalMinutes + newTourDurationMinutes;
              });
            }
          },
        );
      },
    );
  }

  // void _removeSelectedTour(int dayIndex, String activityId) {
  //   setState(() {
  //     selectedTours.removeWhere((tour) => tour['day'] == dayIndex + 1 && tour['activity_id'] == activityId);
  //   });
  // }

  // void _removeSelectedTour(int dayIndex, String activityId) {
  //   setState(() {
  //     var tourToRemove = selectedTours.firstWhere(
  //       (tour) =>
  //           tour['day'] == dayIndex + 1 && tour['activity_id'] == activityId,
  //       orElse: () => {},
  //     );
  //
  //     if (tourToRemove.isNotEmpty) {
  //       int removedTourDurationMinutes =
  //           _extractDurationInMinutes(tourToRemove['duration']);
  //
  //       // Subtract tour duration from total minutes
  //       totalMinutesPerDay[dayIndex + 1] =
  //           (totalMinutesPerDay[dayIndex + 1] ?? 0) -
  //               removedTourDurationMinutes;
  //
  //       // Remove tour from list
  //       selectedTours.removeWhere((tour) =>
  //           tour['day'] == dayIndex + 1 && tour['activity_id'] == activityId);
  //     }
  //   });
  // }

  void _removeSelectedTour(int dayIndex, String activityId) {
    setState(() {
      var tourToRemove = selectedTours.firstWhere(
            (tour) =>
        tour['day'] == dayIndex + 1 && tour['activity_id'] == activityId,
        orElse: () => {},
      );

      if (tourToRemove.isNotEmpty) {
        int removedTourDurationMinutes =
        _extractDurationInMinutes(tourToRemove['duration']);
        int durationInDays = tourToRemove['duration_in_days'] ?? 0;

        // Subtract tour duration from total minutes
        totalMinutesPerDay[dayIndex + 1] =
            (totalMinutesPerDay[dayIndex + 1] ?? 0) - removedTourDurationMinutes;

        // If it's a combo tour, free up the next days
        if (durationInDays > 1) {
          for (int i = 1; i < durationInDays; i++) {
            unselectableDays.remove(dayIndex + 1 + i);
          }
        }

        // Remove tour from list
        selectedTours.removeWhere((tour) =>
        tour['day'] == dayIndex + 1 && tour['activity_id'] == activityId);
      }

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

  String _htmlToPlainText(String html) {
    // Parse the HTML content
    dom.Document document = parse(html);
    // Extract the plain text by calling 'text' on the document
    return document.body?.text ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Container( decoration: BoxDecoration(image: DecorationImage(image: AssetImage('img/departureDealsBG.png'), fit: BoxFit.fill)),
      child: Scaffold( backgroundColor: Colors.transparent,
      // appBar: AppBar(leading: IconButton(
      //       icon: Icon(Icons.arrow_back, color: Colors.white),
      //       onPressed: () {
      //         Navigator.pop(context);
      //       },
      //     ),
      //   title: Text('ADD TOUR', style: TextStyle(
      //           // fontSize: MediaQuery.of(context).size.width * 0.02,
      //           color: Colors.white),), backgroundColor: Colors.transparent),
      body: Container(
        // color: Colors.white,
        child: Column(
          children: [
            const SizedBox(height: 60),
            Row(
              children: [
                IconButton(
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
                const SizedBox(width: 10),
                Text('ADD TOUR',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white)
                )
              ],
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(numberOfDays, (index) {
                  bool isDisabled = unselectableDays.contains(index + 1);

                  return GestureDetector(
                    onTap: isDisabled
                        ? null
                        : () => setState(() => _tabController.index = index),
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                      margin: EdgeInsets.only(
                          left: 4, right: 4, top: 12, bottom: 6),
                      decoration: BoxDecoration(
                        color: isDisabled
                            ? Colors.grey // Grey out the unselectable days
                            : (_tabController.index == index
                                ? Colors.white
                                : Colors.grey.shade200),
                        border: Border.all(color: Colors.blue),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        "Day ${index + 1}",
                        style: TextStyle(
                          color: isDisabled ? Colors.white54 : Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                physics: NeverScrollableScrollPhysics(),
                children: List.generate(numberOfDays, (index) {
                  List<Map<String, dynamic>> toursForDay = selectedTours
                      .where((tour) => tour['day'] == index + 1)
                      .toList();

                  return SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          ...toursForDay.map((tourForDay) => Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 12),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(15),
                                ),
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
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return Image.asset(
                                            "img/splashLogo.png",
                                            height: 150,
                                            width: double.infinity,
                                            fit: BoxFit.contain,
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
                                        color: Colors.black,
                                      ),
                                    ),
                                    Text(
                                      tourForDay['city_name'] ?? '',
                                      style: const TextStyle(
                                          fontSize: 14, color: Colors.black),
                                    ),
                                    Text(
                                      "Vendor: ${tourForDay['vendor_name'] ?? ''}",
                                      style: const TextStyle(
                                          fontSize: 14, color: Colors.black54),
                                    ),
                                    Text(
                                      "Duration: ${tourForDay['duration'] ?? ''}",
                                      style: const TextStyle(
                                          fontSize: 14, color: Colors.black),
                                    ),
                                    Text(
                                      "Timings: ${tourForDay['timings'] ?? ''}",
                                      style: const TextStyle(
                                          fontSize: 14, color: Colors.black87),
                                    ),
                                    const SizedBox(height: 5),
                                    StatefulBuilder(
                                      builder: (context, setInnerState) {
                                        bool expanded = isExpanded[index] ?? false;
                                        String inclusion = tourForDay['inclusion'] ?? '';
                                        int maxLength = 100;

                                        // Convert HTML to plain text
                                        String plainText = _htmlToPlainText(inclusion);

                                        return Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            // Text widget to show truncated plain text for read more functionality
                                            Text(
                                              expanded
                                                  ? plainText
                                                  : (plainText.length > maxLength
                                                  ? plainText.substring(0, maxLength) + "..."
                                                  : plainText),
                                              style: const TextStyle(fontSize: 12, color: Colors.black),
                                              textAlign: TextAlign.justify,
                                            ),

                                            // "Read More" / "Read Less" toggle functionality
                                            if (plainText.length > maxLength)
                                              GestureDetector(
                                                onTap: () {
                                                  setInnerState(() {
                                                    isExpanded[index] = !expanded;
                                                  });
                                                },
                                                child: Text(
                                                  expanded ? "Read Less" : "Read More",
                                                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                                                  textAlign: TextAlign.justify,
                                                ),
                                              ),
                                          ],
                                        );
                                      },
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "AED ${tourForDay['totalAmount'] ?? ''}/Person",
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.red,
                                          ),
                                        ),
                                        tourForDay['fixed_tour'] == "No"
                                            ? ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Color(0xFF0071BC)),
                                                onPressed: () =>
                                                    _removeSelectedTour(
                                                        index,
                                                        tourForDay[
                                                            'activity_id']),
                                                child: AppText(
                                                    text: 'Remove',
                                                    color: Colors.white),
                                              )
                                            : const SizedBox(height: 0),
                                      ],
                                    ),
                                  ],
                                ),
                              )),
                          SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 50),
                            child: ElevatedButton(
                              onPressed: () => _openTourSelectionModal(index),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF0071BC),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: EdgeInsets.symmetric(vertical: 16),
                                minimumSize: Size(
                                    double.infinity, 50), // Full width button
                              ),
                              child: Text(
                                "Add Tour +",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
          padding: EdgeInsets.only(bottom: 24.0, left: 20, right: 20),
          child: GestureDetector(
            onTap: () {
              activityList = _generateActivityList();
              print('#####################################################');
              print(destination);
              print(activityList);
              print(totalMinutesPerDay);
              print(unselectableDays);
              print('#####################################################');
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => BookingSummaryFD(
                        packageDetails: widget.packageDetails,
                        selectedHotel: widget.selectedHotel,
                        flightDetails: widget.flightDetails,
                        totalRoomsdata: widget.totalRoomsdata,
                        searchId: widget.searchId,
                        activityList: activityList,
                        destination: destination,
                        isReturnConnecting: widget.isReturnConnecting,
                        isOnwardConnecting: widget.isOnwardConnecting,
                    )),
              );
            },
            child: responciveButton(
                text: selectedTours.isEmpty ? 'Skip' : 'Book Now', color: Colors.red,),
          )),
    ),
    );
  }
}
