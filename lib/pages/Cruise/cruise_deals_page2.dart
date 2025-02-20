import 'package:flutter/material.dart';
import 'package:holdidaymakers/pages/Cruise/booking_summary.dart';
import 'package:holdidaymakers/pages/Cruise/pax_details.dart';
import 'package:holdidaymakers/utils/api_handler.dart';
import 'package:holdidaymakers/widgets/dropdownwidget.dart';
import 'package:holdidaymakers/widgets/responciveButton.dart';

class CruiseDealsPage2 extends StatefulWidget {
  final Map<String, dynamic>? selectedCruiseData;
  const CruiseDealsPage2({super.key, required this.selectedCruiseData});

  @override
  _CruiseDealsPage2State createState() => _CruiseDealsPage2State();
}

class _CruiseDealsPage2State extends State<CruiseDealsPage2> {
  List<Map<String, String>> cruiseCabins = [];
  Map<String, String>? selectedCabin;
  String? selectedRoom = "1";
  String? totalPaxCount = "2";
  List<String>? paxAges = ["21", "21"];

  List<dynamic> totalRoomsdata = [
    {
      "paxCount": 2,
      "paxAges": [21, 21]
    }
  ];

  String? cabinError;

  @override
  void initState() {
    super.initState();
    _fetchCruiseCards();
  }

  Future<void> _fetchCruiseCards() async {
    try {
      final response = await APIHandler.getCruiseCabin(
        depDate: widget.selectedCruiseData?['dep_date'] ?? "",
        cruiseId: widget.selectedCruiseData?['cruise_id'] ?? "",
      );

      if (response.isEmpty || response['data'] == null) {
        throw Exception("No data found");
      }

      final List<dynamic> cabinList = response['data'];
      if (cabinList.isEmpty) {
        throw Exception("No cruise cabins available");
      }

      if (!mounted) return;

      setState(() {
        cruiseCabins = cabinList.map((item) {
          return {
            'origin': (item['origin'] ?? "N/A").toString(),
            'cabin_type': (item['cabin_type'] ?? "Unknown").toString(),
            'is_selected': (item['is_selected'] ?? "0").toString(),
          };
        }).toList();

        selectedCabin = null; // No default selection
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        cruiseCabins = [];
        selectedCabin = null;
      });

      print("Error fetching cruise cabins: $e");
    }
  }

  void _validateAndProceed() {
    setState(() {
      cabinError = selectedCabin == null ? "Please select a cabin type" : null;
    });

    if (selectedCabin != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BookingSummaryPage(
            selectedCabin: selectedCabin!,
            selectedCruiseData: widget.selectedCruiseData!,
            totalRoomsdata: totalRoomsdata,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Text('Select Travelers',
                  style: const TextStyle(fontSize: 20, color: Colors.black)),
              PaxDetails(
                onSelectionChanged: (Map<String, dynamic> selection) {
                  setState(() {
                    selectedRoom = selection['totalRooms']?.toString() ?? "1";
                    totalPaxCount = selection['totalPaxCount']?.toString() ?? "2";
                    paxAges = selection['paxAges'] ?? ["21", "21"];

                    totalRoomsdata = selection["totalData"] ?? [
                      {
                        "paxCount": 2,
                        "paxAges": [21, 21]
                      }
                    ];
                  });
                },
              ),
              const SizedBox(height: 20),
              Dropdownwidget(
                selectedValue: selectedCabin?['cabin_type'],
                items: cruiseCabins.map((item) => {
                  'id': item['cabin_type']!,
                  'name': item['cabin_type']!,
                }).toList(),
                hintText: 'Choose a cabin type',
                onChanged: (String? newValue) {
                  setState(() {
                    selectedCabin = cruiseCabins.firstWhere(
                          (item) => item['cabin_type'] == newValue,
                      orElse: () => {'origin': "N/A", 'cabin_type': "Unknown", 'is_selected': "0"},
                    );
                    cabinError = null; // Clear error
                  });
                },
              ),
              if (cabinError != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    cabinError!,
                    style: const TextStyle(color: Colors.red, fontSize: 14),
                  ),
                ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          width: double.infinity,
          child: IconButton(
            onPressed: _validateAndProceed,
            icon: responciveButton(text: 'SELECT'),
          ),
        ),
      ),
    );
  }
}
