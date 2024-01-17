import 'package:merocanteen/app/modules/common/login/login_controller.dart';
import 'package:merocanteen/app/modules/common/register/user_entry_controller.dart';
import 'package:merocanteen/app/widget/customized_button.dart';
import 'package:merocanteen/app/widget/customized_textfield.dart';
import 'package:merocanteen/app/widget/welcome_heading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserEntry extends StatelessWidget {
  final logincontroller = Get.put(LoginController());
  final userentryController = Get.put(UserNameController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: logincontroller.vendorLoginFromkey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black, width: 1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: IconButton(
                              icon: const Icon(Icons.arrow_back_ios_sharp),
                              onPressed: () {
                                Get.back();
                              }),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 100,
                    ),
                    WelcomeHeading(
                      mainHeading: 'Welcome to HamroCanteen',
                      subHeading: "Continue As a Student",
                    ),
                    SizedBox(height: 10),
                    CustomizedTextfield(
                      validator: userentryController.usernameValidator,
                      icon: Icons.view_agenda_rounded,
                      myController: userentryController.namecontroller,
                      hintText: "Enter Student Code",
                    ),
                    CustomizedButton(
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        userentryController.checkUsername();
                      },
                      buttonText: "Continue",
                      buttonColor: Colors.black,
                      textColor: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
