import 'package:merocanteen/app/config/colors.dart';
import 'package:merocanteen/app/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

// Define the reusable product grid widget
class VendorProductGrid extends StatelessWidget {
  final List<Product> productList; // Receive the product list as a parameter

  VendorProductGrid({Key? key, required this.productList}) : super(key: key);

  // State to maintain quantities of each product

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        shrinkWrap: false,
        physics: ScrollPhysics(),
        padding: const EdgeInsets.all(8.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12.0,
          mainAxisSpacing: 12.0,
          childAspectRatio: 0.85,
        ),
        itemCount: productList.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {},
            child: Container(
              decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 235, 230, 230),
                  borderRadius: BorderRadius.circular(10)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10)),
                      child: CachedNetworkImage(
                        // height: 200.0,
                        imageUrl: productList[index].image ??
                            '', // Use a default empty string if URL is null
                        fit: BoxFit.cover,
                        errorWidget: (context, url, error) => Icon(
                            Icons.error_outline,
                            size: 40), // Placeholder icon for error
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          productList[index].name,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          'Rs.${productList[index].price.toStringAsFixed(2)}/plate',
                          style: TextStyle(
                            fontSize: 14.0,
                            color: secondaryColor,
                          ),
                        ),
                        // Additional information or description widgets can be added here
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
