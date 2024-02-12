import 'dart:developer';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:merocanteen/app/config/colors.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:merocanteen/app/config/style.dart';
import 'package:merocanteen/app/modules/vendor_modules/orders/order_controller.dart';
import 'package:merocanteen/app/modules/vendor_modules/widget/empty_order.dart';
import 'package:merocanteen/app/modules/vendor_modules/widget/no_order.dart';
import 'package:merocanteen/app/widget/customized_button.dart';
import 'package:merocanteen/app/widget/empty_cart_page.dart';
import 'package:merocanteen/app/widget/loading_screen.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class OrderCheckoutPage extends StatelessWidget {
  final ordercontroller = Get.put(OrderController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: Text(
          "Orders",
          style: AppStyles.appbar,
        ),
      ),
      body: Padding(
        padding: AppPadding.screenHorizontalPadding,
        child: Column(
          children: [
            Container(
                color: Colors.white,
                child: TextField(
                  onChanged: (value) {
                    log(value);
                    ordercontroller.fetchOrdersByGroupID(value!);
                  },
                  controller: ordercontroller.groupcod,
                  decoration: InputDecoration(
                    prefixIcon: IconButton(
                      icon: Icon(
                        Icons.search,
                        color: Colors.grey,
                        size: 30,
                      ),
                      onPressed: () {},
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Color(0xffE8ECF4), width: 1),
                        borderRadius: BorderRadius.circular(10)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Color(0xffE8ECF4), width: 1),
                        borderRadius: BorderRadius.circular(10)),
                    fillColor: const Color(0xffE8ECF4),
                    filled: true,
                    hintText: 'Group Code',
                    hintStyle: TextStyle(color: Colors.black),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                )),
            SizedBox(
              height: 2.h,
            ),
            Expanded(
                flex: 9,
                child: Obx(() {
                  if (ordercontroller.orders.value!.isEmpty) {
                    return EmptyOrderPage();
                  } else {
                    if (ordercontroller.isloading.value!) {
                      return LoadingScreen();
                    } else {
                      if (ordercontroller.orders.value!.isEmpty) {
                        return NoOrderPage();
                      } else {
                        return SingleChildScrollView(
                          child: Column(
                            children: [
                              ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: ordercontroller.orders.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: EdgeInsets.only(bottom: 2.0.h),
                                    child: Container(
                                      height: 15.h,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(7),
                                              color: Colors
                                                  .white, // Add a background color
                                            ),
                                            height: 15.h,
                                            width: 30.w,
                                            child: ClipRRect(
                                              // Use ClipRRect to ensure that the curved corners are applied
                                              borderRadius:
                                                  BorderRadius.circular(7),
                                              child: CachedNetworkImage(
                                                imageUrl: ordercontroller
                                                        .orders[index]
                                                        .productImage ??
                                                    '',
                                                fit: BoxFit.cover,
                                                errorWidget: (context, url,
                                                        error) =>
                                                    Icon(Icons.error_outline,
                                                        size: 40),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 2.w,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                ordercontroller
                                                    .orders[index].productName,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: AppStyles.listTileTitle,
                                              ),
                                              Text(
                                                'Rs.${ordercontroller.orders[index].price.toStringAsFixed(2)}',
                                                style: AppStyles.listTileTitle,
                                              ),
                                              Text(
                                                  '${ordercontroller.orders[index].customer}',
                                                  style: AppStyles
                                                      .listTilesubTitle),
                                              Text(
                                                '${ordercontroller.orders[index].date}' +
                                                    '(${ordercontroller.orders[index].mealtime})',
                                                style:
                                                    AppStyles.listTilesubTitle,
                                              ),
                                              Text(
                                                '${ordercontroller.orders[index].quantity}-plate',
                                                style:
                                                    AppStyles.listTilesubTitle,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                              CustomButton(
                                  text:
                                      "Check Out(${ordercontroller.groupcod.text})",
                                  onPressed: () {
                                    FocusScope.of(context).unfocus();
                                    ordercontroller.checkoutGroupOrder(
                                        context, ordercontroller.groupcod.text);
                                  },
                                  isLoading:
                                      ordercontroller.checkoutLoading.value)
                            ],
                          ),
                        );
                      }
                    }
                  }
                })),
          ],
        ),
      ),
    );
  }
}
