import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:get_storage/get_storage.dart';
import 'package:merocanteen/app/models/order_response.dart';
import 'package:merocanteen/app/modules/common/login/login_controller.dart';
import 'package:merocanteen/app/repository/add_order_repository.dart';
import 'package:merocanteen/app/repository/get_user_order_repository.dart';
import 'package:merocanteen/app/service/api_client.dart';

class CartController extends GetxController {
  var isloading = false.obs;
  final logincontroller = Get.put(LoginController());
  final storage = GetStorage();
  final RxList<OrderResponse> orders = <OrderResponse>[].obs;
  final RxList<OrderResponse> ordersHistory = <OrderResponse>[].obs;
  var mealTime = ''.obs;
  var totalamoutn = 0.obs;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
    // Fetch cart items when the controller initializes
    log("this is inside the init");
    fetchHistory();
    fetchOrdersByGroupID();
    calculateTotalPrice();
  }

  //-----to calculate total price of the cart items------//
  void calculateTotalPrice() {
    double totalPrice = 0;

    for (var item in orders) {
      totalPrice += (item.quantity * item.price).toInt();
      // Assuming 'price' and 'quantity' are fields in your Items model
    }

    totalamoutn.value = totalPrice.toInt();
  }

  // Method to delete an item from the cart by its CID and groupID

  Future<void> deleteItemFromOrder(
    String id,
  ) async {
    try {
      isloading(true);

      final CollectionReference orders = _firestore.collection('orders');

      QuerySnapshot querySnapshot =
          await orders.where('id', isEqualTo: id).get();

      // Delete each document in the query result
      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        await doc.reference.delete();
      }
      fetchOrdersByGroupID();

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

  Future<void> fetchOrdersByGroupID() async {
    try {
      isloading(true);
      log("-----thid fetch order by gorup id is run");
      final QuerySnapshot<Map<String, dynamic>> studentsSnapshot =
          await _firestore
              .collection('orders')
              .where('groupid', isEqualTo: storage.read("groupid"))
              .where('checkout', isEqualTo: "false")
              .get();

      orders.clear();

      final List<OrderResponse> order = studentsSnapshot.docs.map((doc) {
        return OrderResponse.fromJson(doc.data());
      }).toList();

      orders.assignAll(order);
      isloading(false);
    } catch (e) {
      isloading(false);
      print("Error fetching group members: $e");
      // Handle error - show a snackbar, display an error message, etc.
    }
  }

//------------fetch the history orders---------///

  Future<void> fetchHistory() async {
    try {
      final QuerySnapshot<Map<String, dynamic>> studentsSnapshot =
          await _firestore
              .collection('orders')
              .where('groupid', isEqualTo: storage.read("groupid"))
              .where('checkout', isEqualTo: "true")
              .get();
      log('after the querry snapshot.');

      ordersHistory.clear();

      final List<OrderResponse> order = studentsSnapshot.docs.map((doc) {
        return OrderResponse.fromJson(doc.data());
      }).toList();

      ordersHistory.assignAll(order);
      isloading(false);
      log("-----order is fetched order lenght ${orders.length}");
    } catch (e) {
      isloading(false);
      // Handle error - show a snackbar, display an error message, etc.
    }
  }

//----to add the items in the cart or create new if new user---//

  final AddOrderRepository orderRepository = AddOrderRepository();
  final Rx<ApiResponse<OrderResponse>> orderResponse =
      ApiResponse<OrderResponse>.initial().obs;

  Future<void> addProduct() async {
    orderResponse.value = ApiResponse<OrderResponse>.loading();
    final market = {};
    log("--------------product image");
    final addOrderResult = await orderRepository.addOrder(market);

    if (addOrderResult.status == ApiStatus.SUCCESS) {
      orderResponse.value =
          ApiResponse<OrderResponse>.completed(addOrderResult.response);
      log(" THS IS THE RESPONSE VALUE:${addOrderResult.status}");
      // Navigate to home page or perform necessary actions upon successful login
      Get.back();
    } else {
      orderResponse.value = ApiResponse<OrderResponse>.error(
          addOrderResult.message ?? 'Error during product create Failed');
    }
  }

  Future<void> addItemToOrder({
    required String classs,
    required String customer,
    required String groupid,
    required String cid,
    required String productName,
    required String productImage,
    required double price,
    required int quantity,
    required String groupcod,
    required String checkout,
    required String mealtime,
    required String date,
  }) async {
    try {
      DateTime now = DateTime.now();
      String productId =
          '${now.year}${now.month}${now.day}${now.hour}${now.minute}${now.second}${now.millisecond}';

      final newItem = {
        "id": '${productId + customer + productName}',
        "mealtime": mealtime,
        "classs": classs,
        "date": date,
        "checkout": 'false',
        "customer": customer,
        "groupcod": groupcod,
        "groupid": groupid,
        "cid": cid,
        "productName": productName,
        "price": price,
        "quantity": quantity,
        "productImage": productImage,
      };

      orderResponse.value = ApiResponse<OrderResponse>.loading();

      log("--------------product image");
      final addOrderResult = await orderRepository.addOrder(newItem);

      if (addOrderResult.status == ApiStatus.SUCCESS) {
        orderResponse.value =
            ApiResponse<OrderResponse>.completed(addOrderResult.response);
        log(" THS IS THE RESPONSE VALUE:${addOrderResult.status}");
        // Navigate to home page or perform necessary actions upon successful login
        Get.back();
      } else {
        orderResponse.value = ApiResponse<OrderResponse>.error(
            addOrderResult.message ?? 'Error during product create Failed');
      }
      fetchOrdersByGroupID();
    } catch (e) {
      // If an error occurs during the process, you can handle it here
      print('Error adding item to orders: $e');
      Get.snackbar(
        'Error',
        'Failed to add item to orders. Please try again later.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

//-------------fetch user orders-------------

  final GetUserOrderRepository userDataRepository = GetUserOrderRepository();
  final Rx<ApiResponse<OrderResponse>> userDataResponse =
      ApiResponse<OrderResponse>.initial().obs;
  Future<void> fetchUserOrder() async {
    try {
      isloading(true);
      userDataResponse.value = ApiResponse<OrderResponse>.loading();
      final userDataResult = await userDataRepository.getUserOrder(
          'userid', storage.read('userId'));
      if (userDataResult.status == ApiStatus.SUCCESS) {
        log("----------this is the success t fetch the user data");
        userDataResponse.value =
            ApiResponse<OrderResponse>.completed(userDataResult.response);

        log(userDataResponse.value.response!.length.toString());
      }
    } catch (e) {
      isloading(false);

      log('Error while getting data: $e');
    } finally {
      isloading(false);
    }
  }

  // Method to delete an item from the cart by its CID and groupID
}
