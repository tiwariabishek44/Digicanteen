import 'package:merocanteen/app/config/colors.dart';
import 'package:merocanteen/app/modules/common/login/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:merocanteen/app/modules/common/register/register_controller.dart';

class CustomizedButton extends StatelessWidget {
  final String? buttonText;
  final Color? buttonColor;
  final Color? textColor;
  final VoidCallback? onPressed;

  CustomizedButton({
    Key? key,
    this.buttonText,
    this.buttonColor,
    this.onPressed,
    this.textColor,
  }) : super(key: key);

  final logincontroller = Get.put(RegisterController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => Padding(
          padding: const EdgeInsets.all(10.0),
          child: InkWell(
            onTap: onPressed,
            child: Container(
                height: 55,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: buttonColor,
                    border: Border.all(width: 1, color: Colors.black),
                    borderRadius: BorderRadius.circular(10)),
                child: Center(
                    child: logincontroller.isregisterloading.value!
                        ? CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          )
                        : Text(
                            buttonText!,
                            style: TextStyle(
                              color: textColor,
                              fontSize: 20,
                            ),
                          ))),
          ),
        ));
  }
}
