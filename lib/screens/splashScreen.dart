import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:oru_phones/screens/auth/loginScreen.dart';
import 'package:oru_phones/screens/auth/nameConfirmationScreen.dart';
import 'package:oru_phones/screens/homeScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String baseUrl = "http://40.90.224.241:5000";

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sessionCookie = prefs.getString("sessionCookie");
    String? userName = prefs.getString("userName");

    if (sessionCookie == null) {
      //  No session found , Go to Login
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => LoginScreen()));
      return;
    }

    try {
      final response = await http.get(
        Uri.parse("$baseUrl/isLoggedIn"),
        headers: {"Cookie": sessionCookie},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data["isLoggedIn"] == true) {
          if (userName == null) {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (_) => NameConfirmationScreen()));
          } else {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (_) => HomeScreen()));
          }
        } else {
          await prefs.remove("sessionCookie");
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => LoginScreen()));
        }
      } else {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => LoginScreen()));
      }
    } catch (e) {
      print("Error checking login status: $e");
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => LoginScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child:
            CircularProgressIndicator(),
      ),
    );
  }
}
