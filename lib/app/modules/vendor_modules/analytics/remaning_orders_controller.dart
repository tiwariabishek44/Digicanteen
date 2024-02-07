import 'package:carousel_slider/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:intl/intl.dart';
import 'package:merocanteen/app/models/order_response.dart';
import 'package:nepali_utils/nepali_utils.dart';

class RemaningOrdersController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  var isLoading = false.obs;
  RxList<OrderResponse> orderss =
      <OrderResponse>[].obs; // RxList to make it reactive
  RxDouble grandTotal = 0.0.obs; // RxDouble for the grand total
  List<String> timeSlots = [
    'All',
    '8:30',
    '9:30',
    '11:30',
    '12:30',
    '1:30',
  ];

  @override
  void onInit() {
    super.onInit();
    fetchRemaningOreders('All');
  }

  void fetchRemaningMeal(int index) {
    fetchRemaningOreders(timeSlots[index]);
  }

//--------------fetching the remaning orders---------------------//
  RxMap<String, List<OrderResponse>> reamaningorders =
      <String, List<OrderResponse>>{}.obs;
  RxMap<String, int> totalremaningOrders = <String, int>{}.obs;

  Future<void> fetchRemaningOreders(String mealtime) async {
    try {
      isLoading(true);
      DateTime currentDate = DateTime.now();

      // Convert the Gregorian date to Nepali date
      NepaliDateTime nepaliDateTime = NepaliDateTime.fromDateTime(currentDate);

      // Format the Nepali date as "dd/MM/yyyy("
      String formattedDate =
          DateFormat('dd/MM/yyyy\'', 'en').format(nepaliDateTime);

      QuerySnapshot ordersSnapshot;

      if (mealtime == 'All') {
        ordersSnapshot = await _firestore
            .collection('orders')
            .where('date', isEqualTo: formattedDate)
            .where('checkout', isEqualTo: 'false')
            .get();
      } else {
        ordersSnapshot = await _firestore
            .collection('orders')
            .where("mealtime", isEqualTo: mealtime)
            .where('date', isEqualTo: formattedDate)
            .where('checkout', isEqualTo: 'false')
            .get();
      }

      reamaningorders.clear();

      ordersSnapshot.docs.forEach((DocumentSnapshot document) {
        OrderResponse item =
            OrderResponse.fromJson(document.data() as Map<String, dynamic>);

        if (!reamaningorders.containsKey(item.productName)) {
          reamaningorders[item.productName] = [item];
        } else {
          reamaningorders[item.productName]?.add(item);
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
    totalremaningOrders.clear();
    reamaningorders.forEach((productName, productOrders) {
      int totalQuantity = productOrders.fold(
        0,
        (sum, order) => sum + order.quantity,
      );
      totalremaningOrders[productName] = totalQuantity;
    });
  }
}
