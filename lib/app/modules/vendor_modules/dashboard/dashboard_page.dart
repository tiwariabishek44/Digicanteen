import 'package:get/get.dart';
import 'package:merocanteen/app/config/colors.dart';

import 'package:flutter/material.dart';
import 'package:merocanteen/app/modules/common/login/login_controller.dart';
import 'package:merocanteen/app/modules/vendor_modules/allproducts/homeSCreen.dart';
import 'package:merocanteen/app/modules/vendor_modules/analytics/analytics_page.dart';
import 'package:merocanteen/app/modules/vendor_modules/dashboard/class_wise_analysis.dart';
import 'package:merocanteen/app/modules/vendor_modules/dashboard/order_cancel.dart';
import 'package:merocanteen/app/modules/vendor_modules/order_requirements/demand_supply.dart';
import 'package:merocanteen/app/modules/vendor_modules/order_requirements/order_requirement.dart';
import 'package:intl/intl.dart';
import 'package:merocanteen/app/modules/vendor_modules/order_requirements/salse_controller.dart';
import 'package:merocanteen/app/widget/logout_conformation_dialog.dart';
import 'package:nepali_utils/nepali_utils.dart';

class DshBoard extends StatelessWidget {
  final loginContorller = Get.put(LoginController());
  final salseContorlller = Get.put(SalsesController());

  @override
  Widget build(BuildContext context) {
    salseContorlller.fetchOrderss();
    salseContorlller.fetchSalesORders();
    DateTime currentDate = DateTime.now();

    NepaliDateTime nepaliDateTime = NepaliDateTime.fromDateTime(currentDate);

    String formattedDate =
        DateFormat('dd/MM/yyyy\'', 'en').format(nepaliDateTime);

    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            radius: 30, // Adjust the radius as needed for the circular view
            backgroundImage: AssetImage(
              'assets/logo.png', // Replace 'your_logo.png' with your logo file path
            ),
          ),
        ),
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Dashboard",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                formattedDate, // Display Nepali date in the app bar
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return LogoutConfirmationDialog(
                      isbutton: true,
                      heading: 'Alert',
                      subheading: "Do you want to logout of the application?",
                      firstbutton: "Yes",
                      secondbutton: 'No',
                      onConfirm: () {
                        loginContorller.vendorLogOut();
                      },
                    );
                  },
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                padding: EdgeInsets.all(12.0),
                child: const Text(
                  "    Logout    ",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
      // Add the rest of your app content here

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Obx(() => Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.blue,
                          Color.fromARGB(255, 219, 183, 183)
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    height: MediaQuery.of(context).size.height * 0.2,
                    width: MediaQuery.of(context).size.width * 1,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Daily Sales',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20, // Adjust the font size as needed
                            ),
                          ),
                          SizedBox(height: 8), // Add spacing between the texts
                          Text(
                            "Rs. " +
                                salseContorlller.grandTotal.value
                                    .toInt()
                                    .toString(),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 54, // Adjust the font size as needed
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridView.count(
                  crossAxisCount: 3,
                  shrinkWrap: true,
                  childAspectRatio: 1.3,
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    buildClickableIcon(
                      icon: Icons.restaurant_menu,
                      label: 'Canteen Meal',
                      onTap: () {
                        // Handle click for Menu Management
                        Get.to(() => VHomePage());
                      },
                    ),
                    buildClickableIcon(
                      icon: Icons.production_quantity_limits,
                      label: 'Orders Req.',
                      onTap: () {
                        // Handle click for Order Management
                        Get.to(() => OrderRequirement());
                      },
                    ),
                    buildClickableIcon(
                      icon: Icons.analytics,
                      label: 'Analytics',
                      onTap: () {
                        // Handle click for Analytics\
                        Get.to(() => AnalyticsPage());
                      },
                    ),
                    buildClickableIcon(
                      icon: Icons.class_,
                      label: 'Class Analysis',
                      onTap: () {
                        // Handle click for Analytics\
                        Get.to(() => Classanalytics());
                      },
                    ),
                    buildClickableIcon(
                      icon: Icons.cancel_presentation,
                      label: 'Order Cancel',
                      onTap: () {
                        // Handle click for Analytics\
                        Get.to(() => OrderCancel());
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: const Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Sales Report",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    )),
              ),
              DemandSupply(),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to build each clickable icon item
  Widget buildClickableIcon({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.secondaryColor),
            color: Colors.white,
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 30,
                color: Color.fromARGB(255, 24, 20, 19),
              ),
              SizedBox(height: 8.0),
              Center(
                child: Text(
                  label,
                  style: TextStyle(
                    color: const Color.fromARGB(255, 59, 57, 57),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
