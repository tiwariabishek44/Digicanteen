import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:merocanteen/app/config/colors.dart';
import 'package:merocanteen/app/modules/common/login/login_controller.dart';
import 'package:merocanteen/app/modules/common/login/login_page.dart';
import 'package:merocanteen/app/modules/common/loginoption/login_option_view.dart';
import 'package:merocanteen/app/modules/user_module/home/user_mainScreen.dart';
import 'package:merocanteen/app/modules/vendor_modules/vendor_main_Screen/vendr_main_Screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final logincontroller = Get.put(LoginController());
  final storage = GetStorage();

  @override
  void initState() {
    super.initState();
    navigateBasedOnAuthState();
  }

  void navigateBasedOnAuthState() {
    Timer(const Duration(seconds: 3), () {
      if (storage.read('vendor') == '4455') {
        Get.offAll(() => VendorMainScreenView());
      } else {
        if (logincontroller.user.value != null) {
          // User is authenticated, navigate to UserMainScreen
          Get.offAll(() => UserMainScreenView());
        } else {
          // User is not authenticated, navigate to LoginScreen
          Get.offAll(() => LoginOptionView());
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 254, 254, 254),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromARGB(255, 186, 181, 181)
                        .withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
                image: DecorationImage(
                  image: AssetImage('assets/logo.png'),
                  fit: BoxFit.contain,
                ),
              ),
            ),
            SpinKitFadingCircle(
              color: primaryColor,
            )
          ],
        ),
      ),
    );
  }
}
