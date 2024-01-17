
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';
import 'package:merocanteen/app/widget/splash_screen.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Platform.isAndroid
      ? await Firebase.initializeApp(
          options: const FirebaseOptions(
          apiKey: "AIzaSyBNYL9dshT-ux0o41Y6GBLe3XwTMvims10",
          appId: "1:1086541433915:android:aa443d32caa1cea08ea01e",
          messagingSenderId: "1086541433915",
          projectId: "merocanteen",
        ))
      : await Firebase.initializeApp();

  //  // Initialize Firebase
  await GetStorage.init(); // Initialize GetStorage

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(
      builder: (context, orientation, screenType) {
        return GetMaterialApp(
          // Use GetMaterialApp instead of MaterialApp
          title: 'Hamro Canteen',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: SplashScreen(),
        );
      },
    );
  }
}
 

// //  // import 'package:flutter/material.dart';
// // import 'dart:developer';

// // import 'package:flutter/material.dart';
// // import 'package:get/get.dart';
// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:merocanteen/app/widget/customized_button.dart';

// // class UserNameController extends GetxController {
// //   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
// //   var isloading = false.obs;

// //   Future<void> checkUsername(String inputUsername) async {
// //     try {
// //       QuerySnapshot usernameSnapshot = await _firestore
// //           .collection('studentusername')
// //           .where('username', isEqualTo: inputUsername)
// //           .get();

// //       if (usernameSnapshot.docs.isNotEmpty) {
// //         var doc = usernameSnapshot.docs.first;
// //         bool isOccupied = doc['isOccupied'];

// //         if (isOccupied) {
// //           // Username is occupied
// //           log('Username Status    Username is already occupied');
// //         } else {
// //           log("user name is not occupied");
// //           // Username is available
// //         }
// //       } else {
// //         // Username does not exist
// //         log("User doesnot exit");
// //       }
// //     } catch (e) {
// //       log(" Try exit error");
// //     }
// //   }

// //   Future<void> uploadUsernames(List<String> usernames) async {
// //     try {
// //       isloading(true);
// //       for (String username in usernames) {
// //         await _firestore.collection('studentusername').add({
// //           'username': username,
// //           'isOccupied':
// //               false, // You can set initial occupation status as true or false
// //         });
// //       }
// //       isloading(true);

// //       print('Usernames uploaded successfully');
// //     } catch (e) {
// //       print('Error uploading usernames: $e');
// //     }
// //   }
// // }
 