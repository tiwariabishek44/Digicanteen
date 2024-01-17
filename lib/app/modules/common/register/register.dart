import 'package:flutter/gestures.dart';
import 'package:merocanteen/app/config/colors.dart';
import 'package:merocanteen/app/config/font_style.dart';
import 'package:merocanteen/app/modules/common/login/login_controller.dart';
import 'package:merocanteen/app/modules/common/register/register_controller.dart';
import 'package:merocanteen/app/widget/customized_button.dart';
import 'package:merocanteen/app/widget/customized_textfield.dart';
import 'package:merocanteen/app/widget/welcome_heading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class RegisterPage extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api

  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final registercontroller = Get.put(RegisterController());
  String? _selectedOption;
  final List<String> options = [
    'BscCSIT-1st Sem',
    'BscCSIT-2nd Sem',
    'BscCSIT-3rd Sem',
    'BscCSIT-4th Sem',
    'BscCSIT-5th Sem',
    'BscCSIT-6th Sem',
    'BscCSIT-7th Sem',
    'BscCSIT-8th Sem',
    'BCA-1st Sem',
    'BCA-2nd Sem',
    'BCA-3rd Sem',
    'BCA-4th Sem',
    'BCA-5th Sem',
    'BCA-6th Sem',
    'BCA-7th Sem',
    'BCA-8th Sem',
  ];
  // Replace with your own options

  bool _isPasswordVisible = false;
  bool _isconrnformPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Container(
              color: Colors.white,
              width: MediaQuery.of(context).size.width,
              height: context.height,
              child: SafeArea(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(children: [
                  Expanded(
                      child: SingleChildScrollView(
                          child: Form(
                    key: registercontroller.registerFromkey,
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.black, width: 1),
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
                        WelcomeHeading(
                            mainHeading:
                                "Let's Start ${registercontroller.userNameController.namecontroller.text}",
                            subHeading: 'Create a new account'),
                        SizedBox(height: 10),
                        CustomizedTextfield(
                          validator: registercontroller.usernameValidator,
                          icon: Icons.email,
                          myController: registercontroller.emailcontroller,
                          hintText: "Email",
                        ),
                        CustomizedTextfield(
                          validator: registercontroller.phoneValidator,
                          icon: Icons.phone,
                          myController: registercontroller.phonenocontroller,
                          hintText: "Phone",
                        ),
                        CustomizedTextfield(
                          validator: registercontroller.usernameValidator,
                          icon: Icons.person,
                          myController: registercontroller.namecontroller,
                          hintText: "Name",
                        ),

                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 3),
                          child: Container(
                            padding: EdgeInsets.all(7.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              border: Border.all(color: secondaryColor),
                            ),
                            child: DropdownButton<String>(
                              value: _selectedOption,
                              hint: Text(
                                'Select a Class',
                                style: TextStyle(
                                    color: secondaryColor, fontSize: 18),
                              ), // Initial hint
                              icon: Icon(Icons.arrow_drop_down),
                              iconSize: 36.0,
                              elevation: 8,
                              style: TextStyle(color: secondaryColor),
                              underline: SizedBox(),
                              isExpanded: true,
                              onChanged: (String? newValue) {
                                setState(() {
                                  _selectedOption = newValue;
                                });
                                print('Selected: $_selectedOption');
                              },
                              items: options.map<DropdownMenuItem<String>>(
                                  (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                        // Display selected value at bottom when an option is selected

                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: TextFormField(
                            validator: registercontroller.passwordValidator,
                            controller: registercontroller.passwordcontroller,
                            obscureText:
                                !_isPasswordVisible, // Toggle the visibility
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.lock_outline),
                              labelText: 'Password',
                              labelStyle: TextStyle(color: secondaryColor),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: secondaryColor, width: 1),
                                  borderRadius: BorderRadius.circular(10)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: secondaryColor, width: 1),
                                  borderRadius: BorderRadius.circular(10)),
                              fillColor: Color.fromARGB(255, 255, 255, 255),
                              filled: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isPasswordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off_outlined,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isPasswordVisible = !_isPasswordVisible;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: TextFormField(
                            validator:
                                registercontroller.confirmPasswordValidator,
                            controller:
                                registercontroller.confirmPasswordController,
                            obscureText:
                                !_isconrnformPasswordVisible, // Toggle the visibility
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.lock_outline),
                              labelText: 'Confirm Password',
                              labelStyle: TextStyle(color: secondaryColor),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: secondaryColor, width: 1),
                                  borderRadius: BorderRadius.circular(10)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: secondaryColor, width: 1),
                                  borderRadius: BorderRadius.circular(10)),
                              fillColor: Color.fromARGB(255, 255, 255, 255),
                              filled: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isconrnformPasswordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off_outlined,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isconrnformPasswordVisible =
                                        !_isconrnformPasswordVisible;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            registercontroller.termsAndConditions.value =
                                !registercontroller.termsAndConditions.value;
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Obx(
                                () => Checkbox(
                                  value: registercontroller
                                      .termsAndConditions.value,
                                  onChanged: (value) {
                                    registercontroller
                                        .termsAndConditions.value = value!;
                                  },
                                  activeColor: primaryColor,
                                  checkColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(2.5),
                                  ),
                                  splashRadius: 1.5.h,
                                  side: const BorderSide(
                                    color: primaryColor,
                                    style: BorderStyle.solid,
                                  ),
                                ),
                              ),
                              Flexible(
                                child: RichText(
                                  softWrap: true,
                                  maxLines: 2,
                                  text: TextSpan(
                                    text: "I have read and accept the ",
                                    style: TextStyle(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black,
                                        fontFamily: FontStyles.poppins),
                                    children: [
                                      TextSpan(
                                        text: "Terms and Privacy Policy",
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {},
                                        style: TextStyle(
                                          fontSize: 15.5.sp,
                                          fontWeight: FontWeight.w500,
                                          color: primaryColor,
                                          fontFamily: FontStyles.poppins,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        CustomizedButton(
                          buttonText: "Register",
                          buttonColor: Colors.black,
                          textColor: Colors.white,
                          onPressed: () async {
                            FocusScope.of(context).unfocus();
                            registercontroller
                                .registerSubmit(_selectedOption.toString());
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  )))
                ]),
              )))),
    );
  }
}
