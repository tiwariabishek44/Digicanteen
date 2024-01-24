import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:merocanteen/app/config/colors.dart';
import 'package:merocanteen/app/modules/vendor_modules/analytics/analytics_controller.dart';
import 'package:intl/intl.dart';
import 'package:merocanteen/app/modules/vendor_modules/analytics/total_orders_tab.dart';
import 'package:merocanteen/app/modules/vendor_modules/analytics/total_remaning_orders_tab.dart';
import 'package:merocanteen/app/modules/vendor_modules/order_requirements/salse_controller.dart';
import 'package:merocanteen/app/widget/empty_cart_page.dart';
import 'package:nepali_utils/nepali_utils.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class AnalyticsPage extends StatefulWidget {
  @override
  State<AnalyticsPage> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage> {
  final demandSupplyControler = Get.put(SalsesController());
  int selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    DateTime currentDate = DateTime.now();

    // ignore: deprecated_member_use
    NepaliDateTime nepaliDateTime = NepaliDateTime.fromDateTime(currentDate);

    String formattedDate = DateFormat.yMd().add_jm().format(nepaliDateTime);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Analytics",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  formattedDate,
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Total Orders'),
              Tab(text: 'Remaning Orders'),
            ],
          ),
        ),
        body: TabBarView(
          children: [TotalOrdersTab(), TotalRemaningOrdersTab()],
        ),
      ),
    );
  }
}
