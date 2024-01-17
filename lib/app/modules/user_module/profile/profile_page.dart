import 'package:merocanteen/app/config/colors.dart';
import 'package:merocanteen/app/config/font_style.dart';
import 'package:merocanteen/app/modules/common/login/login_controller.dart';
import 'package:merocanteen/app/modules/user_module/profile/group/group.dart';
import 'package:merocanteen/app/modules/user_module/profile/feed_back_page.dart';
import 'package:merocanteen/app/modules/user_module/profile/my_profile/my_profile.dart';
import 'package:merocanteen/app/modules/user_module/profile/order_hisory_page.dart';
import 'package:merocanteen/app/widget/custom_listtile.dart';
import 'package:merocanteen/app/widget/logout_conformation_dialog.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ProfilePage extends StatelessWidget {
  final logincontroller = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      body: SingleChildScrollView(
          child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: Icon(Icons.edit), // Icon for editing (pen)
                onPressed: () {
                  // Handle edit button tap
                },
              ),
              IconButton(
                icon: Icon(Icons.logout), // Icon for logout
                onPressed: () {
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
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: CircleAvatar(
                backgroundColor: Colors.white,
                radius: 55,
                child: CircleAvatar(
                    radius: 54,
                    backgroundColor: Colors.white,
                    backgroundImage: AssetImage('assets/logo.png')),
              ),
            ),
          ),
          Text(
            logincontroller.user.value!.name,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(logincontroller.user.value!.phone),
          SizedBox(
            height: 30,
          ),
          CustomListTile(
            color: Colors.orange,
            leadingIcon: Icons.group_add_outlined,
            title: "Group",
            onTap: () {
              Get.to(() => GroupPage());
            },
          ),
          CustomListTile(
            color: Colors.blue,
            leadingIcon: Icons.shopping_cart_outlined,
            title: "Order History",
            onTap: () {
              Get.to(() => OrderHistoryPage());
            },
          ),
          CustomListTile(
            color: Colors.purple,
            leadingIcon: Icons.remove_shopping_cart_outlined,
            title: "Red List",
            onTap: () {},
          ),
          CustomListTile(
            color: Colors.green,
            leadingIcon: Icons.feedback_outlined,
            title: "Feedback",
            onTap: () {
              Get.to(() => FeedbackPage());
            },
          ),
          CustomListTile(
            color: Colors.yellow,
            leadingIcon: Icons.info,
            title: "About and FAQ",
            onTap: () {},
          ),
        ],
      )),
    );
  }
}
