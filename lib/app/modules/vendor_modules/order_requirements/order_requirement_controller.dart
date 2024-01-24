import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:intl/intl.dart';
import 'package:merocanteen/app/models/cart_models.dart';
import 'package:nepali_utils/nepali_utils.dart';

class OrderRequestContoller extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var date = ''.obs;
  var isloading = false.obs;
  var ismorning = true.obs;
  RxMap<String, List<Items>> orders = <String, List<Items>>{}.obs;
  RxMap<String, int> totalQuantityPerProduct = <String, int>{}.obs;

  List<String> timeSlots = [
    'All',
    '8:30',
    '9:30',
    '11:30',
    '12:30',
    '1:30',
  ];

  void fetchMeal(int index, String date) {
    fetchOrders(timeSlots[index], date);
  }

  Future<void> fetchOrders(String mealtime, String dates) async {
    try {
      isloading(true);

      QuerySnapshot ordersSnapshot;

      if (mealtime == 'All') {
        ordersSnapshot = await _firestore
            .collection('orders')
            .where('date', isEqualTo: dates)
            .get();
      } else {
        ordersSnapshot = await _firestore
            .collection('orders')
            .where("mealtime", isEqualTo: mealtime)
            .where('date', isEqualTo: dates)
            .get();
      }

      orders.clear();

      ordersSnapshot.docs.forEach((DocumentSnapshot document) {
        Items item = Items.fromMap(document.data() as Map<String, dynamic>);

        if (!orders.containsKey(item.productName)) {
          orders[item.productName] = [item];
        } else {
          orders[item.productName]?.add(item);
        }
      });

      calculateTotalQuantity();
      isloading(false);
    } catch (e) {
      isloading(false);
      print("Error fetching orders: $e");
    }
  }

  void calculateTotalQuantity() {
    orders.forEach((productName, itemList) {
      int totalQuantity = itemList.fold<int>(
        0,
        (previousValue, element) => previousValue + element.quantity,
      );
      totalQuantityPerProduct[productName] = totalQuantity;
    });
  }
}
