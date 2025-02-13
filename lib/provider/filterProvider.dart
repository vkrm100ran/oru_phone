import 'package:flutter/material.dart';
import 'package:oru_phones/provider/homeProvider.dart';
import 'package:provider/provider.dart';

class FilterProvider extends ChangeNotifier {




  String selectedCategory = "Brand";
  Map<String, List<String>> selectedFilters = {
    "Brand": [],
    "Condition": [],
    "Storage": [],
    "RAM": [],
    "Verification": [],
    "Warranty": [],
    "Price Range": []
  };

  double minPrice = 5000;
  double maxPrice = 50000;



  void selectCategory(String category) {
    selectedCategory = category;
    notifyListeners();
  }

  void setPriceRange(double min, double max) {
    minPrice = min;
    maxPrice = max;
    notifyListeners();
  }

  void toggleFilter(String category, String option, HomeProvider homeProvider) {
    if (selectedFilters[category]?.contains(option) == true) {
      selectedFilters[category]?.remove(option);
    } else {
      selectedFilters.putIfAbsent(category, () => []).add(option);
    }

    notifyListeners();

    homeProvider.updateSelectedFilters(category, option, selectedFilters[category]?.contains(option) ?? false);
    homeProvider.notifyListeners();
  }



  void clearFilters() {
    for (var key in selectedFilters.keys) {
      selectedFilters[key] = [];
    }
    minPrice = 5000;
    maxPrice = 50000;
    notifyListeners();
  }
}


