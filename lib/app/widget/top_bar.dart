import 'package:merocanteen/app/config/style.dart';
import 'package:merocanteen/app/modules/common/login/login_controller.dart';
import 'package:merocanteen/app/modules/user_module/group/view/group.dart';
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
        height: MediaQuery.of(context).size.height * 0.1,
        child: Obx(() => Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Hi,${logincontroller.userDataResponse.value.response!.first.name}",
                    textAlign:
                        TextAlign.center, // Centers text within the container
                    style: AppStyles.listTileTitle,
                  ),
                  Text(
                    "${logincontroller.userDataResponse.value.response!.first.classes}",
                    textAlign:
                        TextAlign.center, // Centers text within the container
                    style: AppStyles.listTilesubTitle,
                  )
                ],
              ),
            )),
      ),
    );
  }
}
