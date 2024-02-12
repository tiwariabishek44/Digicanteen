import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:merocanteen/app/config/colors.dart';
import 'package:merocanteen/app/config/style.dart';
import 'package:merocanteen/app/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:merocanteen/app/modules/common/login/login_controller.dart';
import 'package:merocanteen/app/modules/user_module/group/group_controller.dart';
import 'package:merocanteen/app/modules/user_module/orders/orders_controller.dart';
import 'package:merocanteen/app/modules/user_module/home/product_controller.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class OrderPRoductList extends StatelessWidget {
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
                return Padding(
                  padding: EdgeInsets.only(bottom: 2.0.h),
                  child: Stack(
                    children: [
                      Container(
                        height: 15.h,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(7),
                                color: Colors.white, // Add a background color
                              ),
                              height: 15.h,
                              width: 30.w,
                              child: ClipRRect(
                                // Use ClipRRect to ensure that the curved corners are applied
                                borderRadius: BorderRadius.circular(7),
                                child: CachedNetworkImage(
                                  imageUrl: orderController.orderResponse.value
                                          .response![index].productImage ??
                                      '',
                                  fit: BoxFit.cover,
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error_outline, size: 40),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 2.w,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  orderController.orderResponse.value
                                      .response![index].productName,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppStyles.listTileTitle,
                                ),
                                Text(
                                  'Rs.${orderController.orderResponse.value.response![index].price.toStringAsFixed(2)}',
                                  style: AppStyles.listTileTitle,
                                ),
                                Text(
                                    '${orderController.orderResponse.value.response![index].customer}',
                                    style: AppStyles.listTilesubTitle),
                                Text(
                                  '${orderController.orderResponse.value.response![index].date}  ' +
                                      '(${orderController.orderResponse.value.response![index].mealtime})',
                                  style: AppStyles.listTilesubTitle,
                                ),
                                Text(
                                  '${orderController.orderResponse.value.response![index].quantity}-plate',
                                  style: AppStyles.listTilesubTitle,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        right: 1.w,
                        top: 0.h,
                        child: Icon(Icons.more_vert),
                      )
                    ],
                  ),
                );
              },
            )));
  }
}
