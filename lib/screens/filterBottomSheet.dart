import 'package:flutter/material.dart';
import 'package:oru_phones/provider/filterProvider.dart';
import 'package:oru_phones/provider/homeProvider.dart';
import 'package:oru_phones/utils/priceRangeSlider.dart';
import 'package:provider/provider.dart';

class FilterBottomSheet extends StatelessWidget {
  final Map<String, List<String>> filterOptions = {
    "Brand": ["Apple", "Samsung", "Google", "OnePlus", "Xiaomi"],
    "Condition": ["Like New", "Excellent", "Good", "Fair", "Needs Repair"],
    "Storage": [
      "8 GB",
      "16 GB",
      "32 GB",
      "64 GB",
      "128 GB",
      "256 GB",
      "512 GB",
      "1 TB"
    ],
    "RAM": ["2 GB", "4 GB", "6 GB", "8 GB", "12 GB", "16 GB"],
    "Verification": ["Verified Only"],
    "Warranty": ["Brand Warranty", "Seller Warranty"],
    "Price Range": []
  };

  @override
  Widget build(BuildContext context) {
    final homeProvider = Provider.of<HomeProvider>(context, listen: false);
    return Consumer<FilterProvider>(
      builder: (context, filterProvider, child) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.6,
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Filters",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () => Navigator.pop(context)),
                ],
              ),
              Divider(color: Colors.grey, thickness: 0.4),
              Expanded(
                child: Row(
                  children: [
                    SizedBox(
                      width: 140,
                      child: ListView(
                        children: filterOptions.keys.map((category) {
                          bool isSelected =
                              filterProvider.selectedCategory == category;
                          return GestureDetector(
                            onTap: () =>
                                filterProvider.selectCategory(category),
                            child: Container(
                              color: isSelected
                                  ? Colors.yellow.shade50
                                  : Colors.transparent,
                              child: ListTile(
                                title: Text(
                                  category,
                                  style: TextStyle(
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    VerticalDivider(color: Colors.grey, thickness: 0.4),
                    Expanded(
                      child: filterProvider.selectedCategory == "Price Range"
                          ? PriceRangeSlider()
                          : ListView(
                              children: filterOptions[
                                      filterProvider.selectedCategory]!
                                  .map((option) {
                                return CheckboxListTile(
                                  title: Text(option),
                                  value: filterProvider.selectedFilters[
                                          filterProvider.selectedCategory]!
                                      .contains(option),
                                  onChanged: (bool? value) {
                                    filterProvider.toggleFilter(
                                        filterProvider.selectedCategory,
                                        option,
                                        homeProvider);
                                  },
                                );
                              }).toList(),
                            ),
                    ),
                  ],
                ),
              ),
              Divider(color: Colors.grey, thickness: 0.4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () => filterProvider.clearFilters(),
                    child: Text("Clear All",
                        style: TextStyle(color: Colors.orange)),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      print(
                          "Selected Filters: ${filterProvider.selectedFilters}");
                      print(
                          "Price Range: ${filterProvider.minPrice} - ${filterProvider.maxPrice}");
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.yellow),
                    child: Text("Apply"),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
