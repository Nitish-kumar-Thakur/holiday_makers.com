import 'package:flutter/material.dart';
import 'package:holdidaymakers/pages/Cruise/booking_summary.dart';
import 'package:holdidaymakers/pages/Cruise/pax_details.dart';
import 'package:holdidaymakers/utils/api_handler.dart';
import 'package:holdidaymakers/widgets/dropdownwidget.dart';
import 'package:holdidaymakers/widgets/responciveButton.dart';

class CruiseDealsPage2 extends StatefulWidget {
  const CruiseDealsPage2({super.key});

  @override
  _CruiseDealsPage2State createState() => _CruiseDealsPage2State();
}

class _CruiseDealsPage2State extends State<CruiseDealsPage2> {
  List<Map<String, String>> cruiseCabins = [];
  String? selectedCabin;

  @override
  void initState() {
    super.initState();
    _fetchCruiseCards();
  }

  Future<void> _fetchCruiseCards() async {
    final response = await APIHandler.getCruiseCabin();
    setState(() {
      cruiseCabins = (response['data'] as List<dynamic>).map((item) {
        return {
          'origin': item['origin'].toString(), // Unique ID
          'cabin_type': item['cabin_type'].toString(), // Display name & selected value
          'status': item['status'].toString(), // Status if needed
        };
      }).toList();
    });
    print(cruiseCabins);
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
              Text('Select Travelers', style: const TextStyle(fontSize: 20, color: Colors.black)),
              PaxDetails(),
              const SizedBox(height: 20),
              Dropdownwidget(
                selectedValue: selectedCabin,
                items: cruiseCabins.map((item) {
                  return {
                    'id': item['cabin_type']!, // Now 'cabin_type' is used as the value
                    'name': item['cabin_type']!, // Display 'cabin_type' in dropdown
                  };
                }).toList(),
                hintText: 'Choose a cabin type',
                onChanged: (String? newValue) {
                  setState(() {
                    selectedCabin = newValue;
                  });
                },
              ),
              const SizedBox(height: 20),
              Text(
                selectedCabin != null
                    ? '$selectedCabin' // Directly show selected cabin_type
                    : 'No cabin selected',
                style: const TextStyle(fontSize: 25, color: Colors.black),
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
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => BookingSummaryPage()),
              );
            },
            icon: responciveButton(text: 'SELECT'),
          ),
        ),
      ),
    );
  }
}
