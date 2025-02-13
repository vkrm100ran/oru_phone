import 'package:flutter/material.dart';
import 'package:oru_phones/provider/filterProvider.dart';
import 'package:provider/provider.dart';

class PriceRangeSlider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<FilterProvider>(
      builder: (context, filterProvider, child) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Any",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            Text("Maximum Price", style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            SizedBox(
              height: 260,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  RotatedBox(
                    quarterTurns: -1,
                    child: SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        activeTrackColor: Colors.black,
                        inactiveTrackColor: Colors.grey.shade300,
                        thumbColor: Colors.black,
                        thumbShape:
                            RoundSliderThumbShape(enabledThumbRadius: 10),
                      ),
                      child: RangeSlider(
                        values: RangeValues(
                            filterProvider.minPrice, filterProvider.maxPrice),
                        min: 5000,
                        max: 100000,
                        divisions: 20,
                        labels: RangeLabels(
                          "₹${filterProvider.minPrice.toInt()}",
                          "₹${filterProvider.maxPrice.toInt()}",
                        ),
                        onChanged: (RangeValues values) {
                          filterProvider.setPriceRange(
                              values.start, values.end);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Text("Minimum Price",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            Text("₹${filterProvider.minPrice.toInt()}",
                style: TextStyle(fontSize: 16)),
          ],
        );
      },
    );
  }
}
