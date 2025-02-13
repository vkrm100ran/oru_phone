import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String baseUrl = "http://40.90.224.241:5000";

  static Future<void> logoutUser() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove("sessionCookie");
      await prefs.remove("userName");
      await prefs.remove("likedProducts");
    } catch (e) {
      print("Error during logout: $e");
    }
  }

  Future<String?> getUserName() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("userName");
  }
}
