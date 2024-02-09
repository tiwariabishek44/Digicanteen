import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:merocanteen/app/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:merocanteen/app/modules/common/login/login_controller.dart';
import 'package:merocanteen/app/modules/user_module/orders/orders_controller.dart';
import 'package:merocanteen/app/modules/user_module/home/home_page_controller.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CartProductList extends StatelessWidget {
  final logincontroller = Get.put(LoginController());

  final orderController = Get.put(OrderController());

  Future<void> _refreshData() async {}

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        onRefresh: () => _refreshData(),
        child: Obx(() => ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: orderController.orderResponse.value.response!.length,
              itemBuilder: (context, index) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 21.h,
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20)),
                            height: 19.h,
                            width: 36.w,
                            child: CachedNetworkImage(
                              imageUrl: orderController.orderResponse.value
                                      .response![index].productImage ??
                                  '',
                              fit: BoxFit.cover,
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error_outline, size: 40),
                            ),
                          ),
                          SizedBox(width: 16.0),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 8,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 8.0),
                                    Text(
                                      orderController.orderResponse.value
                                          .response![index].productName,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18.0,
                                      ),
                                    ),
                                    Text(
                                      'Rs.${orderController.orderResponse.value.response![index].price.toStringAsFixed(2)}',
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    Text(
                                      '${orderController.orderResponse.value.response![index].customer}',
                                      style: TextStyle(
                                        fontSize: 14.0,
                                        color: const Color.fromARGB(
                                            255, 134, 94, 94),
                                      ),
                                    ),
                                    Text(
                                      '${orderController.orderResponse.value.response![index].date}',
                                      style: TextStyle(
                                        fontSize: 14.0,
                                        color: const Color.fromARGB(
                                            255, 134, 94, 94),
                                      ),
                                    ),
                                    Text(
                                      '${orderController.orderResponse.value.response![index].mealtime}',
                                      style: TextStyle(
                                        fontSize: 14.0,
                                        color: const Color.fromARGB(
                                            255, 134, 94, 94),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Row(
                                  // Adding the quantity controls row

                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5.0),
                                              color: Colors.grey[200],
                                            ),
                                            child: Text(
                                              "Quantity:",
                                              style: TextStyle(fontSize: 20),
                                            )),
                                        SizedBox(width: 8.0),
                                        Text(
                                          "${orderController.orderResponse.value.response![index].quantity} /plate", // Replace with actual quantity value
                                          style: TextStyle(fontSize: 16.0),
                                        ),
                                        SizedBox(width: 8.0),
                                      ],
                                    ),
                                    // cartcontroller.orders[index].cid ==
                                    //         logincontroller.userDataResponse.value
                                    //             .response!.first.userid
                                    //     ? IconButton(
                                    //         icon: Icon(Icons.delete),
                                    //         onPressed: () {
                                    //           cartcontroller.deleteItemFromOrder(
                                    //               cartcontroller
                                    //                   .orders[index].id);
                                    //         }, // Implement delete functionality
                                    //       )
                                    //     : Container(),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      height: 0.5,
                      color: const Color.fromARGB(255, 192, 189, 189),
                    ),
                  ],
                );
              },
            )));
  }
}
