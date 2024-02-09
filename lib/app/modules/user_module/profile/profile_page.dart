import 'package:merocanteen/app/config/colors.dart';
import 'package:merocanteen/app/config/style.dart';
import 'package:merocanteen/app/modules/common/login/login_controller.dart';
import 'package:merocanteen/app/modules/user_module/group/group.dart';
import 'package:merocanteen/app/modules/user_module/profile/feed_back_page.dart';
import 'package:merocanteen/app/modules/user_module/profile/order_hisory_page.dart';
import 'package:merocanteen/app/widget/custom_app_bar.dart';
import 'package:merocanteen/app/widget/custom_listtile.dart';
import 'package:merocanteen/app/widget/logout_conformation_dialog.dart';
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
      appBar: CustomAppBar(title: 'setting'),
      body: SingleChildScrollView(
          child: Padding(
        padding: AppPadding.screenHorizontalPadding,
        child: Column(children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.02,
          ),
          Center(
            child: CircleAvatar(
              radius: MediaQuery.of(context).size.width * 0.175,
              backgroundColor: AppColors.backgroundColor,
              child: CircleAvatar(
                backgroundColor: const Color.fromARGB(255, 213, 220, 234),
                radius: MediaQuery.of(context).size.width * 0.165,
                child: Icon(
                  Icons.person_outline,
                  size: MediaQuery.of(context).size.width * 0.175,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            "Abishek Tiwari",
            style: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.w700),
          ),
          Text(
            "tiwariabishek44@gmail.com",
            style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w400),
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
            title: "Edit Profile",
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
                  return LogoutConfirmationDialog(
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
      )),
    );

    //   SingleChildScrollView(
    //       child: Column(
    //     children: [
    //       Row(
    //         mainAxisAlignment: MainAxisAlignment.end,
    //         children: [
    //           IconButton(
    //             icon: Icon(Icons.edit), // Icon for editing (pen)
    //             onPressed: () {
    //               // Handle edit button tap
    //             },
    //           ),
    //           IconButton(
    //             icon: Icon(Icons.logout), // Icon for logout
    //             onPressed: () {
    //               showDialog(
    //                 context: context,
    //                 builder: (BuildContext context) {
    //                   return LogoutConfirmationDialog(
    //                     isbutton: true,
    //                     heading: 'Alert',
    //                     subheading: "Do you want to logout of the application?",
    //                     firstbutton: "Yes",
    //                     secondbutton: 'No',
    //                     onConfirm: () {
    //                       logincontroller.logout();
    //                     },
    //                   );
    //                 },
    //               );
    //             },
    //           ),
    //         ],
    //       ),
    //       Padding(
    //         padding: const EdgeInsets.all(12.0),
    //         child: Container(
    //           decoration: BoxDecoration(
    //             shape: BoxShape.circle,
    //             color: Colors.white,
    //             boxShadow: [
    //               BoxShadow(
    //                 color: Colors.grey.withOpacity(0.5),
    //                 spreadRadius: 2,
    //                 blurRadius: 5,
    //                 offset: Offset(0, 3),
    //               ),
    //             ],
    //           ),
    //           child: CircleAvatar(
    //             backgroundColor: Colors.white,
    //             radius: 55,
    //             child: CircleAvatar(
    //                 radius: 54,
    //                 backgroundColor: Colors.white,
    //                 backgroundImage: AssetImage('assets/logo.png')),
    //           ),
    //         ),
    //       ),
    //       Text(
    //         logincontroller.userDataResponse.value.response!.first.name,
    //         style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    //       ),
    //       Text(logincontroller.userDataResponse.value.response!.first.phone),
    //       SizedBox(
    //         height: 30,
    //       ),
    //       CustomListTile(
    //         color: Colors.orange,
    //         leadingIcon: Icons.group_add_outlined,
    //         title: "Group",
    //         onTap: () {
    //           Get.to(() => GroupPage());
    //         },
    //       ),
    //       CustomListTile(
    //         color: Colors.blue,
    //         leadingIcon: Icons.shopping_cart_outlined,
    //         title: "Order History",
    //         onTap: () {
    //           Get.to(() => OrderHistoryPage());
    //         },
    //       ),
    //       CustomListTile(
    //         color: Colors.green,
    //         leadingIcon: Icons.feedback_outlined,
    //         title: "Feedback",
    //         onTap: () {
    //           Get.to(() => FeedbackPage());
    //         },
    //       ),
    //       CustomListTile(
    //         color: Colors.yellow,
    //         leadingIcon: Icons.info,
    //         title: "About and FAQ",
    //         onTap: () {},
    //       ),
    //     ],
    //   )),
    // );
  }
}
