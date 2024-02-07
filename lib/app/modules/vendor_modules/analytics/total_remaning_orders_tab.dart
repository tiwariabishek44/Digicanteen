import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:merocanteen/app/config/colors.dart';
import 'package:merocanteen/app/modules/vendor_modules/analytics/analytics_controller.dart';
import 'package:intl/intl.dart';
import 'package:merocanteen/app/modules/vendor_modules/analytics/remaning_orders_controller.dart';
import 'package:merocanteen/app/widget/empty_cart_page.dart';
import 'package:nepali_utils/nepali_utils.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class TotalRemaningOrdersTab extends StatefulWidget {
  @override
  State<TotalRemaningOrdersTab> createState() => _TotalRemaningOrdersTabState();
}

class _TotalRemaningOrdersTabState extends State<TotalRemaningOrdersTab> {
  final demandSupplyControler = Get.put(RemaningOrdersController());
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 1,
          child: Container(
            color: Colors.white,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                physics: ScrollPhysics(),
                itemCount: demandSupplyControler.timeSlots.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedIndex = index;
                        demandSupplyControler
                            .fetchRemaningMeal(selectedIndex.toInt());
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Container(
                        width: 100,
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.secondaryColor),
                          borderRadius: BorderRadius.circular(10),
                          color: selectedIndex == index
                              ? Color.fromARGB(255, 206, 207, 209)
                              : const Color.fromARGB(255, 247, 245, 245),
                        ),
                        child: Center(
                          child: Text(
                            demandSupplyControler.timeSlots[index],
                            style: TextStyle(
                                fontSize: 18.0,
                                color: Color.fromARGB(255, 84, 82, 82)),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
          ),
        ),
        Expanded(
          flex: 13,
          child: Obx(() {
            if (demandSupplyControler.isLoading.value) {
              return Center(child: CircularProgressIndicator());
            } else {
              if (demandSupplyControler.reamaningorders.value.isEmpty) {
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
                        padding: const EdgeInsets.only(left: 18.0, top: 8),
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
                return SingleChildScrollView(
                  child: ListView.builder(
                      shrinkWrap: true,
                      physics: ScrollPhysics(),
                      itemCount:
                          demandSupplyControler.totalremaningOrders.length,
                      itemBuilder: (context, index) {
                        String productName = demandSupplyControler
                            .totalremaningOrders.keys
                            .elementAt(index);
                        int totalOrders = demandSupplyControler
                                .totalremaningOrders[productName] ??
                            0;

                        String productImage = demandSupplyControler
                                .reamaningorders[productName]
                                ?.first
                                .productImage ??
                            '';
                        return Container(
                          decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 255, 255, 255),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  color: const Color.fromARGB(
                                      255, 225, 225, 225))),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(children: [
                              Container(
                                height: 60,
                                width: 60,
                                decoration: BoxDecoration(
                                    color: const Color.fromARGB(
                                        255, 255, 255, 255)),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: CachedNetworkImage(
                                    imageUrl: productImage ??
                                        '', // Use a default empty string if URL is null
                                    fit: BoxFit.cover,
                                    errorWidget: (context, url, error) => Icon(
                                      Icons.error_outline,
                                      size: 40,
                                    ), // Placeholder icon for error
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Expanded(
                                child: Text('$productName',
                                    overflow: TextOverflow.clip,
                                    maxLines: 2,
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                        color:
                                            Color.fromARGB(255, 78, 76, 76))),
                              ),
                              Spacer(),
                              Text(
                                'Remaning: $totalOrders -Plate',
                                style: TextStyle(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w600,
                                  color: Color.fromARGB(255, 35, 68, 68),
                                ),
                              )
                            ]),
                          ),
                        );
                      }),
                );
              }
            }
          }),
        ),
      ],
    );
  }
}
