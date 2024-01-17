import 'package:merocanteen/app/config/font_style.dart';
import 'package:merocanteen/app/modules/common/login/login_controller.dart';
import 'package:merocanteen/app/modules/user_module/profile/group/group.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CustomTopBar extends StatelessWidget implements PreferredSizeWidget {
  final logincontroller = Get.put(LoginController());

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(255, 255, 255, 255),
      height: 9.h,
      child: Row(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            radius: 30, // Adjust the radius as needed for the circular view
            backgroundImage: AssetImage(
              'assets/logo.png', // Replace 'your_logo.png' with your logo file path
            ),
          ),
        ),
        Obx(() => Row(
              children: [
                logincontroller.user.value != null
                    ? Text(
                        "Hi,${logincontroller.user.value!.name.split(' ')[0]}",
                        textAlign: TextAlign
                            .center, // Centers text within the container
                        style: TextStyle(
                          color: Color.fromARGB(255, 73, 71, 71),
                          fontFamily: FontStyles.poppins,
                          fontSize: 18.sp, // Use screenutil for font sizing
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : Text(
                        "Hi User",
                        style: TextStyle(
                          color: Color.fromARGB(255, 73, 71, 71),
                          fontFamily: FontStyles.poppins,
                          fontSize: 20.sp, // Use screenutil for font sizing
                          fontWeight: FontWeight.bold,
                        ),
                      )
              ],
            )),
        Spacer(),
      ]),
    );
  }
}
