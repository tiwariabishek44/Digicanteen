import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:merocanteen/app/config/colors.dart';
import 'package:merocanteen/app/modules/vendor_modules/analytics/analytics_controller.dart';
import 'package:merocanteen/app/widget/empty_cart_page.dart';
import 'package:merocanteen/app/widget/loading_screen.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class DemandSupply extends StatelessWidget {
  final orderController = Get.put(DemandSupplyController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        if (orderController.isloading.value) {
          return Center(child: CircularProgressIndicator());
        } else {
          return SizedBox(
            width: double.infinity,
            height: 165,
            child: GridView.builder(
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.45,
                  crossAxisSpacing: 1,
                  mainAxisSpacing: 1),
              scrollDirection: Axis.horizontal,
              itemCount: orderController.orders.length,
              itemBuilder: (context, index) {
                String itemName = orderController.orders.keys.elementAt(index);

                int totalOrderQuantity =
                    orderController.totalQuantityPerProductOrders[itemName] ??
                        0;
                int remainingQuantity = orderController
                        .totalQuantityPerProductUnCheckoutOrders[itemName] ??
                    0;

                return Card(
                  child: Container(
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 8.0),
                          Text(
                            itemName,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15.0,
                            ),
                          ),
                          SizedBox(height: 3.0),
                          Text(
                            'Orders: $totalOrderQuantity /Plate',
                            style: TextStyle(
                              fontSize: 14.0,
                              color: Color.fromARGB(255, 35, 68, 68),
                            ),
                          ),
                          Text(
                            'Pending: $remainingQuantity /plate',
                            style: TextStyle(
                              fontSize: 14.0,
                              color: Color.fromARGB(255, 220, 127, 127),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        }
      },
    );
  }
}
