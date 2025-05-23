import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class APIHandler {
  static const String loginUrl =
      'https://holidaymakers.com/holiday_api';
  static const String signupUrl =
      "https://holidaymakers.com/holiday_api/";
  static const String homeUrl =
      'https://holidaymakers.com/holiday_api';
  static const String forgotPasswordUrl =
      'https://holidaymakers.com/holiday_api/forgot_password';
  static const String baseUrl =
      "https://holidaymakers.com/holiday_api/get_category_wise_package_list";
  static const String sourceUrl =
      "https://holidaymakers.com/holiday_api/source_list";
  static const String destUrl =
      "https://holidaymakers.com/holiday_api/destination_list";
  static const String fitSearchUrl =
      "https://holidaymakers.com/holiday_api/fit_package_search";

  static Future<Map<String, String>> _ProfileDetails() async {
    final prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString("user_id") ?? "";
    String token = prefs.getString("token") ?? "";
    return {"userId": userId, "token": token};
  }

  static Future<Map<String, dynamic>> login(
      String email, String password) async {
    final url = Uri.parse('$loginUrl/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Error: ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>> registerUser({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String countryCode,
    required String phone,
  }) async {
    final url = Uri.parse('${signupUrl}registration');

    final body = jsonEncode({
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'password': password,
      'country_code': countryCode,
      'phone': phone,
    });

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Registration failed: ${response.body}');
    }
  }

  static Future<Map<String, dynamic>> HomePageData() async {
    final String url = '$homeUrl/home';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load homepage data');
      }
    } catch (e) {
      throw Exception('Error fetching data: $e');
    }
  }

  static Future<Map<String, dynamic>> forgotPassword(String email) async {
    final url = Uri.parse(forgotPasswordUrl);
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Error: ${response.statusCode}');
    }
  }

  static Future<Map<String, dynamic>> getPackagesData() async {
    try {
      final response = await http.get(Uri.parse("$baseUrl"));
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception("Failed to load homepage data");
      }
    } catch (e) {
      print("API Error: $e");
      throw Exception("Error fetching data");
    }
  }

  static Future<List<Map<String, String>>> fetchSourceList() async {
    try {
      final response = await http.get(Uri.parse(sourceUrl));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Extracting relevant data from the API response
        if (data['status'] == true) {
          List<Map<String, String>> sourceList = [];
          for (var item in data['data']) {
            sourceList.add({
              'id': item['from_city_id'],
              'name': item['from_city_name'],
            });
          }
          return sourceList;
        } else {
          throw Exception('Failed to load source list');
        }
      } else {
        throw Exception('Failed to load source list');
      }
    } catch (error) {
      throw Exception('Error fetching source list: $error');
    }
  }

  /// Fetch Categories

  static Future<List<Map<String, String>>> fetchDestinationList(
      String sourceId) async {
    try {
      final response = await http.post(
        Uri.parse(destUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'source_id': sourceId,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Extracting relevant data from the API response
        if (data['status'] == true) {
          List<Map<String, String>> sourceList = [];
          for (var item in data['data']) {
            sourceList.add({
              'id': item['to_city_id'],
              'name': item['to_city_name'],
            });
          }
          return sourceList;
        } else {
          throw Exception('Failed to load source list');
        }
      } else {
        throw Exception('Failed to load source list');
      }
    } catch (error) {
      throw Exception('Error fetching source list: $error');
    }
  }

  static Future<Map<String, dynamic>> fitSearch(
      {required String sourceId,
      required String destinationId,
      required String travelDate,
      required String noOfNights,
      required String rooms,
      required String adults,
      required String children,
      required List<dynamic> childrenAge}) async {
    final url = Uri.parse(fitSearchUrl);
    final body = jsonEncode({
      "source_id": sourceId,
      "destination_id": destinationId,
      "travel_date": travelDate,
      "no_of_nights": noOfNights,
      "rooms": rooms,
      "room_wise_pax": childrenAge
    });

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: body,
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Error: ${response.statusCode}');
    }
  }

  static Future<Map<String, List<Map<String, String>>>>
      fetchCruiseCountryMonthList(String sourceId) async {
    try {
      final response = await http.post(
        Uri.parse(
            "https://holidaymakers.com/holiday_api/get_cruise_country_month_list"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'source_id': sourceId}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['status'] == true) {
          // Extracting country_list
          final countryList = (data['data']['country_list'] as List<dynamic>)
              .map<Map<String, String>>((item) => {
                    'id': item['country_id'] ?? '',
                    'name': item['country_name'] ?? '',
                  })
              .toList();

          // Extracting month_list
          final monthList = (data['data']['month_list'] as List<dynamic>)
              .map<Map<String, String>>((month) => {
                    'id': month.toString(),
                    'name': month.toString(),
                  })
              .toList();

          return {
            'countryList': countryList,
            'monthList': monthList,
          };
        } else {
          throw Exception('API returned status: false');
        }
      } else {
        throw Exception(
            'Failed to fetch data. Status code: ${response.statusCode}, Response: ${response.body}');
      }
    } catch (error) {
      throw Exception('Error fetching cruise country and month list: $error');
    }
  }

  static Future<Map<String, List<Map<String, String>>>> fetchFDCountryMonthList(
      String sourceId) async {
    try {
      final response = await http.post(
        Uri.parse(
            'https://holidaymakers.com/holiday_api/get_package_country_month_list'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'source_id': sourceId}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['status'] == true) {
          // Extracting country_list
          final countryList = (data['data']['country_list'] as List<dynamic>)
              .map<Map<String, String>>((item) => {
                    'id': item['country_id'] ?? '',
                    'name': item['country_name'] ?? '',
                  })
              .toList();

          // Extracting month_list
          final monthList = (data['data']['month_list'] as List<dynamic>)
              .map<Map<String, String>>((month) => {
                    'id': month.toString(),
                    'name': month.toString(),
                  })
              .toList();

          return {
            'countryList': countryList,
            'monthList': monthList,
          };
        } else {
          throw Exception('API returned status: false');
        }
      } else {
        throw Exception(
            'Failed to fetch data. Status code: ${response.statusCode}, Response: ${response.body}');
      }
    } catch (error) {
      throw Exception(
          'Error fetching fixed departures country and month list: $error');
    }
  }

  static Future<Map<String, dynamic>> getNewPackagesData(
      String package, String country, String month) async {
    try {
      final Uri url = Uri.parse(
          'https://holidaymakers.com/holiday_api/get_package_list');

      final Map<String, dynamic> requestBody = {
        "type": package,
        "country_id": country, //country
        "month": month //month
      };

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode != 200) {
        throw Exception("Server error: ${response.statusCode}");
      }

      final Map<String, dynamic> data = jsonDecode(response.body);

      if (data["status"] == true && data.containsKey("data")) {
        return data;
      } else {
        return {
          "status": false,
          "message": "No packages found",
          "data": {"package_list": []}
        };
      }
    } catch (e) {
      return {
        "status": false,
        "message": "Error fetching data",
        "data": {"package_list": []}
      };
    }
  }

  static Future<Map<String, dynamic>> fitBookingSummary(
      Map<String, dynamic> bookingApiData) async {
    final url = Uri.parse(
        "https://holidaymakers.com/holiday_api/fit_booking_summary");
    final body = jsonEncode(bookingApiData);

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: body,
    );

    if (response.statusCode == 200) {
      print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
      print(jsonDecode(response.body));
      print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
      return jsonDecode(response.body);
    } else {
      throw Exception('Error: ${response.statusCode}');
    }
  }

  static Future<Map<String, dynamic>> fitUpdateHotel(
      Map<String, dynamic> fitUpdateHotelData) async {
    final url = Uri.parse(
        "https://holidaymakers.com/holiday_api/fit_update_hotel");
    final body = jsonEncode(fitUpdateHotelData);

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: body,
    );

    if (response.statusCode == 200) {
      // print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
      // print(jsonDecode(response.body));
      // print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
      return jsonDecode(response.body);
    } else {
      throw Exception('Error: ${response.statusCode}');
    }
  }

  static Future<Map<String, dynamic>> fitUpdateFlight(
      Map<String, dynamic> fitUpdateFlightData) async {
    final url = Uri.parse(
        "https://holidaymakers.com/holiday_api/fit_update_flight");
    final body = jsonEncode(fitUpdateFlightData);

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: body,
    );

    if (response.statusCode == 200) {
      // print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
      // print(jsonDecode(response.body));
      // print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
      return jsonDecode(response.body);
    } else {
      throw Exception('Error: ${response.statusCode}');
    }
  }

  static Future<Map<String, dynamic>> getDepartureDeal(String packageId) async {
    final Uri url = Uri.parse(
        'https://holidaymakers.com/holiday_api/fd_package_details');

    final Map<String, dynamic> requestBody = {
      "package_id": packageId,
    };
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        if (data["status"] == true) {
          return data["data"]; // Return full package details
        } else {
          return {
            "status": false,
            "message": "No package details found",
            "data": {}
          };
        }
      } else {
        throw Exception("Server error: ${response.statusCode}");
      }
    } catch (e) {
      return {
        "status": false,
        "message": "Error fetching package details",
        "data": {}
      };
    }
  }

  static Future<Map<String, dynamic>> getCruiseDeal(String packageId) async {
    final Uri url = Uri.parse(
        'https://holidaymakers.com/holiday_api/cruise_details');

    final Map<String, dynamic> requestBody = {
      "package_id": packageId,
    };
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        if (data["status"] == true) {
          return data["data"]; // Return full package details
        } else {
          return {
            "status": false,
            "message": "No package details found",
            "data": {}
          };
        }
      } else {
        throw Exception("Server error: ${response.statusCode}");
      }
    } catch (e) {
      return {
        "status": false,
        "message": "Error fetching package details",
        "data": {}
      };
    }
  }

  static Future<Map<String, dynamic>> getCruiseCards(String cruiseId) async {
    final Uri url = Uri.parse(
        'https://holidaymakers.com/holiday_api/get_departure_and_similar_cruise');
    final Map<String, dynamic> requestBody = {"cruise_id": cruiseId};
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        if (data["status"] == true) {
          return data; // Return full package details
        } else {
          return {
            "status": false,
            "message": "No package details found",
            "data": {}
          };
        }
      } else {
        throw Exception("Server error: ${response.statusCode}");
      }
    } catch (e) {
      return {
        "status": false,
        "message": "Error fetching package details",
        "data": {}
      };
    }
  }

  static Future<Map<String, dynamic>> getCruiseCabin({
    required String depDate,
    required String cruiseId,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(
            "https://holidaymakers.com/holiday_api/cruise_cabin_type"),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "dep_date": depDate,
          "cruise_id": cruiseId,
        }),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception("Failed to load cruise cabin data");
      }
    } catch (e) {
      print("API Error: $e");
      throw Exception("Error fetching data");
    }
  }

  static Future<Map<String, dynamic>> getFDCards(String packageId) async {
    final Uri url = Uri.parse(
        'https://holidaymakers.com/holiday_api/get_departure_and_similar_package');
    final Map<String, dynamic> requestBody = {"package_id": packageId};
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        if (data["status"] == true) {
          return data;
        } else {
          return {
            "status": false,
            "message": "No package details found",
            "data": {}
          };
        }
      } else {
        throw Exception("Server error: ${response.statusCode}");
      }
    } catch (e) {
      return {
        "status": false,
        "message": "Error fetching package details",
        "data": {}
      };
    }
  }

  static Future<Map<String, dynamic>> getFDHotelFlightDetails(
      String packageId) async {
    final Uri url = Uri.parse(
        'https://holidaymakers.com/holiday_api/fd_package_flight_hotel_details');
    final Map<String, dynamic> requestBody = {"package_id": packageId};
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        if (data["status"] == true) {
          return data;
        } else {
          return {
            "status": false,
            "message": "No package details found",
            "data": {}
          };
        }
      } else {
        throw Exception("Server error: ${response.statusCode}");
      }
    } catch (e) {
      return {
        "status": false,
        "message": "Error fetching package details",
        "data": {}
      };
    }
  }

  static Future<Map<String, dynamic>> getCruiseBSDetails({
    required Map<String, dynamic> requestBody,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(
            "https://holidaymakers.com/holiday_api/cruise_booking_summary"),
        headers: {"Content-Type": "application/json"},
        body: json.encode(requestBody),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception("Failed to load cruise booking summary details");
      }
    } catch (e) {
      print("API Error: $e");
      throw Exception("Error fetching booking summary data");
    }
  }

  static Future<Map<String, dynamic>> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    final String url =
        "https://holidaymakers.com/holiday_api/change_password";

    // Await the _ProfileDetails() method to get the values
    Map<String, String> profileDetails = await _ProfileDetails();
    String userId = profileDetails['userId'] ?? "";
    String token = profileDetails['token'] ?? "";
    print("&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&");
    print(userId);
    print(token);
    print("&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&");

    final Map<String, String> headers = {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json",
    };

    final Map<String, dynamic> body = {
      "user_id": userId,
      "old_password": oldPassword,
      "new_password": newPassword
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(body),
      );

      final Map<String, dynamic> responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return responseData; // Success response
      } else {
        return {
          "status": "error",
          "message": responseData["message"] ?? "Password change failed",
        };
      }
    } catch (e) {
      return {
        "status": "error",
        "message": "An error occurred: $e",
      };
    }
  }

  static Future<Map<String, dynamic>> getFDHotelDetails(
      Map<dynamic, dynamic> body) async {
    final Uri url = Uri.parse(
        'https://holidaymakers.com/holiday_api/fd_package_hotel_details');
    // final Map<String, dynamic> requestBody = {"package_id": body};
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        if (data["status"] == true) {
          return data;
        } else {
          return {
            "status": false,
            "message": "No package details found",
            "data": {}
          };
        }
      } else {
        throw Exception("Server error: ${response.statusCode}");
      }
    } catch (e) {
      return {
        "status": false,
        "message": "Error fetching package details",
        "data": {}
      };
    }
  }

  static Future<Map<String, dynamic>> getFDFlightDetails(
      Map<dynamic, dynamic> body) async {
    final Uri url = Uri.parse(
        'https://holidaymakers.com/holiday_api/fd_update_hotel');
    // final Map<String, dynamic> requestBody = {"search_id": searchId, "hotel_id": hotelId};
    // final Map<String, dynamic> requestBody = {"search_id": "3649", "hotel_id": "380"};
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        if (data["status"] == true) {
          return data;
        } else {
          return {
            "status": false,
            "message": "No package details found",
            "data": {}
          };
        }
      } else {
        throw Exception("Server error: ${response.statusCode}");
      }
    } catch (e) {
      return {
        "status": false,
        "message": "Error fetching package details",
        "data": {}
      };
    }
  }

  static Future<Map<String, dynamic>> updateFlightDetails(
      Map<dynamic, dynamic> body) async {
    final Uri url = Uri.parse(
        'https://holidaymakers.com/holiday_api/fd_update_flight');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        if (data["status"] == true) {
          return data;
        } else {
          return {
            "status": false,
            "message": "Failed to update flight",
            "data": {}
          };
        }
      } else {
        throw Exception("Server error: ${response.statusCode}");
      }
    } catch (e) {
      return {"status": false, "message": "Error updating flight", "data": {}};
    }
  }

  static Future<Map<String, dynamic>> getFDBSDetails(
      Map<dynamic, dynamic> temp) async {
    final Uri url = Uri.parse(
        'https://holidaymakers.com/holiday_api/fd_booking_summary');
    // final Map<String, dynamic> requestBody = {temp};
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(temp),
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        if (data["status"] == true) {
          return data;
        } else {
          return {
            "status": false,
            "message": "No package details found",
            "data": {}
          };
        }
      } else {
        throw Exception("Server error: ${response.statusCode}");
      }
    } catch (e) {
      return {
        "status": false,
        "message": "Error fetching package details",
        "data": {}
      };
    }
  }

  static Future<Map<String, dynamic>> getCountryList() async {
    try {
      final response = await http.get(Uri.parse(
          'https://holidaymakers.com/holiday_api/country_list'));
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception("Failed to load country list...");
      }
    } catch (e) {
      print("API Error: $e");
      throw Exception("Error fetching country list");
    }
  }

  static Future<Map<String, dynamic>> getCity(String country_id) async {
    final Uri url = Uri.parse(
        'https://holidaymakers.com/holiday_api/city_list_by_country');
    final Map<String, dynamic> requestBody = {"country_id": country_id};
    // final Map<String, dynamic> requestBody = {"search_id": '3649'};
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        if (data["status"] == true) {
          return data;
        } else {
          return {
            "status": false,
            "message": "No package details found",
            "data": {}
          };
        }
      } else {
        throw Exception("Server error: ${response.statusCode}");
      }
    } catch (e) {
      return {
        "status": false,
        "message": "Error fetching package details",
        "data": {}
      };
    }
  }

  static Future<Map<String, dynamic>> getFDTourList(String searchId) async {
    final Uri url = Uri.parse(
        'https://holidaymakers.com/holiday_api/fd_tour_list');
    final Map<String, dynamic> requestBody = {"search_id": searchId};
    // final Map<String, dynamic> requestBody = {"search_id": '3649'};
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        if (data["status"] == true) {
          return data;
        } else {
          return {
            "status": false,
            "message": "No tour details found",
            "data": {}
          };
        }
      } else {
        throw Exception("Server error: ${response.statusCode}");
      }
    } catch (e) {
      return {
        "status": false,
        "message": "Error fetching tour details",
        "data": {}
      };
    }
  }

  static Future<Map<String, dynamic>> getFITTourList(String searchId) async {
    final Uri url = Uri.parse(
        'https://holidaymakers.com/holiday_api/fit_tour_list');
    final Map<String, dynamic> requestBody = {"search_id": searchId};
    // final Map<String, dynamic> requestBody = {"search_id": '3649'};
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        if (data["status"] == true) {
          return data;
        } else {
          return {
            "status": false,
            "message": "No tour details found",
            "data": {}
          };
        }
      } else {
        throw Exception("Server error: ${response.statusCode}");
      }
    } catch (e) {
      return {
        "status": false,
        "message": "Error fetching tour details",
        "data": {}
      };
    }
  }

  static Future<List<DateTime>> fetchBlockedDates(
      String source, String destination) async {
    final Uri url = Uri.parse(
        'https://holidaymakers.com/holiday_api/fit_block_dates');
    final Map<String, dynamic> requestBody = {
      "origin_id": source,
      "destination_id": destination
    };
    print("&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&");
    print("Blocked Body = $requestBody");
    print("&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&");
    // final Map<String, dynamic> requestBody = {"search_id": '3649'};
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print("&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&");
        print("Blocked responce = $data");
        print("&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&");

        if (data['status'] == true && data['data'] is List) {
          print("Chla to bhai");
          return (data['data'] as List)
              .map((dateString) => DateTime.parse(dateString))
              .toList();
        }
      }
    } catch (e) {
      print("Error fetching blocked dates: $e");
    }
    return [];
  }

  static Future<Map<String, dynamic>> fitInclusionList() async {
    final Uri url = Uri.parse(
        'https://holidaymakers.com/holiday_api/fit_inclusion_list');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load inclusion list');
      }
    } catch (e) {
      throw Exception('Error fetching inclusion list: $e');
    }
  }

  Future<List<dynamic>> fetchCountries() async {
    final response = await http.get(Uri.parse(
        'https://holidaymakers.com/holiday_api/country_list'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['data'];
    } else {
      throw Exception('Failed to load countries');
    }
  }

  static Future<Map<String, dynamic>> fdSaveBooking(
      Map<String, dynamic> body) async {
    final Uri url = Uri.parse(
        'https://holidaymakers.com/holiday_api/save_fd_package');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        if (data["status"] == true) {
          return data;
        } else {
          return {
            "status": false,
            "message": "No tour details found",
            "data": {}
          };
        }
      } else {
        print(response.statusCode);
        throw Exception("Server error: ${response.statusCode}");
      }
    } catch (e) {
      return {
        "status": false,
        "message": "Error fetching tour details",
        "data": {}
      };
    }
  }

  static Future<Map<String, dynamic>> fitSaveBooking(
      Map<String, dynamic> body) async {
    final Uri url = Uri.parse(
        'https://holidaymakers.com/holiday_api/save_fit_package');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        if (data["status"] == true) {
          return data;
        } else {
          return {
            "status": false,
            "message": "No tour details found",
            "data": {}
          };
        }
      } else {
        print(response.body);
        throw Exception("Server error: ${response.statusCode}");
      }
    } catch (e) {
      return {
        "status": false,
        "message": "Error fetching tour details",
        "data": {}
      };
    }
  }

  static Future<Map<String, dynamic>> cruiseSaveBooking(
      Map<String, dynamic> body) async {
    final Uri url = Uri.parse(
        'https://holidaymakers.com/holiday_api/save_cruise_package');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        if (data["status"] == true) {
          print('&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&');
          print(data);
          print('&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&');
          return data;
        } else {
          return {
            "status": false,
            "message": "No tour details found",
            "data": {}
          };
        }
      } else {
        print(response.statusCode);
        throw Exception("Server error: ${response.statusCode}");
      }
    } catch (e) {
      return {
        "status": false,
        "message": "Error fetching tour details",
        "data": {}
      };
    }
  }

  static Future<Map<String, dynamic>> validateVoucher(
      Map<String, dynamic> body) async {
    final Uri url = Uri.parse(
        'https://holidaymakers.com/holiday_api/get_voucher_code_details');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return data;
      } else {
        print(response.statusCode);
        throw Exception("Server error: ${response.statusCode}");
      }
    } catch (e) {
      return {
        "status": false,
        "message": "Error fetching voucher details",
        "data": {}
      };
    }
  }

  static Future<Map<String, dynamic>> bookingHistoryList(
      Map<String, dynamic> body) async {
    final Uri url = Uri.parse(
        'https://holidaymakers.com/holiday_api/user_booking_list');
    Map<String, String> profileDetails = await _ProfileDetails();
    String token = profileDetails['token'] ?? "";
    String testToken =
        "pEMKrNZOvFRCbht3btZQH0xrM1Pur6opG3dxp5Uft5izj8QgCdDNCTAm71I4bIU4EV084HnsMWd5YzzKrxhdoE0zvEaBhXQ62RaS";
    try {
      final response = await http.post(
        url,
        headers: {
          "Authorization": "Bearer $token",
          'Content-Type': 'application/json'
        },
        body: jsonEncode(body),
      );
      print("BookingHistoryList $response");
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        print("api respnce $data");
        return data;
      } else {
        print(response.statusCode);
        throw Exception("Server error: ${response.statusCode}");
      }
    } catch (e) {
      return {
        "status": false,
        "message": "Error fetching BookingHistoryList $e",
        "data": {}
      };
    }
  }

  static Future<Map<String, dynamic>> accountDeactivate(Map<String, dynamic> body) async {
    Map<String, String> profileDetails = await _ProfileDetails();
    String token = profileDetails['token'] ?? "";
    // print("token $token");
    final Uri url = Uri.parse('https://holidaymakers.com/holiday_api/user_status_update');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode(body),
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return data;
      } else {
        print(response.statusCode);
        throw Exception("Server error: ${response.statusCode}");
      }
    } catch (e) {
      return {
        "status": false,
        "message": "Error fetching api response",
        "data": {}
      };
    }
  }
  static Future<Map<String, dynamic>> getTestimonialList() async {
    try {
      final response = await http.get(Uri.parse(
          'https://holidaymakers.com/holiday_api/get_testimonial_list'));
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception("Failed to load Testimonial list...");
      }
    } catch (e) {
      print("API Error: $e");
      throw Exception("Error fetching Testimonial list");
    }
  }
  static Future<Map<String, dynamic>> getBlogList() async {
    try {
      final response = await http.get(Uri.parse(
          'https://holidaymakers.com/holiday_api/get_blog_list'));
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception("Failed to load Blog list...");
      }
    } catch (e) {
      print("API Error: $e");
      throw Exception("Error fetching Blog list");
    }
  }
  static Future<Map<String, dynamic>> categoryIdWisePackageList(Map<String, dynamic> body) async {
  final String url = 'https://holidaymakers.com/holiday_api/get_category_id_wise_package_list';

  try {
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load category ID wise packages');
    }
  } catch (e) {
    throw Exception('Error fetching category ID wise packages: $e');
  }
}
static Future<Map<String, dynamic>> getSplashScreen() async {
    try {
      final response = await http.get(Uri.parse(
          'https://holidaymakers.com/holiday_api/flashscreen_image_list'));
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception("Failed to load Blog list...");
      }
    } catch (e) {
      print("API Error: $e");
      throw Exception("Error fetching Blog list");
    }
  }
  static Future<Map<String, dynamic>> fetchWalletData() async {
    final String url = 'https://holidaymakers.com/holiday_api/wallet_balance';

  Map<String, String> profileDetails = await _ProfileDetails();
    String userId = profileDetails['userId'] ?? "";
    String token = profileDetails['token'] ?? "";

    final Map<String, String> headers = {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json",
    };

    final Map<String, dynamic> body = {
      "user_id": userId
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(body),
      );
      final jsonData = json.decode(response.body);
    if (response.statusCode == 200) {
      
      return jsonData['data'];
    } else {
      throw Exception('API error: ${jsonData['message']}');
    }
  } catch (e) {
    throw Exception('Error fetching Wallet data: $e');
  }
  }

}
