import 'package:carousel_slider/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:intl/intl.dart';
import 'package:merocanteen/app/models/order_response.dart';
import 'package:nepali_utils/nepali_utils.dart';

class SalsesController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchSalesORders();
    fetchOrderss();
  }

  RxList<OrderResponse> orderss =
      <OrderResponse>[].obs; // RxList to make it reactive
  RxDouble grandTotal = 0.0.obs; // RxDouble for the grand total

  Future<void> fetchOrderss() async {
    try {
      DateTime currentDate = DateTime.now();

      // Convert the Gregorian date to Nepali date
      NepaliDateTime nepaliDateTime = NepaliDateTime.fromDateTime(currentDate);

      // Format the Nepali date as "dd/MM/yyyy("
      String formattedDate =
          DateFormat('dd/MM/yyyy\'', 'en').format(nepaliDateTime);
      // Replace 'your_firestore_collection_reference' with your actual collection reference
      var querySnapshot = await FirebaseFirestore.instance
          .collection('orders')
          .where('date', isEqualTo: "$formattedDate")
          .where('checkout', isEqualTo: 'true')
          .get();

      // Clear the previous orders
      orderss.clear();

      // Add each order to the orders list
      for (var doc in querySnapshot.docs) {
        var order = OrderResponse.fromJson(doc.data() as Map<String, dynamic>);
        orderss.add(order);
      }

      // Calculate the grand total
      calculateGrandTotal();
    } catch (e) {
      print('Error fetching orders: $e');
    }
  }

  void calculateGrandTotal() {
    grandTotal.value = 0.0;
    grandTotal.value = orderss.fold<double>(
        0.0, (previousValue, order) => previousValue + order.price);
  }

//--------------fetching the remaning orders---------------------//
  RxMap<String, List<OrderResponse>> salesOrder =
      <String, List<OrderResponse>>{}.obs;
  RxMap<String, int> totalSalesPerOrders = <String, int>{}.obs;

  Future<void> fetchSalesORders() async {
    try {
      isLoading(true);
      DateTime currentDate = DateTime.now();

      // Convert the Gregorian date to Nepali date
      NepaliDateTime nepaliDateTime = NepaliDateTime.fromDateTime(currentDate);

      // Format the Nepali date as "dd/MM/yyyy("
      String formattedDate =
          DateFormat('dd/MM/yyyy\'', 'en').format(nepaliDateTime);
      QuerySnapshot ordersSnapshot = await _firestore
          .collection('orders')
          .where('date', isEqualTo: "$formattedDate")
          .where('checkout', isEqualTo: 'true')
          .get();

      salesOrder.clear();

      ordersSnapshot.docs.forEach((DocumentSnapshot document) {
        OrderResponse item =
            OrderResponse.fromJson(document.data() as Map<String, dynamic>);

        if (!salesOrder.containsKey(item.productName)) {
          salesOrder[item.productName] = [item];
        } else {
          salesOrder[item.productName]?.add(item);
        }
      });

      calculateRemaningQuantity();
      isLoading(false);
    } catch (e) {
      isLoading(false);

      // Handle errors
      print("Error fetching orders: $e");
    }
  }

  // Calculate total quantity for all products
  void calculateRemaningQuantity() {
    totalSalesPerOrders.clear();
    salesOrder.forEach((productName, productOrders) {
      int totalQuantity = productOrders.fold(
        0,
        (sum, order) => sum + order.quantity,
      );
      totalSalesPerOrders[productName] = totalQuantity;
    });
  }
}
