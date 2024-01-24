import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:merocanteen/app/models/users_model.dart';
import 'package:merocanteen/app/modules/common/login/login_controller.dart';
import 'package:merocanteen/app/modules/common/login/login_page.dart';
import 'package:merocanteen/app/modules/common/register/user_entry_controller.dart';
import 'package:merocanteen/app/modules/user_module/home/user_mainScreen.dart';
import 'package:merocanteen/app/widget/custom_snackbar.dart';
import 'package:merocanteen/app/widget/splash_screen.dart';

class RegisterController extends GetxController {
  final userNameController = Get.put(UserNameController());
  final storage = GetStorage();
  // TextEditingController for the email field
  final emailcontroller = TextEditingController();
  final namecontroller = TextEditingController();
  final phonenocontroller = TextEditingController();
  final passwordcontroller = TextEditingController();
  final storeNamecontroller = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final termsAndConditions = false.obs;
  final isregisterloading = false.obs;
  final registerFromkey = GlobalKey<FormState>();
  FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
  }

  void registerSubmit(String classes) {
    if (registerFromkey.currentState!.validate()) {
      termsAndConditions.value == true
          ? registerUser(classes)
          : Get.snackbar(
              snackPosition: SnackPosition.TOP,
              "Accept Terms & Condition",
              'Accept it');
    }
  }

  Future<void> registerUser(String classes) async {
    try {
      log("-----this is abouve $classes");

      isregisterloading(true);
      log("-----this is abouve $classes");

      log("-----this is abouve error");
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: emailcontroller.text,
        password: passwordcontroller.text,
      );

      await FirebaseFirestore.instance
          .collection('students')
          .doc(userCredential.user!.uid)
          .set({
        'userid': userCredential.user!.uid, // Saving userid
        'name': namecontroller.text,
        'phone': phonenocontroller.text,
        'email': emailcontroller.text,
        'groupid': '',
        'classes': classes,
      });
      log("-----this is after error");
      occupyUsername();

      isregisterloading(false);
      log("-----this is isoccupied error");

      clearTextControllers();
      Get.offAll(() => LoginScreen());

      // Save additional user data to Firestore
    } catch (e) {
      isregisterloading(false);
      // Handle registration errors
      CustomSnackbar(
        backgroundColor: Colors.black,
        title: 'Error',
        message: '$e',
        duration: Duration(milliseconds: 3000),
        textColor: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> occupyUsername() async {
    try {
      QuerySnapshot usernameSnapshot = await _firestore
          .collection('studentusername')
          .where('username',
              isEqualTo: userNameController.namecontroller.text.trim())
          .get();

      if (usernameSnapshot.docs.isNotEmpty) {
        var doc = usernameSnapshot.docs.first;
        bool isOccupied = doc['isOccupied'];

        if (!isOccupied) {
          await _firestore
              .collection('studentusername')
              .doc(doc.id)
              .update({'isOccupied': true});
          Get.snackbar('Occupy', 'Pin has been occupied',
              snackPosition: SnackPosition.BOTTOM);
        } else {
          Get.snackbar('  Status', 'Pin is already occupied',
              snackPosition: SnackPosition.BOTTOM);
        }
      } else {
        Get.snackbar('  Status', 'Pin does not exist',
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      print('Error occupying username: $e');
      Get.snackbar('Error', 'An error occurred while occupying username',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  String? usernameValidator(String? value) {
    // if(fieldLostFocus == usernameController.hashCode)
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }
    if (value.trim().length < 4) {
      return 'Username must be at least 4 characters in length';
    }
    // Return null if the entered username is valid
    return null;
  }

  String? emailValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your email address';
    }
    // Check if the entered email has the right format
    if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    // Return null if the entered email is valid
    return null;
  }

  String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    }
    // Check for additional criteria (e.g., at least one digit and one special character)

    return null; // Return null if the password meets the criteria
  }

  String? confirmPasswordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    if (value != passwordcontroller.value.text) {
      return 'Confimation password does not match the entered password';
    }

    return null;
  }

  String? phoneValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a phone no';
    }
    if (value.length != 10) {
      return 'Phone no must be  10 digits';
    }
    // Check for additional criteria (e.g., at least one digit and one special character)

    return null; // Return null if the password meets the criteria
  }

  void clearTextControllers() {
    emailcontroller.clear();
    namecontroller.clear();
    phonenocontroller.clear();
    passwordcontroller.clear();
    userNameController.namecontroller.clear();
  }
}
