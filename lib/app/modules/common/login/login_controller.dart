import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:merocanteen/app/config/prefs.dart';
import 'package:merocanteen/app/models/users_model.dart';
import 'package:merocanteen/app/modules/common/loginoption/login_option_controller.dart';
import 'package:merocanteen/app/modules/vendor_modules/vendor_main_Screen/vendr_main_Screen.dart';
import 'package:merocanteen/app/repository/get_userdata_repository.dart';
import 'package:merocanteen/app/service/api_client.dart';
import 'package:merocanteen/app/widget/custom_snackbar.dart';
import 'package:merocanteen/app/widget/splash_screen.dart';

class LoginController extends GetxController {
  final storage = GetStorage();
  // TextEditingController for the email field
  final emailcontroller = TextEditingController();
  final passwordcontroller = TextEditingController();
  final loginOptionController = Get.put(LoginScreenController());

  final vendorCode = TextEditingController();

  var isloading = false.obs;
  var isFetchLoading = false.obs;
  final loginFromkey = GlobalKey<FormState>();
  final termsAndConditions = false.obs;
  final vendorLoginFromkey = GlobalKey<FormState>();

  FirebaseAuth _auth = FirebaseAuth.instance;

  Rx<UserDataResponse?> user = Rx<UserDataResponse?>(null);

  @override
  void onInit() {
    super.onInit();
  }

  void loginSubmit(BuildContext context) {
    if (loginFromkey.currentState!.validate()) {
      login(context);
    }
  }

  //---------user login----------
  Future<void> login(BuildContext context) async {
    try {
      isloading(true);

      // Attempt to sign in
      await _auth.signInWithEmailAndPassword(
          email: emailcontroller.text, password: passwordcontroller.text);

      // If successful, save data locally
      saveDataLocally();
      isloading(false);
    } on FirebaseAuthException catch (e) {
      isloading(false);

      // Handle FirebaseAuthException (Firebase authentication errors)
      String errorMessage = 'An error occurred';
      if (e.code == 'user-not-found') {
        errorMessage = 'User not found. Please register first.';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Invalid password. Please try again.';
      } else {
        errorMessage = 'Login failed. Please try again later.';
      }
      CustomSnackbar.authShowFailure(context, errorMessage);
    } on PlatformException catch (e) {
      isloading(false);

      // Handle platform exceptions (e.g., no internet connection)
      if (e.code == 'network_error') {
        CustomSnackbar.authShowFailure(context, "No internet connection");
      } else {
        CustomSnackbar.authShowFailure(context, "An error occurred");
      }
    } catch (e) {
      isloading(false);

      // Handle other errors
      print("Login error: $e");
      CustomSnackbar.authShowFailure(context, "An unexpected error occurred");
    } finally {
      // Turn off loading indicator regardless of success or failure
      isloading(false);
    }
  }

//---------to fetch the user data------------
  final UserDataRepository userDataRepository = UserDataRepository();
  final Rx<ApiResponse<UserDataResponse>> userDataResponse =
      ApiResponse<UserDataResponse>.initial().obs;
  Future<void> fetchUserData() async {
    try {
      isFetchLoading(true);
      userDataResponse.value = ApiResponse<UserDataResponse>.loading();
      final userDataResult = await userDataRepository.getUserData(
        {
          'userid': storage.read('userId'),
          // Add more filters as needed
        },
      );
      if (userDataResult.status == ApiStatus.SUCCESS) {
        log("----------this is the success t fetch the user data");
        userDataResponse.value =
            ApiResponse<UserDataResponse>.completed(userDataResult.response);
        isFetchLoading(false);

        log(userDataResponse.value.response!.first.classes);
      }
      isFetchLoading(false);
    } catch (e) {
      isFetchLoading(false);

      log('Error while getting data: $e');
    } finally {
      isFetchLoading(false);
    }
  }

//-------- to save data locally

  void saveDataLocally() {
    storage.write(userId, _auth.currentUser!.uid);

    storage.write(userType, 'student');

    fetchUserData();

    log("this is the user login option${storage.read(userType)}");
    Get.offAll(() => SplashScreen());
  }

//-------to do auto login---------
  bool autoLogin() {
    log("AUTO LOGIN");
    if (storage.read(userType) != null) {
      // set a periodic timer to refresh token
      return true;
    }
    return false;
  }

//--to do logout------------------
  Future<void> logout() async {
    try {
      await _auth.signOut();
      user.value = null;
      storage.remove(userType);
      storage.remove(userId);
      Get.offAll(() => SplashScreen());
    } catch (e) {
      // Handle logout errors
      print("Logout error: $e");
      Get.snackbar("Logout Failed", e.toString());
    }
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
        storage.write(userType, "canteen");
        Get.offAll(() => SplashScreen());
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
      storage.remove(userType);
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
