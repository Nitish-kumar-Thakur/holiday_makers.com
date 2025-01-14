import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHandler {
  static Future<void> saveLoginData(Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
    await prefs.setString("user_id", data["data"]["user_id"].toString());
    await prefs.setString("token", data["token"].toString());
    await prefs.setString("first_name", data["data"]["first_name"].toString());
    await prefs.setString("last_name", data["data"]["last_name"].toString());
    await prefs.setString("email_org", data["data"]["email_org"].toString());
    await prefs.setString("address", data["data"]["address"].toString());
    await prefs.setString("country_code", data["data"]["country_code"].toString());
    await prefs.setString("phone", data["data"]["phone"].toString());
    await prefs.setString("profileImg", data["data"]["image"].toString());
  }

  static Future<Map<String, String>> loadProfileDetails() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      "profileImg": prefs.getString("profileImg") ?? "",
      "first_name": prefs.getString("first_name") ?? "",
      "last_name": prefs.getString("last_name") ?? "",
      "email": prefs.getString("email") ?? "",
      "address": prefs.getString("address") ?? "",
      "country_code": prefs.getString("country_code") ?? "",
      "phone": prefs.getString("phone") ?? "",
    };
  }
}