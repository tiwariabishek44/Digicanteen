import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import 'package:merocanteen/app/config/colors.dart';
import 'package:flutter/material.dart';
import 'package:merocanteen/app/config/style.dart';
import 'package:merocanteen/app/modules/common/login/login_controller.dart';
import 'package:merocanteen/app/modules/vendor_modules/order_requirements/order_requirement_controller.dart';
import 'package:merocanteen/app/modules/vendor_modules/orders/order_controller.dart';
import 'package:merocanteen/app/widget/empty_cart_page.dart';
import 'package:merocanteen/app/widget/loading_screen.dart';
import 'package:intl/intl.dart';
import 'package:nepali_utils/nepali_utils.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class TotalOrdersTab extends StatefulWidget {
  @override
  State<TotalOrdersTab> createState() => _TotalOrdersTabState();
}

class _TotalOrdersTabState extends State<TotalOrdersTab> {
  final loginContorller = Get.put(LoginController());

  final orderRequestController = Get.put(OrderRequestContoller());

  int selectedIndex = -1;

  String dat = '';

  @override
  void initState() {
    super.initState();
    checkTimeAndSetDate();
  }

  void checkTimeAndSetDate() {
    DateTime currentDate = DateTime.now();
    NepaliDateTime nepaliDateTime = NepaliDateTime.fromDateTime(currentDate);

    setState(() {
      selectedIndex = 0;
      dat = DateFormat('dd/MM/yyyy\'', 'en').format(nepaliDateTime);
    });
    orderRequestController.fetchMeal(selectedIndex.toInt(), dat);
    // 1 am or later
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.white,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  itemCount: orderRequestController.timeSlots.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedIndex = index;
                            orderRequestController.fetchMeal(
                                selectedIndex.toInt(), dat);
                          });
                        },
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
                              orderRequestController.timeSlots[index],
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
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Obx(() {
                  if (orderRequestController.isLoading.value) {
                    // Show a message if there are no orders available
                    return LoadingScreen();
                  } else {
                    return Container();
                    // if (orderRequestController.orders.isEmpty) {
                    //   return EmptyCartPage(
                    //     onClick: () {},
                    //   );
                    // } else {
                    //   return ListView.builder(
                    //       shrinkWrap: true,
                    //       physics: ScrollPhysics(),
                    //       itemCount: orderRequestController.orders.length,
                    //       itemBuilder: (BuildContext context, int index) {
                    //         String productName = orderRequestController
                    //             .orders.keys
                    //             .elementAt(index);
                    //         int quantity = orderRequestController
                    //                 .totalQuantityPerProduct[productName] ??
                    //             0;
                    //         // Get the image URL from the first item of the productList (assuming all items for the same productName have the same image)
                    //         String imageUrl = orderRequestController
                    //             .orders[productName]![0].productImage;

                    //         return Padding(
                    //           padding: EdgeInsets.only(bottom: 2.0.h),
                    //           child: Container(
                    //             decoration: BoxDecoration(
                    //                 color: const Color.fromARGB(
                    //                     255, 255, 255, 255),
                    //                 borderRadius: BorderRadius.circular(10),
                    //                 border: Border.all(
                    //                     color: const Color.fromARGB(
                    //                         255, 225, 225, 225))),
                    //             child: Padding(
                    //               padding: const EdgeInsets.all(8.0),
                    //               child: Row(children: [
                    //                 Container(
                    //                   height: 60,
                    //                   width: 60,
                    //                   decoration: BoxDecoration(
                    //                       color: const Color.fromARGB(
                    //                           255, 255, 255, 255)),
                    //                   child: ClipRRect(
                    //                     borderRadius: BorderRadius.circular(10),
                    //                     child: CachedNetworkImage(
                    //                       imageUrl: imageUrl ??
                    //                           '', // Use a default empty string if URL is null
                    //                       fit: BoxFit.cover,
                    //                       errorWidget: (context, url, error) =>
                    //                           Icon(
                    //                         Icons.error_outline,
                    //                         size: 40,
                    //                       ), // Placeholder icon for error
                    //                     ),
                    //                   ),
                    //                 ),
                    //                 SizedBox(
                    //                   width: 20,
                    //                 ),
                    //                 Text('$productName',
                    //                     style: TextStyle(
                    //                         fontSize: 16,
                    //                         color: Color.fromARGB(
                    //                             255, 78, 76, 76))),
                    //                 Spacer(),
                    //                 Text(
                    //                   "$quantity-plate",
                    //                   style: AppStyles.titleStyle,
                    //                 ),
                    //               ]),
                    //             ),
                    //           ),
                    //         );
                    //       });
                    // }
                  }
                }),
              )),
        ],
      ),
    );
  }
}
