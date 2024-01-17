import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:intl/intl.dart';
import 'package:merocanteen/app/models/cart_models.dart';

class AnalyticsController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  RxMap<String, List<Items>> orders = <String, List<Items>>{}.obs;
  RxMap<String, List<Items>> unCheckoutOrders = <String, List<Items>>{}.obs;
  RxMap<String, int> totalQuantityPerProductOrders = <String, int>{}.obs;
  RxMap<String, int> totalQuantityPerProductUnCheckoutOrders =
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
      isloading(true);
      DateTime currentDate = DateTime.now();
      String formattedDate = DateFormat('yyyy-MM-dd').format(currentDate);

      // Fetch checkout orders
      QuerySnapshot ordersSnapshot = await _firestore
          .collection('orders')
          .where('date', isEqualTo: "$formattedDate")
          .get();

      ordersSnapshot.docs.forEach((DocumentSnapshot document) {
        Items item = Items.fromMap(document.data() as Map<String, dynamic>);

        if (!orders.containsKey(item.classs)) {
          orders[item.classs] = [item];
        } else {
          orders[item.classs]?.add(item);
        }
      });

      // Fetch uncheckout orders
      QuerySnapshot unCheckoutOrdersSnapshot = await _firestore
          .collection('orders')
          .where('date', isEqualTo: "$formattedDate")
          .where('checkout', isEqualTo: 'false')
          .get();

      unCheckoutOrdersSnapshot.docs.forEach((DocumentSnapshot document) {
        Items item = Items.fromMap(document.data() as Map<String, dynamic>);

        if (!unCheckoutOrders.containsKey(item.classs)) {
          unCheckoutOrders[item.classs] = [item];
        } else {
          unCheckoutOrders[item.classs]?.add(item);
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
    unCheckoutOrders.forEach((productName, itemList) {
      int totalQuantity = itemList.fold<int>(
        0,
        (previousValue, element) => previousValue + element.quantity,
      );
      totalQuantityPerProductUnCheckoutOrders[productName] = totalQuantity;
    });
  }
}

class DemandSupplyController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  RxMap<String, List<Items>> orders = <String, List<Items>>{}.obs;
  RxMap<String, List<Items>> unCheckoutOrders = <String, List<Items>>{}.obs;
  RxMap<String, int> totalQuantityPerProductOrders = <String, int>{}.obs;
  RxMap<String, int> totalQuantityPerProductUnCheckoutOrders =
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
      isloading(true);
      DateTime currentDate = DateTime.now();
      String formattedDate = DateFormat('yyyy-MM-dd').format(currentDate);

      // Fetch checkout orders
      QuerySnapshot ordersSnapshot = await _firestore
          .collection('orders')
          .where('date', isEqualTo: "$formattedDate")
          .get();

      ordersSnapshot.docs.forEach((DocumentSnapshot document) {
        Items item = Items.fromMap(document.data() as Map<String, dynamic>);

        if (!orders.containsKey(item.productName)) {
          orders[item.productName] = [item];
        } else {
          orders[item.classs]?.add(item);
        }
      });

      // Fetch uncheckout orders
      QuerySnapshot unCheckoutOrdersSnapshot = await _firestore
          .collection('orders')
          .where('date', isEqualTo: "$formattedDate")
          .where('checkout', isEqualTo: 'false')
          .get();

      unCheckoutOrdersSnapshot.docs.forEach((DocumentSnapshot document) {
        Items item = Items.fromMap(document.data() as Map<String, dynamic>);

        if (!unCheckoutOrders.containsKey(item.classs)) {
          unCheckoutOrders[item.productName] = [item];
        } else {
          unCheckoutOrders[item.productName]?.add(item);
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
    unCheckoutOrders.forEach((productName, itemList) {
      int totalQuantity = itemList.fold<int>(
        0,
        (previousValue, element) => previousValue + element.quantity,
      );
      totalQuantityPerProductUnCheckoutOrders[productName] = totalQuantity;
    });
  }
}
