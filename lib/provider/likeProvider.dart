import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LikeProvider extends ChangeNotifier {
  final String apiUrl = "http://40.90.224.241:5000/favs";
  final Map<String, bool> _likedProducts = {};

  Map<String, bool> get likedProducts => _likedProducts;

  LikeProvider() {
    _loadLikedProducts();
  }

  bool isLiked(String listingId) => _likedProducts[listingId] ?? false;

  Future<void> _loadLikedProducts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final likedData = prefs.getStringList('likedProducts') ?? [];

    for (String id in likedData) {
      _likedProducts[id] = true;
    }
    notifyListeners();
  }

  Future<void> _saveLikedProducts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('likedProducts', _likedProducts.keys.where((id) => _likedProducts[id] == true).toList());
  }

  Future<void> toggleLike(String listingId) async {
    bool isCurrentlyLiked = _likedProducts[listingId] ?? false;
    bool newLikeStatus = !isCurrentlyLiked;

    _likedProducts[listingId] = newLikeStatus;
    notifyListeners();

    await _saveLikedProducts();

    try {
      await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "listingId": listingId,
          "isFav": newLikeStatus,
        }),
      );
    } catch (error) {
      _likedProducts[listingId] = isCurrentlyLiked;
      notifyListeners();
      await _saveLikedProducts();
    }
  }
}
