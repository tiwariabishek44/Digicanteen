import 'dart:developer';

import 'package:merocanteen/app/modules/user_module/cart/cart_controller.dart';
import 'package:merocanteen/app/config/colors.dart';
import 'package:merocanteen/app/config/font_style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:merocanteen/app/modules/vendor_modules/allproducts/homeSCreen.dart';
import 'package:merocanteen/app/modules/vendor_modules/orders/orders_screen.dart';
import 'package:merocanteen/app/modules/vendor_modules/dashboard/dashboard_page.dart';
import 'package:merocanteen/app/modules/vendor_modules/vendor_main_Screen/main_screen_controller.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class VendorMainScreenView extends StatelessWidget {
  VendorMainScreenView({super.key});
  final cartcontroller = Get.put(CartController());

  final userController = Get.put(VendorScreenController());

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.white,
          body: Obx(
            () => SafeArea(
              child: PageStorage(
                bucket: userController.bucket,
                child: userController.currentScreen.value,
              ),
            ),
          ),
          bottomNavigationBar: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
            ),
            child: BottomAppBar(
              color: Color.fromARGB(255, 9, 6, 6),
              child: Container(
                height: 0.07.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15.sp),
                    topRight: Radius.circular(15.sp),
                  ),
                ),
                padding: const EdgeInsets.all(8),
                child: Obx(
                  () => Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: GestureDetector(
                          // splashColor: secondaryColor,
                          onTap: () {
                            userController.currentScreen.value = VHomePage();
                            userController.currentTab.value = 0;
                          },
                          child: Container(
                            child: Column(
                              children: [
                                Icon(
                                  Icons.home,
                                  color: userController.currentTab.value == 0
                                      ? primaryColor
                                      : Colors.white,
                                ),
                                Text(
                                  "Home",
                                  style: TextStyle(
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: FontStyles.poppins,
                                      color:
                                          userController.currentTab.value == 0
                                              ? primaryColor
                                              : Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      Expanded(
                        child: GestureDetector(
                          // splashColor: secondaryColor,
                          onTap: () {
                            userController.currentTab.value = 1;
                            userController.currentScreen.value = OrderPage();
                          },
                          child: Container(
                            child: Column(
                              children: [
                                Icon(
                                  Icons.search,
                                  color: userController.currentTab.value == 1
                                      ? primaryColor
                                      : Colors.white,
                                ),
                                Text(
                                  "Search",
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: FontStyles.poppins,
                                    color: userController.currentTab.value == 1
                                        ? primaryColor
                                        : Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            // currentScreen = const HomeView();
                            log("USER PROFILE SCREEN CLICKED");
                            userController.currentScreen.value = DshBoard();
                            userController.currentTab.value = 2;
                          },
                          child: Container(
                            child: Column(
                              children: [
                                Icon(
                                  Icons.dashboard,
                                  color: userController.currentTab.value == 2
                                      ? primaryColor
                                      : Colors.white,
                                ),
                                Text(
                                  "Dashboard",
                                  style: TextStyle(
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: FontStyles.poppins,
                                      color:
                                          userController.currentTab.value == 3
                                              ? primaryColor
                                              : Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}