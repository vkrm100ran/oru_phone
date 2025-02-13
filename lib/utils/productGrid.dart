import 'package:flutter/material.dart';
import 'package:oru_phones/provider/homeProvider.dart';
import 'package:oru_phones/provider/filterProvider.dart';
import 'package:oru_phones/provider/likeProvider.dart';
import 'package:oru_phones/provider/sort_provider.dart';
import 'package:provider/provider.dart';
import 'package:oru_phones/utils/productCard.dart';

class ProductGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer4<HomeProvider, FilterProvider, SortProvider, LikeProvider>(
      builder: (context, homeProvider, filterProvider, sortProvider,
          likeProvider, child) {
        if (homeProvider.isLoading) {
          return Center(child: CircularProgressIndicator());
        }

        List<dynamic> allProducts = homeProvider.products;
        List<dynamic> filteredProducts = allProducts;
        var selectedFilters = filterProvider.selectedFilters;
        String selectedSort = sortProvider.selectedSort;


        if (selectedFilters.isNotEmpty &&
            selectedFilters.values.any((list) => list.isNotEmpty)) {
          filteredProducts = allProducts.where((product) {
            bool matchesFilter = true;

            selectedFilters.forEach((category, selectedOptions) {
              if (selectedOptions.isNotEmpty) {
                if (category == "Brand" &&
                    !selectedOptions.contains(product['make'])) {
                  matchesFilter = false;
                }
                if (category == "Storage" &&
                    !selectedOptions.contains(product['deviceStorage'])) {
                  matchesFilter = false;
                }
                if (category == "Conditions" &&
                    !selectedOptions.contains(product['deviceCondition'])) {
                  matchesFilter = false;
                }
              }
            });

            return matchesFilter;
          }).toList();
        }


        if (selectedSort == "Price: Low to High") {
          filteredProducts
              .sort((a, b) => a['listingPrice'].compareTo(b['listingPrice']));
        } else if (selectedSort == "Price: High to Low") {
          filteredProducts
              .sort((a, b) => b['listingPrice'].compareTo(a['listingPrice']));
        } else if (selectedSort == "Newest First") {
          filteredProducts
              .sort((a, b) => b['verifiedDate'].compareTo(a['verifiedDate']));
        } else if (selectedSort == "Oldest First") {
          filteredProducts
              .sort((a, b) => a['verifiedDate'].compareTo(b['verifiedDate']));
        }

        List<dynamic> displayList = [];
        int dummyIndex = 0;

        for (int i = 0; i < filteredProducts.length; i++) {
          displayList.add(filteredProducts[i]);
          if ((i + 1) % 7 == 0) {
            dummyIndex++;
          }
        }

        int itemCount = displayList.length;
        int crossAxisCount = 2;
        double itemHeight = 200;
        int rowCount = (itemCount / crossAxisCount).ceil();

        return itemCount == 0
            ? Center(
                child:
                    Text("No products found", style: TextStyle(fontSize: 16)))
            : SizedBox(
                height: (rowCount * itemHeight) + (rowCount * 20),
                child: GridView.builder(
                  padding: EdgeInsets.all(8),
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.7,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: itemCount,
                  itemBuilder: (context, index) {
                    var product = displayList[index];
                    bool isDummy = !filteredProducts.contains(product);
                    bool isLiked = isDummy || product['listingId'] == null
                        ? false
                        : likeProvider.isLiked(product['listingId']);

                    return ProductCard(
                      product: product,
                      isDummy: isDummy,
                      isLiked: isLiked,
                      onLikeToggle: () {
                        likeProvider.toggleLike(product['listingId']);
                      },
                    );
                  },
                ),
              );
      },
    );
  }
}
