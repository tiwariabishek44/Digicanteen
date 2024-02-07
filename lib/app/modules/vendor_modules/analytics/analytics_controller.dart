import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/physics.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:intl/intl.dart';
import 'package:merocanteen/app/models/order_response.dart';
import 'package:nepali_utils/nepali_utils.dart';

class AnalyticsController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  RxMap<String, List<OrderResponse>> orders =
      <String, List<OrderResponse>>{}.obs;
  RxMap<String, List<OrderResponse>> chekcoutOrders =
      <String, List<OrderResponse>>{}.obs;
  RxMap<String, int> totalQuantityPerProductOrders = <String, int>{}.obs;
  RxMap<String, int> totalQuantityPerProductCheckoutOrders =
      <String, int>{}.obs;

  var isloading = false.obs;
  var ismorning = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    try {
      orders.clear();
      chekcoutOrders.clear();
      totalQuantityPerProductOrders.clear();
      totalQuantityPerProductCheckoutOrders.clear();
      isloading(true);
      DateTime currentDate = DateTime.now();

      // Convert the Gregorian date to Nepali date
      NepaliDateTime nepaliDateTime = NepaliDateTime.fromDateTime(currentDate);

      // Format the Nepali date as "dd/MM/yyyy("
      String formattedDate =
          DateFormat('dd/MM/yyyy\'', 'en').format(nepaliDateTime);
      // Fetch checkout orders
      QuerySnapshot ordersSnapshot = await _firestore
          .collection('orders')
          .where('date', isEqualTo: "$formattedDate")
          .get();

      ordersSnapshot.docs.forEach((DocumentSnapshot document) {
        OrderResponse item =
            OrderResponse.fromJson(document.data() as Map<String, dynamic>);

        if (!orders.containsKey(item.classs)) {
          orders[item.classs] = [item];
        } else {
          orders[item.classs]?.add(item);
        }
      });

      // Fetch checkout orders
      QuerySnapshot unCheckoutOrdersSnapshot = await _firestore
          .collection('orders')
          .where('date', isEqualTo: "$formattedDate")
          .where('checkout', isEqualTo: 'true')
          .get();

      unCheckoutOrdersSnapshot.docs.forEach((DocumentSnapshot document) {
        OrderResponse item =
            OrderResponse.fromJson(document.data() as Map<String, dynamic>);

        if (!chekcoutOrders.containsKey(item.classs)) {
          chekcoutOrders[item.classs] = [item];
        } else {
          chekcoutOrders[item.classs]?.add(item);
        }
      });

      calculateTotalQuantityOrders();
      calculateTotalQuantityUnCheckoutOrders();
      isloading(false);
    } catch (e) {
      isloading(false);

      // Handle errors
      print("Error fetching orders: $e");
    }
  }

  void calculateTotalQuantityOrders() {
    orders.forEach((productName, itemList) {
      int totalQuantity = itemList.fold<int>(
        0,
        (previousValue, element) => previousValue + element.quantity,
      );
      totalQuantityPerProductOrders[productName] = totalQuantity;
    });
  }

  void calculateTotalQuantityUnCheckoutOrders() {
    chekcoutOrders.forEach((productName, itemList) {
      int totalQuantity = itemList.fold<int>(
        0,
        (previousValue, element) => previousValue + element.quantity,
      );
      totalQuantityPerProductCheckoutOrders[productName] = totalQuantity;
    });
  }
}
