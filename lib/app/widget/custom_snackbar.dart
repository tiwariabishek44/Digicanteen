import 'dart:async';

import 'package:merocanteen/app/modules/user_module/home/homepage.dart';
import 'package:merocanteen/app/modules/user_module/home/user_mainScreen.dart';
import 'package:merocanteen/app/modules/user_module/home/user_screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomSnackbar {
    final userController = Get.put(UserScreenController());

  final String title;
  final String message;
  final Duration duration;
  final Color backgroundColor;
  final Color textColor;
  final SnackPosition snackPosition;

  CustomSnackbar({
    required this.title,
    required this.message,
    required this.duration,
    required this.backgroundColor,
    required this.textColor,
    required this.snackPosition,
  });

  void showSnackbar() {
                      
                      
                        Timer(const Duration(seconds: 1), () {
                                                      Get.back();

    
    });

    Get.snackbar(
      title,
      message,
      snackPosition: snackPosition,
      backgroundColor: backgroundColor,
      colorText: textColor,
      duration: duration,
    );
 
  }
}
