import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:intl/intl.dart';
import 'package:merocanteen/app/models/cart_models.dart';

class OrderRequestContoller extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  RxMap<String, List<Items>> orders = <String, List<Items>>{}.obs;
  RxMap<String, int> totalQuantityPerProduct = <String, int>{}.obs;
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
      QuerySnapshot ordersSnapshot = await _firestore
          .collection('orders')
          .where('date', isEqualTo: "$formattedDate")
          .get();

      ordersSnapshot.docs.forEach((DocumentSnapshot document) {
        Items item = Items.fromMap(document.data() as Map<String, dynamic>);

        if (!orders.containsKey(item.productName)) {
          orders[item.productName] = [item];
          isloading(false);
        } else {
          orders[item.productName]?.add(item);
          isloading(false);
        }
      });

      calculateTotalQuantity();
      isloading(false);
    } catch (e) {
      isloading(false);

      // Handle errors
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
