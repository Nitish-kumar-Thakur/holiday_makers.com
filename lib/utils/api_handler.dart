import 'dart:convert';
import 'package:http/http.dart' as http;

class APIHandler {
  static const String loginUrl =
      'https://b2cuat.tikipopi.com/index.php/holiday_api';
  static const String signupUrl =
      "https://b2cuat.tikipopi.com/index.php/holiday_api/";
  static const String homeUrl =
      'https://b2cuat.tikipopi.com/index.php/holiday_api';
  static const String forgotPasswordUrl =
      'https://b2cuat.tikipopi.com/index.php/holiday_api/forgot_password';
  static const String baseUrl =
      "https://b2cuat.tikipopi.com/index.php/holiday_api/get_category_wise_package_list";
  static const String sourceUrl =
      "https://b2cuat.tikipopi.com/index.php/holiday_api/source_list";
  static const String destUrl =
      "https://b2cuat.tikipopi.com/index.php/holiday_api/destination_list";
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
      final response = await http.post(Uri.parse(destUrl),headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'source_id': sourceId,}),);

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
}