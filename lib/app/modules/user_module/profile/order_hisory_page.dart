import 'package:cached_network_image/cached_network_image.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:merocanteen/app/models/cart_models.dart';
import 'package:merocanteen/app/modules/common/login/login_controller.dart';
import 'package:merocanteen/app/modules/user_module/cart/cart_controller.dart';
import 'package:merocanteen/app/widget/empty_cart_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:merocanteen/app/widget/loading_screen.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class OrderHistoryPage extends StatelessWidget {
  final cartcontroller = Get.put(CartController());
  final storage = GetStorage();
  final logincontroller = Get.put(LoginController());

  Future<void> _refreshData() async {
    cartcontroller.fetchHistory(); // Fetch data based on the selected category
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text('Order History'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Personal Order'),
              Tab(text: 'Group Order'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Personal Order Tab
            buildPersonalOrderTab(context),

            // Group Order Tab
            buildGroupOrderTab(context),
          ],
        ),
      ),
    );
  }

  Widget buildPersonalOrderTab(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => _refreshData(),
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        child: Obx(() {
          if (cartcontroller.isloading.value) {
            return LoadingScreen();
          } else {
            if (cartcontroller.ordersHistory.isEmpty ||
                cartcontroller.ordersHistory.every((order) =>
                    order.cid != logincontroller.user.value!.userid)) {
              cartcontroller.fetchHistory();
              return EmptyCartPage();
            } else {
              // Sort orders by date in descending order
              List<Items> personalOrders = cartcontroller.ordersHistory
                  .where((order) =>
                      order.cid == logincontroller.user.value!.userid)
                  .toList();

              personalOrders.sort((a, b) => b.date.compareTo(a.date));

              return ListView.builder(
                shrinkWrap: true,
                physics: ScrollPhysics(),
                itemCount: personalOrders.length,
                itemBuilder: (context, index) {
                  return persionalItems(personalOrders[index]);
                },
              );
            }
          }
        }),
      ),
    );
  }

  Widget buildGroupOrderTab(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: double.infinity,
      child: RefreshIndicator(
        onRefresh: () => _refreshData(),
        child: Obx(() {
          if (cartcontroller.isloading.value) {
            cartcontroller.fetchHistory();
            return LoadingScreen();
          } else {
            if (cartcontroller.ordersHistory.isEmpty) {
              return EmptyCartPage();
            } else {
              // Group items by year, month, and date
              Map<String, Map<String, List<Items>>> itemsByYearMonthDate = {};

              for (Items item in cartcontroller.ordersHistory) {
                // Parse the string date to a DateTime object
                DateTime dateTime = DateTime.parse(item.date);

                String yearMonthKey =
                    DateFormat('yyyy-MM').format(dateTime); // Year-month key
                String dateKey = DateFormat('yyyy-MM-dd')
                    .format(dateTime); // Year-month-date key

                // Initialize the month map if not present
                itemsByYearMonthDate.putIfAbsent(yearMonthKey, () => {});

                // Initialize the date list if not present for the specific year-month
                itemsByYearMonthDate[yearMonthKey]!
                    .putIfAbsent(dateKey, () => []);

                // Add the item to the corresponding date list within the year-month
                itemsByYearMonthDate[yearMonthKey]![dateKey]!.add(item);
              }

              // Build UI based on grouped items
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (var yearMonthEntry in itemsByYearMonthDate.entries)
                      for (var dateEntry in yearMonthEntry.value.entries)
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Display date as a sub-header
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    dateEntry.key,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                // Display items for the date
                                ...dateEntry.value.map((item) {
                                  return buildItemWidget(item);
                                }).toList(),
                              ],
                            ),
                          ],
                        ),
                  ],
                ),
              );
            }
          }
        }),
      ),
    );
  }

  Widget buildItemWidget(Items item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 19.h,
          padding: EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(20)),
                height: 19.h,
                width: 36.w,
                child: CachedNetworkImage(
                  imageUrl: item.productImage ?? '',
                  fit: BoxFit.cover,
                  errorWidget: (context, url, error) =>
                      Icon(Icons.error_outline, size: 40),
                ),
              ),
              SizedBox(width: 16.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 8.0),
                        Text(
                          item.productName,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                          ),
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          'Rs.${item.price.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          '${item.customer}',
                          style: TextStyle(
                            fontSize: 14.0,
                            color: const Color.fromARGB(255, 134, 94, 94),
                          ),
                        ),
                        Text(
                          '${item.date}',
                          style: TextStyle(
                            fontSize: 14.0,
                            color: const Color.fromARGB(255, 134, 94, 94),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.0),
                                color: Colors.grey[200],
                              ),
                              child: Text(
                                "Quantity:",
                                style: TextStyle(fontSize: 20),
                              )),
                          SizedBox(width: 8.0),
                          Text(
                            "${item.quantity}-plate",
                            style: TextStyle(fontSize: 16.0),
                          ),
                          SizedBox(width: 8.0),
                        ],
                      ),
                      SizedBox(width: 12.w),
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
        Divider(
          height: 0.5,
          color: const Color.fromARGB(255, 192, 189, 189),
        ),
      ],
    );
  }

  Widget persionalItems(Items item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 19.h,
          padding: EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(20)),
                height: 19.h,
                width: 36.w,
                child: CachedNetworkImage(
                  imageUrl: item.productImage ?? '',
                  fit: BoxFit.cover,
                  errorWidget: (context, url, error) =>
                      Icon(Icons.error_outline, size: 40),
                ),
              ),
              SizedBox(width: 16.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 8.0),
                        Text(
                          item.productName,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                          ),
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          'Rs.${item.price.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          '${item.customer}',
                          style: TextStyle(
                            fontSize: 14.0,
                            color: const Color.fromARGB(255, 134, 94, 94),
                          ),
                        ),
                        Text(
                          '${item.date}',
                          style: TextStyle(
                            fontSize: 14.0,
                            color: const Color.fromARGB(255, 134, 94, 94),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.0),
                                color: Colors.grey[200],
                              ),
                              child: Text(
                                "Quantity:",
                                style: TextStyle(fontSize: 20),
                              )),
                          SizedBox(width: 8.0),
                          Text(
                            "${item.quantity}-plate",
                            style: TextStyle(fontSize: 16.0),
                          ),
                          SizedBox(width: 8.0),
                        ],
                      ),
                      SizedBox(width: 12.w),
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
        Divider(
          height: 0.5,
          color: const Color.fromARGB(255, 192, 189, 189),
        ),
      ],
    );
  }
}