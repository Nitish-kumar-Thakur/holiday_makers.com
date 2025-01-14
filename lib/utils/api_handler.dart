import 'dart:convert';
import 'package:http/http.dart' as http;

class APIHandler {
  static const String loginUrl =
      'https://b2cuat.tikipopi.com/index.php/holiday_api';
  static const String homeUrl = 'https://b2cuat.tikipopi.com/index.php/holiday_api';

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
  
}
