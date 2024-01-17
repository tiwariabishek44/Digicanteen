import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import 'package:merocanteen/app/config/colors.dart';
import 'package:flutter/material.dart';
import 'package:merocanteen/app/modules/common/login/login_controller.dart';
import 'package:merocanteen/app/modules/vendor_modules/order_requirements/order_requirement_controller.dart';
import 'package:merocanteen/app/widget/empty_cart_page.dart';
import 'package:merocanteen/app/widget/loading_screen.dart';
import 'package:intl/intl.dart';

class OrderRequirement extends StatelessWidget {
  final loginContorller = Get.put(LoginController());
  final orderRequestController = Get.put(OrderRequestContoller());

  @override
  Widget build(BuildContext context) {
    DateTime currentDate = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(currentDate);

    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Order Requirement",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                formattedDate, // Display Nepali date in the app bar
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
      // Add the rest of your app content here

      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.white,
              child: Row(children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {},
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      padding: EdgeInsets.all(12.0),
                      child: const Text(
                        "    Morning     ",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {},
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      padding: EdgeInsets.all(12.0),
                      child: const Text(
                        "    AfterNoon    ",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                )
              ]),
            ),
          ),
          Expanded(
              flex: 9,
              child: Obx(() {
                if (orderRequestController.isloading.value) {
                  // Show a message if there are no orders available
                  return LoadingScreen();
                } else {
                  if (orderRequestController.orders.isEmpty) {
                    return EmptyCartPage();
                  } else {
                    return GridView.builder(
                      physics: ScrollPhysics(),
                      shrinkWrap: true,
                      padding: const EdgeInsets.all(8.0),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12.0,
                        mainAxisSpacing: 12.0,
                        childAspectRatio: 0.85,
                      ),
                      itemCount: orderRequestController.orders.length,
                      itemBuilder: (BuildContext context, int index) {
                        String productName =
                            orderRequestController.orders.keys.elementAt(index);
                        int quantity = orderRequestController
                                .totalQuantityPerProduct[productName] ??
                            0;
                        // Get the image URL from the first item of the productList (assuming all items for the same productName have the same image)
                        String imageUrl = orderRequestController
                            .orders[productName]![0].productImage;

                        return Container(
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 235, 230, 230),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10),
                                  ),
                                  child: CachedNetworkImage(
                                    imageUrl: imageUrl ??
                                        '', // Use a default empty string if URL is null
                                    fit: BoxFit.cover,
                                    errorWidget: (context, url, error) => Icon(
                                      Icons.error_outline,
                                      size: 40,
                                    ), // Placeholder icon for error
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      productName,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.0,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(height: 8.0),
                                    Text(
                                      'Quantity: $quantity plate',
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
                        );
                      },
                    );
                  }
                }
              })),
        ],
      ),
    );
  }
}
