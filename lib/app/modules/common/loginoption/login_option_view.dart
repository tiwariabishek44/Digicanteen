import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:merocanteen/app/modules/common/login/login_page.dart';
import 'package:merocanteen/app/modules/common/loginoption/login_option_controller.dart';
import 'package:merocanteen/app/modules/common/loginoption/vendor_entry/vendor_entry.dart';
import 'package:merocanteen/app/modules/vendor_modules/vendor_main_Screen/vendr_main_Screen.dart';
import 'package:merocanteen/app/widget/customized_button.dart';

class LoginOptionView extends StatelessWidget {
  final loginOptionController = Get.put(LoginScreenController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Displaying image in the half of the screen height
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              image: DecorationImage(
                image: AssetImage('assets/logo.png'),
                fit: BoxFit.contain,
              ),
            ),
          ),
          // Showing information and buttons for user types
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Text(
                  'Continue as:',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                CustomButton(
                    text: 'Continue As Student',
                    onPressed: () {
                      Get.to(LoginScreen(), transition: Transition.rightToLeft);
                    },
                    isLoading: false),
                SizedBox(
                  height: 10,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: Divider(
                          color: Color.fromARGB(255, 97, 96, 96),
                          height: 0.5,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          'OR',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          color: Color.fromARGB(255, 97, 96, 96),
                          height: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                CustomButton(
                    text: 'Continue As Canteen',
                    onPressed: () {
                      Get.to(() => const VendorEntro(),
                          transition: Transition.rightToLeft);
                    },
                    isLoading: false),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
