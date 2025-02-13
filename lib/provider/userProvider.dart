import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider extends ChangeNotifier{
  String _userName = "Loading............";
  String _sessionCookie = "";
  get userName => _userName;
  get sessionCookie => _sessionCookie;


  UserProvider() {
    loadUserData();
  }

  Future<void> loadUserData() async {
    await getUserName();
    await getsessionCookie();
  }


  Future<void> getUserName()async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _userName = await prefs.getString("userName") ?? "No username";
    notifyListeners();
  }

  Future<void> getsessionCookie()async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _sessionCookie = await prefs.getString("sessionCookie") ?? "";
    notifyListeners();
  }

}


