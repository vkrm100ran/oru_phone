import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = "http://40.90.224.241:5000";


  static Future<bool> sendOtp(String countryCode, String phoneNumber) async {
    final url = Uri.parse('$baseUrl/login/otpCreate');

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "countryCode": int.parse(countryCode),
          "mobileNumber": int.parse(phoneNumber)
        }),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }


  static Future<bool> verifyOtp(String countryCode, String phoneNumber, String otp) async {
    final url = Uri.parse('$baseUrl/login/otpValidate');

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "countryCode": int.parse(countryCode),
          "mobileNumber": int.parse(phoneNumber),
          "otp": int.parse(otp)
        }),
      );

      if (response.statusCode == 200) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('phoneNumber', phoneNumber);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }


  static Future<bool> isLoggedIn() async {
    final url = Uri.parse('$baseUrl/isLoggedIn');

    try {
      final response = await http.get(
        url,
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        print(jsonDecode(response.body));
        return true;

      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }


  static Future<bool> logout() async {
    final url = Uri.parse('$baseUrl/logout');

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? csrfToken = prefs.getString('csrfToken'); // Fetch CSRF token

      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "X-Csrf-Token": csrfToken ?? "",
        },
      );

      if (response.statusCode == 200) {
        prefs.clear();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }


  static Future<bool> updateUser(String countryCode, String userName) async {
    final url = Uri.parse('$baseUrl/update');

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? csrfToken = prefs.getString('csrfToken');

      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "X-Csrf-Token": csrfToken ?? "",
        },
        body: jsonEncode({
          "countryCode": int.parse(countryCode),
          "userName": userName
        }),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}



