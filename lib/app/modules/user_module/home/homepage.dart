import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:merocanteen/app/config/colors.dart';
import 'package:merocanteen/app/modules/user_module/home/home_page_controller.dart';
import 'package:merocanteen/app/widget/loading_screen.dart';
import 'package:merocanteen/app/widget/no_data_widget.dart';
import 'package:merocanteen/app/widget/product_gridview.dart';
import 'package:merocanteen/app/widget/top_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyHomePage extends StatelessWidget {
  final homepagecontroller = Get.put(HomepageContoller());

  Future<void> _refreshData() async {
    homepagecontroller
        .fetchProducts(); // Fetch data based on the selected category
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomTopBar(),
      body: RefreshIndicator(
        onRefresh: () => _refreshData(),
        child: Center(
          child: Obx(() {
            if (homepagecontroller.isloading.value) {
              return LoadingScreen();
            } else {
              return homepagecontroller.products.isEmpty
                  ? NoDataWidget(
                      message: "There is no news",
                      iconData: Icons.error_outline)
                  : SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  color: secondaryColor,
                                  borderRadius: BorderRadius.circular(20)),
                              height: MediaQuery.of(context).size.height * 0.3,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: CachedNetworkImage(
                                  progressIndicatorBuilder:
                                      (context, url, downloadProgress) =>
                                          SpinKitFadingCircle(
                                    color: secondaryColor,
                                  ),
                                  imageUrl:
                                      'https://newspaperads.ads2publish.com/wp-content/uploads/2018/11/zomato-no-cooking-sunday-enjoy-50-off-ad-times-of-india-mumbai-25-11-2018.png' ??
                                          '',
                                  fit: BoxFit.fill,
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error_outline, size: 40),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Popular Meals",
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                          ProductGrid(
                            productList: homepagecontroller.products,
                          ),
                        ],
                      ),
                    );
            }
          }),
        ),
      ),
    );
  }
}
