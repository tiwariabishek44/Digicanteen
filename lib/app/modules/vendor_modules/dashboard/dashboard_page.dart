import 'package:get/get.dart';
import 'package:merocanteen/app/config/colors.dart';

import 'package:flutter/material.dart';
import 'package:merocanteen/app/modules/common/login/login_controller.dart';
import 'package:merocanteen/app/modules/vendor_modules/allproducts/homeSCreen.dart';
import 'package:merocanteen/app/modules/vendor_modules/analytics/analytics_page.dart';
import 'package:merocanteen/app/modules/vendor_modules/order_requirements/demand_supply.dart';
import 'package:merocanteen/app/modules/vendor_modules/order_requirements/order_requirement.dart';
import 'package:intl/intl.dart';

class DshBoard extends StatelessWidget {
  final loginContorller = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    DateTime currentDate = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(currentDate);

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
                loginContorller.vendorLogOut();
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
              GridView.count(
                crossAxisCount: 3,
                shrinkWrap: true,
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
                    icon: Icons.shopping_cart,
                    label: 'Order Management',
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
                    icon: Icons.people,
                    label: 'Employee Management',
                    onTap: () {
                      // Handle click for Employee Management
                      print('Employee Management clicked!');
                    },
                  ),
                  buildClickableIcon(
                    icon: Icons.feedback,
                    label: 'Feedback & Ratings',
                    onTap: () {
                      // Handle click for Feedback & Ratings
                      print('Feedback & Ratings clicked!');
                    },
                  ),
                  buildClickableIcon(
                    icon: Icons.notifications,
                    label: 'Notifications',
                    onTap: () {
                      // Handle click for Notifications
                      print('Notifications clicked!');
                    },
                  ),
                  buildClickableIcon(
                    icon: Icons.money,
                    label: 'Expense Tracking',
                    onTap: () {
                      // Handle click for Expense Tracking
                      print('Expense Tracking clicked!');
                    },
                  ),
                  buildClickableIcon(
                    icon: Icons.card_giftcard,
                    label: 'Customer Engagement',
                    onTap: () {
                      // Handle click for Customer Engagement
                      print('Customer Engagement clicked!');
                    },
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: const Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Demand & Supply",
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
      child: Container(
        margin: EdgeInsets.all(8.0),
        padding: EdgeInsets.all(5.0),
        decoration: BoxDecoration(
          border: Border.all(color: secondaryColor),
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 40,
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
    );
  }
}
