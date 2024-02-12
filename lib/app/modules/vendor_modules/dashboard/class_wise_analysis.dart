import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:merocanteen/app/config/colors.dart';
import 'package:merocanteen/app/config/style.dart';
import 'package:merocanteen/app/modules/vendor_modules/analytics/analytics_controller.dart';
import 'package:intl/intl.dart';
import 'package:merocanteen/app/widget/empty_cart_page.dart';
import 'package:nepali_utils/nepali_utils.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class Classanalytics extends StatelessWidget {
  final orderController = Get.put(AnalyticsController());
  Future<void> refreshindicator() async {
    await orderController.fetchOrders();
  }

  @override
  Widget build(BuildContext context) {
    DateTime currentDate = DateTime.now();

    // ignore: deprecated_member_use
    NepaliDateTime nepaliDateTime = NepaliDateTime.fromDateTime(currentDate);

    String formattedDate =
        DateFormat('dd/MM/yyyy\'', 'en').format(nepaliDateTime);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: AppBar(
          scrolledUnderElevation: 0,
          title: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Class Analytics",
                  style: AppStyles.appbar,
                ),
                Text(
                  formattedDate,
                  style: AppStyles.listTilesubTitle,
                ),
              ],
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: RefreshIndicator(
            onRefresh: refreshindicator,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Obx(
                () {
                  if (orderController.isloading.value) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    if (orderController.orders.value.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Image.asset(
                                'assets/empty.png', // Replace with your image asset path
                                width: 200, // Adjust image width as needed
                                height: 200, // Adjust image height as needed
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 18.0, top: 8),
                              child: Text(
                                'No Orders Yet',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemCount: orderController.orders.length,
                        itemBuilder: (context, index) {
                          String itemName =
                              orderController.orders.keys.elementAt(index);

                          int totalOrderQuantity = orderController
                                  .totalQuantityPerProductOrders[itemName] ??
                              0;
                          int checkoutQuantity = orderController
                                      .totalQuantityPerProductCheckoutOrders[
                                  itemName] ??
                              0;
                          String imageUrl =
                              orderController.orders[itemName]![0].productImage;
                          return Padding(
                            padding: EdgeInsets.only(bottom: 2.0.h),
                            child: Container(
                              decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(255, 255, 255, 255),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      color: const Color.fromARGB(
                                          255, 225, 225, 225))),
                              child: Padding(
                                padding: EdgeInsets.all(17),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 8.0),
                                    Text(
                                      itemName,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: AppStyles.listTileTitle,
                                    ),
                                    Spacer(),
                                    Column(
                                      children: [
                                        Text(
                                          'Orders: $totalOrderQuantity -Plate',
                                          style: AppStyles.listTilesubTitle,
                                        ),
                                        Text(
                                          'Remaning: ${totalOrderQuantity - checkoutQuantity}/plate',
                                          style: TextStyle(
                                            fontSize: 14.0,
                                            color: Color.fromARGB(
                                                255, 220, 127, 127),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
