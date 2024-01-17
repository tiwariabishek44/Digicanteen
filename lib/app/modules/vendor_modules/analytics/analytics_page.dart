import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:merocanteen/app/config/colors.dart';
import 'package:merocanteen/app/modules/vendor_modules/analytics/analytics_controller.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class AnalyticsPage extends StatelessWidget {
  final orderController = Get.put(AnalyticsController());
  final demandSupplyControler = Get.put(DemandSupplyController());

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
                "Analytics",
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

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Class wise Analytics",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Obx(
                () {
                  if (orderController.isloading.value) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    return SizedBox(
                      height: 310,
                      width: double.infinity,
                      child: GridView.builder(
                        shrinkWrap: true,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                childAspectRatio: 0.45,
                                crossAxisSpacing: 1,
                                mainAxisSpacing: 1),
                        scrollDirection: Axis.horizontal,
                        itemCount: orderController.orders.length,
                        itemBuilder: (context, index) {
                          String itemName =
                              orderController.orders.keys.elementAt(index);

                          int totalOrderQuantity = orderController
                                  .totalQuantityPerProductOrders[itemName] ??
                              0;
                          int remainingQuantity = orderController
                                      .totalQuantityPerProductUnCheckoutOrders[
                                  itemName] ??
                              0;
                          String imageUrl =
                              orderController.orders[itemName]![0].productImage;
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
                                        color:
                                            Color.fromARGB(255, 220, 127, 127),
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
              ),
              SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Meal Demand-supply",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Obx(
                () {
                  if (demandSupplyControler.isloading.value) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    return SizedBox(
                      height: 310,
                      width: double.infinity,
                      child: GridView.builder(
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            childAspectRatio: 0.45,
                            crossAxisSpacing: 1,
                            mainAxisSpacing: 1),
                        scrollDirection: Axis.horizontal,
                        itemCount: demandSupplyControler.orders.length,
                        itemBuilder: (context, index) {
                          String itemName = demandSupplyControler.orders.keys
                              .elementAt(index);

                          int totalOrderQuantity = demandSupplyControler
                                  .totalQuantityPerProductOrders[itemName] ??
                              0;
                          int remainingQuantity = demandSupplyControler
                                      .totalQuantityPerProductUnCheckoutOrders[
                                  itemName] ??
                              0;
                          String imageUrl = demandSupplyControler
                              .orders[itemName]![0].productImage;
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
                                        color:
                                            Color.fromARGB(255, 220, 127, 127),
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
              ),
              SizedBox(
                height: 20,
              )
            ],
          ),
        ),
      ),
    );
  }
}
