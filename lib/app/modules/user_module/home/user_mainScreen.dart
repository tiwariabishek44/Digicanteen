import 'dart:developer';

import 'package:flutter/rendering.dart';
import 'package:get_storage/get_storage.dart';
import 'package:merocanteen/app/modules/user_module/cart/cart_controller.dart';
import 'package:merocanteen/app/modules/user_module/cart/cart_page.dart';
import 'package:merocanteen/app/modules/user_module/home/homepage.dart';
import 'package:merocanteen/app/modules/user_module/home/user_screen_controller.dart';
import 'package:merocanteen/app/config/colors.dart';
import 'package:merocanteen/app/modules/user_module/profile/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class UserMainScreenView extends StatelessWidget {
  UserMainScreenView({super.key});
  final cartcontroller = Get.put(CartController());
  final storage = GetStorage();

  final userController = Get.put(UserScreenController());

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
            child: BottomAppBar(
              color: Colors.transparent,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.transparent,
                ),
                padding: const EdgeInsets.symmetric(
                    vertical: 8), // Adjust the vertical padding
                child: Obx(
                  () => Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        flex: 3,
                        child: GestureDetector(
                          // splashColor: secondaryColor,
                          onTap: () {
                            userController.currentScreen.value = MyHomePage();
                            userController.currentTab.value = 0;
                          },
                          child: Container(
                            child: Column(
                              children: [
                                Icon(
                                  Icons.home,
                                  color: userController.currentTab.value == 0
                                      ? AppColors.primaryColor
                                      : const Color.fromARGB(255, 19, 18, 18),
                                ),
                                Text(
                                  "Home",
                                  style: TextStyle(
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.bold,
                                      color:
                                          userController.currentTab.value == 0
                                              ? AppColors.primaryColor
                                              : const Color.fromARGB(
                                                  255, 16, 16, 16)),
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
                        flex: 3,
                        child: GestureDetector(
                          // splashColor: secondaryColor,
                          onTap: () {
                            userController.currentTab.value = 1;
                            userController.currentScreen.value = CartPage();
                          },
                          child: Container(
                            child: Column(
                              children: [
                                Icon(
                                  Icons.shopping_cart_outlined,
                                  color: userController.currentTab.value == 1
                                      ? AppColors.primaryColor
                                      : const Color.fromARGB(255, 29, 28, 28),
                                ),
                                Text(
                                  "Cart",
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.bold,
                                    color: userController.currentTab.value == 1
                                        ? AppColors.primaryColor
                                        : const Color.fromARGB(255, 29, 28, 28),
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
                        flex: 3,
                        child: GestureDetector(
                          onTap: () {
                            // currentScreen = const HomeView();
                            log("USER PROFILE SCREEN CLICKED");
                            userController.currentScreen.value = ProfilePage();
                            userController.currentTab.value = 2;
                          },
                          child: Container(
                            child: Column(
                              children: [
                                Icon(
                                  Icons.person,
                                  color: userController.currentTab.value == 2
                                      ? AppColors.primaryColor
                                      : const Color.fromARGB(255, 27, 26, 26),
                                ),
                                Text(
                                  "Profile",
                                  style: TextStyle(
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.bold,
                                      color:
                                          userController.currentTab.value == 2
                                              ? AppColors.primaryColor
                                              : const Color.fromARGB(
                                                  255, 33, 31, 31)),
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
