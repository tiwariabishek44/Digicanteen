import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:merocanteen/app/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:merocanteen/app/modules/common/login/login_controller.dart';
import 'package:merocanteen/app/modules/user_module/cart/cart_controller.dart';
import 'package:merocanteen/app/modules/user_module/home/home_page_controller.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CartProductList extends StatelessWidget {
  final logincontroller = Get.put(LoginController());

  final cartcontroller = Get.put(CartController());

  Future<void> _refreshData() async {
    cartcontroller
        .fetchOrdersByGroupID(); // Fetch data based on the selected category
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => _refreshData(),
      child: Obx(() => ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: cartcontroller.orders.length,
            itemBuilder: (context, index) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 19.h,
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
                            imageUrl:
                                cartcontroller.orders[index].productImage ?? '',
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
                                    cartcontroller.orders[index].productName,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0,
                                    ),
                                  ),
                                  Text(
                                    'Rs.${cartcontroller.orders[index].price.toStringAsFixed(2)}',
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Text(
                                    '${cartcontroller.orders[index].customer}',
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      color: const Color.fromARGB(
                                          255, 134, 94, 94),
                                    ),
                                  ),
                                  Text(
                                    '${cartcontroller.orders[index].date}',
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
                                        "${cartcontroller.orders[index].quantity} /plate", // Replace with actual quantity value
                                        style: TextStyle(fontSize: 16.0),
                                      ),
                                      SizedBox(width: 8.0),
                                    ],
                                  ),
                                  cartcontroller.orders[index].cid ==
                                          logincontroller.user.value!.userid
                                      ? IconButton(
                                          icon: Icon(Icons.delete),
                                          onPressed: () {
                                            cartcontroller
                                                .deleteItemFromOrder();
                                          }, // Implement delete functionality
                                        )
                                      : Container(),
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
          )),
    );
  }
}