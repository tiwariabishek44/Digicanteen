import 'dart:async';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:merocanteen/app/widget/splash_screen.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

// Disable screenshots and screen recording on Android

void main() async {
  // Initialize the Nepali locale data
  initializeDateFormatting('ne_NP');
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

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  void initState() {
    super.initState();

    // Check initial connectivity status
    initConnectivity().then(_updateConnectionStatus);

    // Subscribe to connectivity changes
    _connectivitySubscription =
        Connectivity().onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  Future<ConnectivityResult> initConnectivity() async {
    late ConnectivityResult result;
    try {
      result = await Connectivity().checkConnectivity();
    } on PlatformException catch (e) {
      print(e.toString());
      return ConnectivityResult.none;
    }
    return result;
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    setState(() {
      _connectionStatus = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(
      builder: (context, orientation, screenType) {
        // Use Builder to get context inside the builder
        return Builder(
          builder: (context) {
            return GetMaterialApp(
              title: 'Digi Canteen',
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                primarySwatch: Colors.blue,
              ),
              // Check connectivity status to determine which screen to show
              home: _connectionStatus == ConnectivityResult.none
                  ? OfflineScreen()
                  : SplashScreen(),
            );
          },
        );
      },
    );
  }
}

class OfflineScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'No Internet Connection',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
