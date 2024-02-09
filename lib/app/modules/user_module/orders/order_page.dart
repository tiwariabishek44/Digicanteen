import 'package:get_storage/get_storage.dart';
import 'package:merocanteen/app/modules/user_module/orders/orders_controller.dart';
import 'package:merocanteen/app/modules/user_module/group/group_controller.dart';
import 'package:merocanteen/app/modules/user_module/home/home_page_controller.dart';
import 'package:merocanteen/app/widget/cart_product_list.dart';
import 'package:merocanteen/app/widget/empty_cart_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:merocanteen/app/widget/loading_screen.dart';

class OrderPage extends StatelessWidget {
  final orderContorller = Get.put(OrderController());

  Future<void> _refreshData() async {
    // Fetch data based on the selected category
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Order'),
        ),
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          child: RefreshIndicator(
            onRefresh: () => _refreshData(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Obx(() {
                    if (orderContorller.isLoading.value) {
                      return LoadingScreen();
                    } else {
                      if (orderContorller
                          .orderResponse.value.response!.isEmpty) {
                        return EmptyCartPage();
                      } else {
                        return SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "GroupCode : ",
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                              CartProductList(),
                            ],
                          ),
                        );
                      }
                    }
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
