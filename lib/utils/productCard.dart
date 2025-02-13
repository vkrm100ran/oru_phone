import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final dynamic product;
  final bool isDummy;
  final bool isLiked;
  final VoidCallback onLikeToggle;

  const ProductCard({
    required this.product,
    required this.isDummy,
    required this.isLiked,
    required this.onLikeToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                child: Image.network(
                  product['defaultImage']['fullImage'],
                  height: 145,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              if (!isDummy)
                Positioned(
                  top: 8,
                  left: 0,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    color: Colors.green,
                    child: Text("ORU Verified",
                        style: TextStyle(color: Colors.white, fontSize: 10)),
                  ),
                ),
              Positioned(
                top: 8,
                right: 8,
                child: GestureDetector(
                  onTap: onLikeToggle,
                  child: Icon(
                    isLiked ? Icons.favorite : Icons.favorite_border,
                    color: isLiked ? Colors.red : Colors.white,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product['marketingName'],
                    style:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                Text("₹${product['listingPrice']}",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Text(
                    "${product['deviceStorage']} • ${product['deviceCondition']}",
                    style: TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
