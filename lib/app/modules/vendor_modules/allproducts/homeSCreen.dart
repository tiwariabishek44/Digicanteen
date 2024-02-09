import 'package:merocanteen/app/modules/common/login/login_controller.dart';
import 'package:merocanteen/app/modules/user_module/orders/orders_controller.dart';
import 'package:merocanteen/app/modules/user_module/home/home_page_controller.dart';
import 'package:merocanteen/app/modules/vendor_modules/widget/product_grid_view.dart';
import 'package:merocanteen/app/widget/loading_screen.dart';
import 'package:merocanteen/app/widget/no_data_widget.dart';
import 'package:merocanteen/app/widget/product_gridview.dart';
import 'package:merocanteen/app/widget/top_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class VHomePage extends StatelessWidget {
  final homepagecontroller = Get.put(HomepageContoller());
  final logincontroller = Get.put(LoginController());

  Future<void> _refreshData(String category) async {
    // myDataController.fetchData(category); // Fetch data based on the selected category
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Canteen Meals",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 251, 249, 249),
      body: Center(
        child: Obx(() {
          if (homepagecontroller.isLoading.value) {
            return LoadingScreen();
          } else {
            return homepagecontroller.products.isEmpty
                ? NoDataWidget(
                    message: "There is no Data", iconData: Icons.error_outline)
                : VendorProductGrid(
                    productList: homepagecontroller.products,
                  );
          }
        }),
      ),
    );
  }
}
