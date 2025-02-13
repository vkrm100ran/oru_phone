import 'package:flutter/material.dart';
import 'package:oru_phones/provider/sort_provider.dart';
import 'package:oru_phones/provider/homeProvider.dart';
import 'package:provider/provider.dart';

class SortBottomSheet extends StatelessWidget {
  final List<String> sortOptions = [
    "Value For Money",
    "Price: High To Low",
    "Price: Low To High",
    "Latest",
    "Distance",
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<SortProvider>(
      builder: (context, sortProvider, child) {
        return Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Sort",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              Divider(color: Colors.grey, thickness: 0.4),
              ListView.builder(
                shrinkWrap: true,
                itemCount: sortOptions.length,
                itemBuilder: (context, index) {
                  bool isSelected = sortProvider.selectedIndex == index;
                  return InkWell(
                    onTap: () {
                      sortProvider.selectSortOption(
                          index, sortOptions[index], context);
                      Navigator.pop(
                          context);
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.yellow.withOpacity(0.2)
                            : Colors.transparent,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              sortOptions[index],
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                          Icon(
                            isSelected
                                ? Icons.radio_button_checked
                                : Icons.radio_button_off,
                            color: isSelected ? Colors.orange : Colors.grey,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              Divider(color: Colors.grey, thickness: 0.4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      sortProvider.clearSelection(context);
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Clear",
                      style: TextStyle(color: Colors.orange, fontSize: 16),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: sortProvider.selectedIndex != -1
                        ? () => Navigator.pop(context)
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: sortProvider.selectedIndex != -1
                          ? Colors.yellow
                          : Colors.grey.shade400,
                    ),
                    child: Text(
                      "Apply",
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
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
