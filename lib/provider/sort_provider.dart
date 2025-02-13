import 'package:flutter/material.dart';
import 'package:oru_phones/provider/homeProvider.dart';
import 'package:provider/provider.dart';

class SortProvider with ChangeNotifier {
  int _selectedIndex = -1;
  String _selectedSort = "";

  int get selectedIndex => _selectedIndex;
  String get selectedSort => _selectedSort;

  void selectSortOption(int index, String sortType, BuildContext context) {
    _selectedIndex = index;
    _selectedSort = sortType;

    Provider.of<HomeProvider>(context, listen: false).fetchProducts(1, sortType: _selectedSort);


    notifyListeners();
  }

  void clearSelection(BuildContext context) {
    _selectedIndex = -1;
    _selectedSort = "";

    Provider.of<HomeProvider>(context, listen: false).fetchProducts(1);

    notifyListeners();
  }
}

