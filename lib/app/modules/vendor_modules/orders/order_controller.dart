import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:merocanteen/app/config/colors.dart';
import 'package:merocanteen/app/models/cart_models.dart';
import 'package:merocanteen/app/models/users_model.dart';
import 'package:merocanteen/app/modules/common/login/login_controller.dart';
import 'package:merocanteen/app/modules/vendor_modules/analytics/analytics_controller.dart';
import 'package:merocanteen/app/modules/vendor_modules/order_requirements/demand_supply.dart';
import 'package:merocanteen/app/modules/vendor_modules/order_requirements/order_requirement_controller.dart';
import 'package:merocanteen/app/widget/custom_snackbar.dart';

class OrderController extends GetxController {
  var isloading = false.obs;
  final logincontroller = Get.put(LoginController());
  final groupcod = TextEditingController();
  final RxList<Items> orders = <Items>[].obs;
  final RxList<Items> vendorOrder = <Items>[].obs;

  var totalamoutn = 0.obs;
  var quantity = 1.obs;
  FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  @override
  void onReady() {
    super.onReady();
    orders.clear(); // Clear the orders list when the screen is initialized
  }

  @override
  void onInit() {
    super.onInit();
    log("this is delete");
  }

  @override
  void dispose() {
    groupcod.dispose(); // Dispose the TextEditingController
    super.dispose();
  }

  Future<void> fetchOrdersByGroupID(String? groupcod) async {
    try {
      isloading(true);

      final QuerySnapshot querySnapshot = await _firestore
          .collection('orders')
          .where('groupcod', isEqualTo: groupcod!)
          .where('checkout', isEqualTo: 'false')
          .get();

      orders.clear(); // Clear the previous orders before adding new ones

      for (final doc in querySnapshot.docs) {
        final item = Items.fromMap(doc.data() as Map<String, dynamic>);
        orders.add(item);
      }
      isloading(false);
    } catch (e) {
      isloading(false);

      // Handle errors if any
      print('Error fetching orders: $e');
    }
  }

  Future<void> deleteIndividualFromOrder(String id, String groupcod) async {
    try {
      isloading(true);

      final CollectionReference orders = _firestore.collection('orders');

      QuerySnapshot querySnapshot =
          await orders.where('id', isEqualTo: id).get();

      // Delete each document in the query result
      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        await doc.reference.delete();
      }

      // Fetch updated cart items after deletion

      // Assuming fetchOrdersByGroupID uses 'groupid' internally, you might need to retrieve it
      // from the deleted document or have it available elsewhere.
      // For now, let's assume groupid is available globally or as an argument to this method.
      await fetchOrdersByGroupID(groupcod);

      isloading(false);
    } catch (e) {
      isloading(false);

      // Handle errors if any
      print('Error deleting item from orders: $e');
      Get.snackbar(
        'Error',
        'Failed to delete item from orders. Please try again later.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> deleteGroupOrder(String groupcod) async {
    try {
      isloading(true);

      final CollectionReference orders = _firestore.collection('orders');

      QuerySnapshot querySnapshot =
          await orders.where('groupcod', isEqualTo: groupcod).get();

      if (querySnapshot.docs.isNotEmpty) {
        // Loop through all matching documents and update checkout to true
        for (var doc in querySnapshot.docs) {
          await orders.doc(doc.id).update({'checkout': 'true'});
        }
      }

      // Fetch updated cart items after updating checkout
      OrderRequestContoller()
          .fetchOrders('8:30', OrderRequestContoller().date.value);

      fetchOrdersByGroupID(groupcod);

      isloading(false);
    } catch (e) {
      isloading(false);

      // Handle errors if any
      print('Error updating checkout status: $e');
      Get.snackbar(
        'Error',
        'Failed to update checkout status. Please try again later.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
