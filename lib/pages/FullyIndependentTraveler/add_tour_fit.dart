import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:HolidayMakers/pages/FullyIndependentTraveler/booking_summary_fit.dart';
import 'package:HolidayMakers/pages/FullyIndependentTraveler/tour_selection_modal_fit.dart';
import 'package:HolidayMakers/utils/api_handler.dart';
import 'package:HolidayMakers/widgets/appText.dart';
import 'package:HolidayMakers/widgets/responciveButton.dart';
import 'package:fluttertoast/fluttertoast.dart';

class TourBookingPageFIT extends StatefulWidget {
  // final Map<String, dynamic> packageDetails;
  // final Map<String, dynamic> selectedHotel;
  // final List<Map<String, dynamic>> flightDetails;
  final String numberOfNights;
  final List<dynamic> totalRoomsdata;
  final String searchId;

  const TourBookingPageFIT(
      {super.key,
      // required this.packageDetails,
      // required this.selectedHotel,
      // required this.flightDetails,
      required this.numberOfNights,
      required this.totalRoomsdata,
      required this.searchId});

  @override
  _TourBookingPageFITState createState() => _TourBookingPageFITState();
}

class _TourBookingPageFITState extends State<TourBookingPageFIT>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Map<String, dynamic>> selectedTours = [];
  List<Map<String, dynamic>> allTours = [];
  int numberOfDays = 1;
  Map<int, bool> isExpanded = {};
  String destination = "";
  List<Map<String, dynamic>> activityList = [];
  Map<int, int> totalMinutesPerDay = {};

  @override
  void initState() {
    super.initState();
    List<String> parts = widget.numberOfNights.split(" ");
    // String daysPart = parts[1].trim(); // "5 Days"
    numberOfDays = int.parse(parts[0]) + 1; // Extracting only the number

    // numberOfDays = int.parse(widget.numberOfNights) + 1;
    _fetchFITTourList();
    // print(widget.packageDetails['duration']);

    _tabController = TabController(length: numberOfDays, vsync: this);
    // Add listener to update the UI when tab changes
    _tabController.addListener(() {
      // ignore: unnecessary_null_comparison
      if (_tabController.indexIsChanging || _tabController.index != null) {
        setState(() {});
      }
    });
  }

  Future<void> _fetchFITTourList() async {
    try {
      // final response = await APIHandler.getFITTourList(widget.searchId ?? "");
      final response = await APIHandler.getFITTourList(widget.searchId);
      setState(() {
        allTours =
            List<Map<String, dynamic>>.from(response['data']['activity'] ?? []);
        destination = response['data']['destination'] ?? "";
      });
    } catch (e) {
      print("Error fetching package cards: $e");
    }
  }

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
  //       return TourSelectionModalFIT(
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

  void _openTourSelectionModal(int dayIndex) {
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

        return TourSelectionModalFIT(
          tours: availableTours,
          onSelectionChanged: (selectedTour) {
            int newTourDurationMinutes =
                _extractDurationInMinutes(selectedTour['duration']);
            int currentTotalMinutes = totalMinutesPerDay[dayIndex + 1] ??
                0; // Day index is 0-based, but our days start from 1

            if (currentTotalMinutes + newTourDurationMinutes > 480) {
              Fluttertoast.showToast(
                  msg: "Cannot add more than 8 hours of tours per day.");// 8 hours = 480 minutes
              
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
          },
        );
      },
    );
  }

  // void _removeSelectedTour(int dayIndex) {
  //   setState(() {
  //     selectedTours.removeWhere((tour) => tour['day'] == dayIndex + 1);
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

        // Subtract tour duration from total minutes
        totalMinutesPerDay[dayIndex + 1] =
            (totalMinutesPerDay[dayIndex + 1] ?? 0) -
                removedTourDurationMinutes;

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
      };
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('img/departureDealsBG.png'), fit: BoxFit.fill)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: Text(
              'ADD TOUR',
              style: TextStyle(
                  // fontSize: MediaQuery.of(context).size.width * 0.02,
                  color: Colors.white),
            ),
            backgroundColor: Colors.transparent),
        body: Container(
          child: Column(
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(numberOfDays, (index) {
                    return GestureDetector(
                      onTap: () => setState(() => _tabController.index = index),
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                        // margin: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                        margin: EdgeInsets.only(
                            left: 4, right: 4, top: 12, bottom: 6),
                        decoration: BoxDecoration(
                          color: _tabController.index == index
                              ? Colors.white
                              : Colors.grey.shade300,
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Image.network(
                                            tourForDay['images'] ?? "",
                                            height: 150,
                                            width: double.infinity,
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (context, error, stackTrace) {
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
                                              fontSize: 14,
                                              color: Colors.black45),
                                        ),
                                        Text(
                                          "Vendor: ${tourForDay['vendor_name'] ?? ''}",
                                          style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.black54),
                                        ),
                                        Text(
                                          "Duration: ${tourForDay['duration'] ?? ''}",
                                          style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.black54),
                                        ),
                                        Text(
                                          "Timings: ${tourForDay['timings'] ?? ''}",
                                          style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.black),
                                        ),
                                        Text(
                                          "Tour Category: ${tourForDay['tour_category'] ?? ''}",
                                          style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.black54),
                                        ),
                                        // const SizedBox(height: 5),
                                        // Inclusion with Read More Feature
                                        StatefulBuilder(
                                          builder: (context, setInnerState) {
                                            bool expanded =
                                                isExpanded[index] ?? false;
                                            String inclusion =
                                                tourForDay['inclusion'] ?? '';
                                            int maxLength = 100;

                                            return Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Html(
                                                  data: expanded
                                                      ? inclusion
                                                      : (inclusion.length >
                                                              maxLength
                                                          ? inclusion.substring(
                                                                  0,
                                                                  maxLength) +
                                                              "..."
                                                          : inclusion),
                                                  style: {
                                                    "body": Style(
                                                      fontSize: FontSize(14),
                                                      color: Colors.black,
                                                      textAlign:
                                                          TextAlign.justify,
                                                      margin: Margins.zero,
                                                      padding:
                                                          HtmlPaddings.zero,
                                                    ),
                                                  },
                                                ),
                                                if (inclusion.length >
                                                    maxLength)
                                                  GestureDetector(
                                                    onTap: () {
                                                      setInnerState(() {
                                                        isExpanded[index] =
                                                            !expanded;
                                                      });
                                                    },
                                                    child: Text(
                                                      expanded
                                                          ? "Read Less"
                                                          : "Read More",
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                      textAlign:
                                                          TextAlign.justify,
                                                    ),
                                                  ),
                                              ],
                                            );
                                          },
                                        ),
                                        // const SizedBox(height: 5),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              (tourForDay['totalmembers'] ==
                                                          null ||
                                                      tourForDay[
                                                              'totalmembers'] ==
                                                          0 ||
                                                      tourForDay[
                                                              'Per_totalAmount'] ==
                                                          null ||
                                                      tourForDay[
                                                              'Per_totalAmount'] ==
                                                          0)
                                                  ? "AED ${tourForDay['Per_totalAmount'] ?? 0} per person"
                                                  : "AED ${(tourForDay['totalmembers'] ?? 1) * (tourForDay['Per_totalAmount'] ?? 0)}",
                                              style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.red,
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                          backgroundColor:
                                                              Color(
                                                                  0xFF0071BC)),
                                                  onPressed: () =>
                                                      _removeSelectedTour(
                                                          index,
                                                          tourForDay[
                                                              'activity_id']),
                                                  child: AppText(
                                                    text: 'Remove',
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  )),
                              SizedBox(height: 10),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 50),
                                child: ElevatedButton(
                                  onPressed: () =>
                                      _openTourSelectionModal(index),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFF0071BC),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    padding: EdgeInsets.symmetric(vertical: 16),
                                    minimumSize: Size(double.infinity,
                                        50), // Full width button
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
                          )),
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
              print('#####################################################');
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BookingSummaryFIT(
                      // flightDetails: widget.flightDetails,
                      // selectedHotel: widget.selectedHotel,
                      // packageDetails: widget.packageDetails,
                      roomArray: widget.totalRoomsdata,
                      searchId: widget.searchId,
                      activityList: activityList,
                      destination: destination),
                ),
              );
            },
            child: responciveButton(
              text: selectedTours.isEmpty ? 'Skip' : 'Book Now',
              color: Colors.red,
            ),
          ),
        ),
      ),
    );
  }
}
