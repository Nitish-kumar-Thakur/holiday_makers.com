import 'package:flutter/material.dart';
import 'package:holdidaymakers/pages/mainPage.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final List<String> places = [
    "New Delhi",
    "Mumbai",
    "Bangalore",
    "Hyderabad",
    "Chennai",
    "Kolkata",
    "Pune",
    "Goa",
    "Jaipur",
    "Ahmedabad",
  ];

  List<String> filteredPlaces = [];
  TextEditingController searchController = TextEditingController();
  bool isSearching = false;

  @override
  void initState() {
    super.initState();
    filteredPlaces = List.from(places);
  }

  void filterSearchResults(String query) {
    if (query.isEmpty) {
      setState(() {
        filteredPlaces = List.from(places);
      });
    } else {
      setState(() {
        filteredPlaces = places
            .where((place) => place.toLowerCase().contains(query.toLowerCase()))
            .toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
            setState(() {
              isSearching = false;
              searchController.clear();
              filteredPlaces = List.from(places);
            });
          },
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: searchController,
                onChanged: (query) {
                  setState(() {
                    isSearching = query.isNotEmpty;
                  });
                  filterSearchResults(query);
                },
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: isSearching
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            setState(() {
                              searchController.clear();
                              filteredPlaces = List.from(places);
                              isSearching = false;
                            });
                          },
                        )
                      : null,
                  hintText: "Search...",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            Expanded(
              child: filteredPlaces.isNotEmpty
                  ? ListView.builder(
                      itemCount: filteredPlaces.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: const Icon(Icons.location_on),
                          title: Text(filteredPlaces[index]),
                          onTap: () {
                            setState(() {
                              searchController.text = filteredPlaces[index];
                              isSearching = false;
                            });
                          },
                        );
                      },
                    )
                  : const Center(
                      child: Text(
                        "No results found",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
