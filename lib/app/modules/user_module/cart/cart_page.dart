import 'package:merocanteen/app/modules/user_module/cart/cart_controller.dart';
import 'package:merocanteen/app/modules/user_module/profile/group/group_controller.dart';
import 'package:merocanteen/app/modules/user_module/home/home_page_controller.dart';
import 'package:merocanteen/app/widget/cart_product_list.dart';
import 'package:merocanteen/app/widget/empty_cart_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:merocanteen/app/widget/loading_screen.dart';

class CartPage extends StatelessWidget {
  final cartcontroller = Get.put(CartController());

  Future<void> _refreshData() async {
    cartcontroller
        .fetchOrdersByGroupID(); // Fetch data based on the selected category
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Cart'),
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
                    if (cartcontroller.orders.value.isEmpty) {
                      cartcontroller.fetchOrdersByGroupID();
                      return EmptyCartPage();
                    } else {
                      if (cartcontroller.isloading.value) {
                        return LoadingScreen();
                      } else {
                        return SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "GroupCode : ${cartcontroller.orders.value![0].groupcod}",
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
