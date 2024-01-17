import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:merocanteen/app/models/users_model.dart';
import 'package:merocanteen/app/modules/common/register/register.dart';
import 'package:merocanteen/app/modules/user_module/home/user_mainScreen.dart';
import 'package:merocanteen/app/modules/vendor_modules/vendor_main_Screen/vendr_main_Screen.dart';
import 'package:merocanteen/app/widget/custom_snackbar.dart';
import 'package:merocanteen/app/widget/splash_screen.dart';

class LoginController extends GetxController {
  final storage = GetStorage();
  // TextEditingController for the email field
  final emailcontroller = TextEditingController();
  final passwordcontroller = TextEditingController();
  final vendorCode = TextEditingController();

  var isloading = false.obs;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final loginFromkey = GlobalKey<FormState>();
  final termsAndConditions = false.obs;
  final vendorLoginFromkey = GlobalKey<FormState>();

  FirebaseAuth _auth = FirebaseAuth.instance;

  Rx<UserModel?> user = Rx<UserModel?>(null);

  @override
  void onInit() {
    super.onInit();
    checkInitialAuth();
    fetchUserData();
  }

  void loginSubmit() {
    if (loginFromkey.currentState!.validate()) {
      login();
    }
  }

//-----------------upload the username in the server----------//
  Future<void> uploadUsernames(List<String> usernames) async {
    try {
      isloading(true);
      for (String username in usernames) {
        await _firestore.collection('studentusername').add({
          'username': username,
          'isOccupied':
              false, // You can set initial occupation status as true or false
        });
      }
      isloading(true);

      print('Usernames uploaded successfully');
    } catch (e) {
      print('Error uploading usernames: $e');
    }
  }

  Future<void> fetchUserData() async {
    try {
      user(null);

      DocumentSnapshot userSnapshot = await _firestore
          .collection('students')
          .doc(_auth.currentUser!.uid)
          .get();

      if (userSnapshot.exists) {
        // User data found in Firestore, update the user value in the controller
        var userData = userSnapshot.data() as Map<String, dynamic>;
        user.value = UserModel(
          userid: userData['userid'] ?? "",
          name: userData['name'] ?? "", // Fetch the user's name from Firestore
          email: userData['email'] ?? "",
          phone: userData['phone'] ?? "",
          groupid: userData['groupid'] ?? "",
          classes: userData['classes'] ?? "",
        );
        storage.write('groupid', userData['groupid']);
      } else {
        // User data not found
        print("User data not found in Firestore");
      }
    } catch (e) {
      // Handle data retrieval errors
      print("Error fetching user data: $e");
    }
  }

  void checkInitialAuth() {
    if (_auth.currentUser != null) {
      String uid = _auth.currentUser!.uid;
      fetchUserData();
    }
  }

  Future<void> login() async {
    try {
      isloading(true);
      await _auth.signInWithEmailAndPassword(
          email: emailcontroller.text, password: passwordcontroller.text);
      isloading(false);
      fetchUserData();
      Get.offAll(() => UserMainScreenView());

      clearTextControllers();
    } catch (e) {
      isloading(false);
      // Handle login errors
      print("Login error: $e");
      Get.snackbar("Login Failed", e.toString());
    }
  }

  Future<void> logout() async {
    try {
      await _auth.signOut();
      clearTextControllers();
      user.value = null;
      storage.remove('groupid');

      Get.offAll(() => SplashScreen());
    } catch (e) {
      // Handle logout errors
      print("Logout error: $e");
      Get.snackbar("Logout Failed", e.toString());
    }
  }

  void clearTextControllers() {
    emailcontroller.clear();
    passwordcontroller.clear();
  }

//------------vendor/canteen login---------------//

  void vendorloginSubmit() {
    if (vendorLoginFromkey.currentState!.validate()) {
      vendorLogin();
    }
  }

  Future<void> vendorLogin() async {
    try {
      isloading(true);

      if (vendorCode.text.trim() == '4455') {
        storage.write('vendor', vendorCode.text.trim());
        Get.offAll(() => VendorMainScreenView());
        isloading(false);
        vendorCode.clear();
      } else {
        Get.snackbar("Error", 'Enter the valid number');

        isloading(false);
      }
    } catch (e) {
      isloading(false);
      // Handle login errors
      print("Login error: $e");
      Get.snackbar("Login Failed", e.toString());
    }
  }

//------------vendor logout---------------//

  Future<void> vendorLogOut() async {
    try {
      storage.remove('vendor');
      vendorCode.clear();

      Get.offAll(() => SplashScreen());
    } catch (e) {
      isloading(false);
      // Handle login errors
      print("Login error: $e");
      Get.snackbar("Login Failed", e.toString());
    }
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

  String? vendorVlidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your Canteen Code';
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
}
