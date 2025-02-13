import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class HomeProvider extends ChangeNotifier {
  List<dynamic> _brands = [];
  List<dynamic> _products = [];
  Map<String, dynamic> _filters = {};
  int _currentPage = 1;
  bool _isLoading = false;

  List<dynamic> get brands => _brands;
  List<dynamic> get products => _products;
  Map<String, dynamic> get filters => _filters;
  bool get isLoading => _isLoading;

  Map<String, dynamic> _selectedFilters = {};


  final List<Map<String, dynamic>> dummyProducts = [
    {
      "marketingName": "Dummy Phone A",
      "listingPrice": "9,999",
      "defaultImage": {
        "fullImage": "https://img.freepik.com/premium-vector/389-phone-poster_602222-325.jpg"
      }
    },
    {
      "marketingName": "Dummy Phone B",
      "listingPrice": "12,499",
      "defaultImage": {
        "fullImage": "https://techindroid.com/wp-content/uploads/2016/08/10-best-android-phones-of-2016-Low-Budget.png"
      }
    },

  ];

  Future<void> loadInitialData() async {
    _isLoading = true;
    notifyListeners();

    try {
      await Future.wait([
        fetchBrands(),
        fetchProducts(_currentPage),
        fetchFilters(),
      ]);
    } catch (e) {
      debugPrint("Error loading data: $e");
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchBrands() async {
    try {
      final response = await http.get(Uri.parse('http://40.90.224.241:5000/makeWithImages'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['dataObject'];
        print("this is brands --------------------------      ${data}");
        _brands = data ?? [];
        notifyListeners();
      } else {
        debugPrint("Failed to load brands: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Error fetching brands: $e");
    }
  }


  Future<void> fetchProducts(int page, {String? sortType}) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse('http://40.90.224.241:5000/filter'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "filter": {
            "page": page,
            ..._selectedFilters,
          },
        }),
      );

      if (response.statusCode == 200) {
        List<dynamic> newProducts = jsonDecode(response.body)['data']['data'];

        if (sortType != null && sortType.isNotEmpty) {
          newProducts = _sortProducts(newProducts, sortType);
        }

        _products = _insertDummyProducts(newProducts);
        notifyListeners();
      } else {
        debugPrint("Failed to load products: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Error fetching products: $e");
    }

    _isLoading = false;
    notifyListeners();
  }








  void updateSelectedFilters(String category, String value, bool isSelected) {
    if (isSelected) {
      _selectedFilters[category] = value;
    } else {
      _selectedFilters.remove(category);
    }
    fetchProducts(1);
  }







  Future<void> fetchFilters() async {
    try {
      final response = await http.get(Uri.parse('http://40.90.224.241:5000/showSearchFilters'));

      if (response.statusCode == 200) {
        _filters = jsonDecode(response.body)['dataObject'];
        print("this is filters --------------------------      ${filters}");
        notifyListeners();
      } else {
        debugPrint("Failed to load filters: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Error fetching filters: $e");
    }
  }

  List<dynamic> _insertDummyProducts(List<dynamic> productsList) {
    List<dynamic> updatedList = [];
    for (int i = 0; i < productsList.length; i++) {
      updatedList.add(productsList[i]);
      if ((i + 1) % 7 == 0) {
        updatedList.add(dummyProducts[i % dummyProducts.length]);
      }
    }
    return updatedList;
  }


  List<dynamic> _sortProducts(List<dynamic> products, String sortType) {
    List<dynamic> sortedProducts = List.from(products);

    switch (sortType) {
      case "Price: High To Low":
        sortedProducts.sort((a, b) => (b['listingPrice'] as num).compareTo(a['listingPrice'] as num));
        break;
      case "Price: Low To High":
        sortedProducts.sort((a, b) => (a['listingPrice'] as num).compareTo(b['listingPrice'] as num));
        break;
      case "Latest":
        sortedProducts.sort((a, b) => (b['dateAdded'] as String).compareTo(a['dateAdded'] as String));
        break;
      case "Distance":
        sortedProducts.sort((a, b) => (a['distance'] as num).compareTo(b['distance'] as num));
        break;
      case "Value For Money":

        sortedProducts.sort((a, b) => (b['valueScore'] as num).compareTo(a['valueScore'] as num));
        break;
    }

    return sortedProducts;
  }




}








