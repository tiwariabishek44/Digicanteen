import 'package:merocanteen/app/modules/common/login/login_controller.dart';
import 'package:merocanteen/app/modules/user_module/group/group.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CustomTopBar extends StatelessWidget implements PreferredSizeWidget {
  final logincontroller = Get.put(LoginController());

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color.fromARGB(255, 129, 98, 89), // Start color
              Color(0xFFd84315), // Mid color
              Color.fromARGB(255, 138, 184, 192), // End color
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3),
            ),
          ],
        ),
        height: MediaQuery.of(context).size.height * 0.1,
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
          Obx(() => Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Hi,${logincontroller.userDataResponse.value.response!.first.name}",
                      textAlign:
                          TextAlign.center, // Centers text within the container
                      style: TextStyle(
                        color: Color.fromARGB(255, 222, 215, 215),
                        fontSize: 18.sp, // Use screenutil for font sizing
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "${logincontroller.userDataResponse.value.response!.first.classes}",
                      textAlign:
                          TextAlign.center, // Centers text within the container
                      style: TextStyle(
                        color: Color.fromARGB(255, 222, 215, 215),
                        fontSize: 15.sp, // Use screenutil for font sizing
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
              )),
          Spacer(),
        ]),
      ),
    );
  }
}
