import 'package:merocanteen/app/config/colors.dart';
import 'package:merocanteen/app/config/style.dart';
import 'package:merocanteen/app/modules/common/login/login_controller.dart';
import 'package:merocanteen/app/modules/user_module/group/view/group.dart';
import 'package:merocanteen/app/modules/user_module/profile/feed_back_page.dart';
import 'package:merocanteen/app/modules/user_module/order_history/view/order_hisory_page.dart';
import 'package:merocanteen/app/widget/custom_app_bar.dart';
import 'package:merocanteen/app/widget/custom_listtile.dart';
import 'package:merocanteen/app/widget/custom_loging_widget.dart';
import 'package:merocanteen/app/widget/confirmation_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:merocanteen/app/widget/profile_tile.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ProfilePage extends StatelessWidget {
  final logincontroller = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SingleChildScrollView(
          child: Padding(
        padding: AppPadding.screenHorizontalPadding,
        child: Stack(
          children: [
            Column(children: [
              Padding(
                padding: EdgeInsets.only(top: 6.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Obx(() => Text(
                          logincontroller
                              .userDataResponse.value.response!.first.name,
                          style: AppStyles.mainHeading,
                        )),
                    Center(
                      child: Container(
                        height: 35.sp,
                        width: 35.sp,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            image: DecorationImage(
                              image: AssetImage('assets/person.png'),
                            )),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ProfileTile(
                onTap: () {
                  // Get.to(() => const EditProfilePage(),
                  //     transition: Transition.rightToLeft,
                  //     duration: duration);
                },
                title: "Profile",
                leadingIcon: const Icon(Icons.person),
              ),
              ProfileTile(
                onTap: () {
                  Get.to(() => GroupPage(),
                      transition: Transition.rightToLeft, duration: duration);
                },
                title: "Groups",
                leadingIcon: const Icon(Icons.group),
              ),
              ProfileTile(
                onTap: () {
                  Get.to(() => OrderHistoryPage(),
                      transition: Transition.rightToLeft, duration: duration);
                },
                title: "Order History",
                leadingIcon: const Icon(Icons.shopping_cart_checkout_sharp),
              ),
              ProfileTile(
                onTap: () {
                  // Get.to(() => const AllTransctionPage(),
                  //     transition: Transition.rightToLeft,
                  // duration: duration);
                },
                title: "All Transctions",
                leadingIcon: const Icon(Icons.attach_money),
              ),
              ProfileTile(
                onTap: () {
                  // Get.to(() => const AllTransctionPage(),
                  //     transition: Transition.rightToLeft,
                  // duration: duration);
                },
                title: "Fine",
                leadingIcon: const Icon(Icons.attach_money),
              ),
              ProfileTile(
                onTap: () {
                  // Get.to(() => AboutUsPage(),
                  //     transition: Transition.rightToLeft, duration: duration);
                },
                title: "About Us",
                leadingIcon: const Icon(Icons.attach_money),
              ),
              ProfileTile(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return ConfirmationDialog(
                        isbutton: true,
                        heading: 'Alert',
                        subheading: "Do you want to logout of the application?",
                        firstbutton: "Yes",
                        secondbutton: 'No',
                        onConfirm: () {
                          logincontroller.logout();
                        },
                      );
                    },
                  );
                },
                title: "Logout",
                leadingIcon: const Icon(
                  Icons.logout,
                ),
              )
            ]),
            logincontroller.isloading.value
                ? LoadingWidget()
                : const SizedBox.shrink()
          ],
        ),
      )),
    );
  }
}
