import 'dart:developer';

import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:merocanteen/app/config/colors.dart';
import 'package:merocanteen/app/models/cart_models.dart';
import 'package:merocanteen/app/models/product_model.dart';
import 'package:merocanteen/app/modules/common/login/login_controller.dart';
import 'package:merocanteen/app/modules/user_module/cart/cart_controller.dart';
import 'package:merocanteen/app/modules/user_module/home/product_detai_page.dart';
import 'package:merocanteen/app/modules/user_module/profile/group/group_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:merocanteen/app/widget/custom_snackbar.dart';
import 'package:merocanteen/app/widget/loading_screen.dart';
import 'package:merocanteen/app/widget/logout_conformation_dialog.dart';
import 'package:merocanteen/app/widget/ordre_conformation.dart';
import 'package:nepali_utils/nepali_utils.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:intl/intl.dart';

// Define the reusable product grid widget
class ProductGrid extends StatelessWidget {
  final List<Product> productList; // Receive the product list as a parameter
  final String dat;
  ProductGrid({Key? key, required this.productList, required this.dat})
      : super(key: key);

  late List<int> quantities;
  // State to maintain quantities of each product
  final logincontroller = Get.put(LoginController());

  final groupcontroller = Get.put(GroupController());

  CartController cartController = Get.find<CartController>();

  @override
  Widget build(BuildContext context) {
    groupcontroller.fetchGroupByGroupId();

    final user = logincontroller.user.value;
    // ignore: invalid_use_of_protected_member
    final group = groupcontroller.currentGroup.value;
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // number of items in each row
          mainAxisSpacing: 10.0, // spacing between rows
          crossAxisSpacing: 10.0, // spacing between columns
          childAspectRatio: 0.67),
      padding: EdgeInsets.all(8.0), // padding around the grid
      itemCount: productList.length, // total number of items
      itemBuilder: (context, index) {
        return Container(
          decoration: const BoxDecoration(
              color: Color.fromARGB(255, 235, 230, 230),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20))),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(
              flex: 6,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20)),
                child: CachedNetworkImage(
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      SpinKitFadingCircle(
                    color: secondaryColor,
                  ),
                  imageUrl: productList[index].image ?? '',
                  fit: BoxFit.fill,
                  width: double.infinity,
                  errorWidget: (context, url, error) =>
                      Icon(Icons.error_outline, size: 40),
                ),
              ),
            ),
            Expanded(
                flex: 4,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("${productList[index].name}",
                            style: TextStyle(fontSize: 17)),
                        Text("Rs ${productList[index].price.toInt()}/plate",
                            style: TextStyle(fontSize: 13)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Obx(() {
                              if (groupcontroller.isloading.value) {
                                return LoadingScreen();
                              } else {
                                return GestureDetector(
                                  onTap: () async {
                                    user!.groupid.isNotEmpty
                                        ? showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return OrderConfirmationDialog(
                                                date: dat,
                                                price: productList[index]
                                                    .price
                                                    .toInt()
                                                    .toString(),
                                                image: productList[index].image,
                                                onConfirm: () {
                                                  cartController.addItemToOrder(
                                                      mealtime: cartController
                                                          .mealTime.value,
                                                      classs: user!.classes,
                                                      date: dat,
                                                      checkout: 'false',
                                                      customer: user.name,
                                                      groupcod: group != null
                                                          ? group.groupCode
                                                          : "",
                                                      groupid: user.groupid,
                                                      cid: user.userid,
                                                      productName:
                                                          productList[index]
                                                              .name,
                                                      price: productList[index]
                                                          .price,
                                                      quantity: 1,
                                                      productImage:
                                                          productList[index]
                                                              .image);

                                                  Get.back();

                                                  CustomSnackbar(
                                                    backgroundColor:
                                                        Color.fromARGB(
                                                            255, 227, 226, 220),
                                                    title: 'Success',
                                                    message:
                                                        'Your order has been placed!',
                                                    duration:
                                                        Duration(seconds: 4),
                                                    textColor: Colors.black87,
                                                    snackPosition:
                                                        SnackPosition.BOTTOM,
                                                  ).showSnackbar();
                                                },
                                                pname: productList[index].name,
                                              );
                                            },
                                          )
                                        : showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return LogoutConfirmationDialog(
                                                isbutton: false,
                                                heading:
                                                    'You are not in any group',
                                                subheading:
                                                    "Make a group or join a group",
                                                firstbutton: "Ok",
                                                secondbutton: 'Cancle',
                                                onConfirm: () {},
                                              );
                                            },
                                          );

                                    // Handle add to cart functionality
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.red
                                            .shade200, // 4/10 of the screen width
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: const Padding(
                                      padding: EdgeInsets.all(5.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Icon(Icons.shopping_cart),
                                          SizedBox(
                                              width:
                                                  8), // Add some space between icon and text
                                          Text('Add  '),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }
                            })
                          ],
                        ),
                      ]),
                ))
          ]),
        );
      },
    );
  }
}
