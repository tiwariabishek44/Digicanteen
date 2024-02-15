import 'dart:developer';

import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:merocanteen/app/config/colors.dart';
import 'package:merocanteen/app/config/style.dart';
import 'package:merocanteen/app/modules/common/login/login_controller.dart';
import 'package:merocanteen/app/modules/user_module/add%20product/add_product_controller.dart';
import 'package:merocanteen/app/modules/user_module/group/view/group.dart';
import 'package:merocanteen/app/modules/user_module/group/view/group_Creation_view.dart';
import 'package:merocanteen/app/modules/user_module/home/product_controller.dart';
import 'package:merocanteen/app/modules/user_module/group/group_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:merocanteen/app/widget/confirmation_dialog.dart';
import 'package:merocanteen/app/modules/user_module/add%20product/view/ordre_conformation.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

// Define the reusable product grid widget
class ProductGrid extends StatelessWidget {
  final String dat;
  ProductGrid({Key? key, required this.dat}) : super(key: key);

  // State to maintain quantities of each product
  final logincontroller = Get.put(LoginController());
  final productContorller = Get.put(ProductController());

  final groupcontroller = Get.put(GroupController());
  final addproductController = Get.put(AddProductController());
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // number of items in each row
          mainAxisSpacing: 20.0, // spacing between rows
          crossAxisSpacing: 20.0, // spacing between columns
          childAspectRatio: 0.72),
      itemCount: productContorller
          .allProductResponse.value.response!.length, // total number of items
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () async {
            logincontroller
                    .userDataResponse.value.response!.first.groupid.isNotEmpty
                ? showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return OrderConfirmationDialog(
                        user: logincontroller
                            .userDataResponse.value.response!.first,
                        product: productContorller
                            .allProductResponse.value.response![index],
                        date: dat,
                      );
                    },
                  )
                : showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return ConfirmationDialog(
                        isbutton: true,
                        heading: 'You are not in any group',
                        subheading: "Make a group or join a group",
                        firstbutton: "Create A group",
                        secondbutton: 'Cancle',
                        onConfirm: () {
                          Get.to(() => GroupPage(),
                              transition: Transition.rightToLeft);
                        },
                      );
                    },
                  );

            // Handle add to cart functionality
          },
          child: Container(
            decoration: const BoxDecoration(
                color: AppColors.lightColor,
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
                      topRight: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                      bottomLeft: Radius.circular(20)),
                  child: CachedNetworkImage(
                    progressIndicatorBuilder:
                        (context, url, downloadProgress) => SpinKitFadingCircle(
                      color: AppColors.secondaryColor,
                    ),
                    imageUrl: productContorller
                            .allProductResponse.value.response![index].image ??
                        '',
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
                          Text(
                              "${productContorller.allProductResponse.value.response![index].name}",
                              style: AppStyles.listTileTitle),
                          Text(
                              "Rs ${productContorller.allProductResponse.value.response![index].price.toInt()}/plate",
                              style: AppStyles.listTilesubTitle),
                        ]),
                  ))
            ]),
          ),
        );
      },
    );
  }
}
