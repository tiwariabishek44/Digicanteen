import 'dart:developer';

import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:merocanteen/app/config/colors.dart';
import 'package:merocanteen/app/modules/common/login/login_controller.dart';
import 'package:merocanteen/app/modules/user_module/add%20product/add_product_controller.dart';
import 'package:merocanteen/app/modules/user_module/home/home_page_controller.dart';
import 'package:merocanteen/app/modules/user_module/group/group_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:merocanteen/app/widget/logout_conformation_dialog.dart';
import 'package:merocanteen/app/widget/ordre_conformation.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

// Define the reusable product grid widget
class ProductGrid extends StatelessWidget {
  final String dat;
  ProductGrid({Key? key, required this.dat}) : super(key: key);

  late List<int> quantities;
  // State to maintain quantities of each product
  final logincontroller = Get.put(LoginController());
  final productContorller = Get.put(HomepageContoller());

  final groupcontroller = Get.put(GroupController());
  final addproductController = Get.put(AddProductController());
  @override
  Widget build(BuildContext context) {
    final user = logincontroller.user.value;
    // ignore: invalid_use_of_protected_member
    final group = groupcontroller.currentGroup.value;
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // number of items in each row
          mainAxisSpacing: 20.0, // spacing between rows
          crossAxisSpacing: 20.0, // spacing between columns
          childAspectRatio: 0.72),
      padding: EdgeInsets.all(8.0), // padding around the grid
      itemCount: productContorller
          .allProductResponse.value.response!.length, // total number of items
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () async {
            user!.groupid.isNotEmpty
                ? showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return OrderConfirmationDialog(
                        date: dat,
                        price: productContorller
                            .allProductResponse.value.response![index].price
                            .toInt()
                            .toString(),
                        image: productContorller
                            .allProductResponse.value.response![index].image,
                        onConfirm: () {
                          addproductController.addItemToOrder(
                              mealtime: "addproductController.mealTime.value",
                              classs: user!.classes,
                              date: dat,
                              checkout: 'false',
                              customer: user.name,
                              groupcod: group != null ? group.groupCode : "",
                              groupid: user.groupid,
                              cid: user.userid,
                              productName: productContorller.allProductResponse
                                  .value.response![index].name,
                              price: productContorller.allProductResponse.value
                                  .response![index].price,
                              quantity: 1,
                              productImage: productContorller.allProductResponse
                                  .value.response![index].image);

                          Get.back();
                        },
                        pname: productContorller
                            .allProductResponse.value.response![index].name,
                      );
                    },
                  )
                : showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return LogoutConfirmationDialog(
                        isbutton: false,
                        heading: 'You are not in any group',
                        subheading: "Make a group or join a group",
                        firstbutton: "Ok",
                        secondbutton: 'Cancle',
                        onConfirm: () {},
                      );
                    },
                  );

            // Handle add to cart functionality
          },
          child: Container(
            decoration: const BoxDecoration(
                color: Color.fromARGB(255, 203, 200, 200),
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
                              style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w600)),
                          Text(
                              "Rs ${productContorller.allProductResponse.value.response![index].price.toInt()}/plate",
                              style: TextStyle(fontSize: 17.sp)),
                        ]),
                  ))
            ]),
          ),
        );
      },
    );
  }
}
