import 'dart:developer';

import 'package:get/get.dart';
import 'package:merocanteen/app/config/colors.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:merocanteen/app/modules/vendor_modules/orders/order_controller.dart';
import 'package:merocanteen/app/modules/vendor_modules/widget/empty_order.dart';
import 'package:merocanteen/app/modules/vendor_modules/widget/no_order.dart';
import 'package:merocanteen/app/widget/customized_button.dart';
import 'package:merocanteen/app/widget/empty_cart_page.dart';
import 'package:merocanteen/app/widget/loading_screen.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class OrderPage extends StatelessWidget {
  final ordercontroller = Get.put(OrderController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Orders"),
      ),
      body: Column(
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
                      borderSide:
                          const BorderSide(color: Color(0xffE8ECF4), width: 1),
                      borderRadius: BorderRadius.circular(10)),
                  focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Color(0xffE8ECF4), width: 1),
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
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: 19.h,
                                      padding: EdgeInsets.all(8.0),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20)),
                                            height: 19.h,
                                            width: 36.w,
                                            child: CachedNetworkImage(
                                              imageUrl: ordercontroller
                                                      .orders[index]
                                                      .productImage ??
                                                  '',
                                              fit: BoxFit.cover,
                                              errorWidget:
                                                  (context, url, error) => Icon(
                                                      Icons.error_outline,
                                                      size: 40),
                                            ),
                                          ),
                                          SizedBox(
                                              width:
                                                  16.0), // Adjust spacing between image and text
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                flex:
                                                    2, // Adjust text area size as needed
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    SizedBox(height: 8.0),
                                                    Text(
                                                      ordercontroller
                                                          .orders[index]
                                                          .productName,
                                                      maxLines:
                                                          2, // Set the maximum lines to display
                                                      overflow: TextOverflow
                                                          .ellipsis, // Show ellipsis when overflowing
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 20.0,
                                                      ),
                                                    ),
                                                    SizedBox(height: 8.0),
                                                    Text(
                                                      'Rs.${ordercontroller.orders[index].price.toStringAsFixed(2)}',
                                                      style: TextStyle(
                                                        fontSize: 20.0,
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                                    Text(
                                                      '${ordercontroller.orders[index].customer}',
                                                      style: TextStyle(
                                                        fontSize: 14.0,
                                                        color: const Color
                                                            .fromARGB(
                                                            255, 134, 94, 94),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Row(
                                                // Adding the quantity controls row
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5.0),
                                                            color: Colors
                                                                .grey[200],
                                                          ),
                                                          child: Text(
                                                            "Quantity:",
                                                            style: TextStyle(
                                                                fontSize: 20),
                                                          )),
                                                      SizedBox(width: 8.0),
                                                      Text(
                                                        "${ordercontroller.orders[index].quantity}", // Replace with actual quantity value
                                                        style: TextStyle(
                                                            fontSize: 16.0),
                                                      ),
                                                      SizedBox(width: 8.0),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    width: 12.w,
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),

                                    Divider(
                                        height: 0.5,
                                        color: const Color.fromARGB(
                                            255,
                                            192,
                                            189,
                                            189)), // Thin divider at the bottom
                                  ],
                                );
                              },
                            ),
                            CustomizedButton(
                              onPressed: () {
                                FocusScope.of(context).unfocus();
                                ordercontroller.deleteGroupOrder(
                                    ordercontroller.groupcod.text.trim());
                              },
                              buttonText:
                                  "Check Out(${ordercontroller.groupcod.text})",
                              buttonColor: primaryColor,
                              textColor: Colors.white,
                            ),
                          ],
                        ),
                      );
                    }
                  }
                }
              })),
        ],
      ),
    );
  }
}
