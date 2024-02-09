import 'dart:developer';

import 'package:get/get.dart';
import 'package:merocanteen/app/models/order_response.dart';
import 'package:merocanteen/app/repository/add_order_repository.dart';
import 'package:merocanteen/app/service/api_client.dart';

class AddProductController extends GetxController {
  final AddOrderRepository orderRepository = AddOrderRepository();
  final Rx<ApiResponse<OrderResponse>> orderResponse =
      ApiResponse<OrderResponse>.initial().obs;

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
}
