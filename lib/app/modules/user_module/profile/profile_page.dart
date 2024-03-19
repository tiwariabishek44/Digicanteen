import 'package:cached_network_image/cached_network_image.dart';
import 'package:merocanteen/app/config/colors.dart';
import 'package:merocanteen/app/config/style.dart';
import 'package:merocanteen/app/modules/common/login/login_controller.dart';
import 'package:merocanteen/app/modules/user_module/group/view/group.dart';
import 'package:merocanteen/app/modules/user_module/profile/feed_back_page.dart';
import 'package:merocanteen/app/modules/user_module/order_history/view/order_hisory_page.dart';
import 'package:merocanteen/app/modules/user_module/profile/order_holds_view.dart';
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
                    CircleAvatar(
                      radius: 12.w,
                      backgroundColor:
                          Colors.transparent, // Ensure transparent background
                      child: CachedNetworkImage(
                        imageUrl: logincontroller.userDataResponse.value
                                .response!.first.profilePicture ??
                            '',
                        imageBuilder: (context, imageProvider) => Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle, // Apply circular shape
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        placeholder: (context, url) =>
                            CircularProgressIndicator(), // Placeholder widget while loading
                        errorWidget: (context, url, error) => CircleAvatar(
                          radius: 21.sp,
                          child: Icon(
                            Icons.person,
                            color: Colors.white,
                          ),
                          backgroundColor:
                              const Color.fromARGB(255, 224, 218, 218),
                        ),
                      ),
                    )
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
                  Get.to(() => OrderHoldsView(),
                      transition: Transition.rightToLeft, duration: duration);
                },
                title: "Order Holds ",
                leadingIcon: const Icon(Icons.stop_circle_outlined),
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
