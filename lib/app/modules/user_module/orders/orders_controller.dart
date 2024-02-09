import 'dart:developer';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:merocanteen/app/models/order_response.dart';
import 'package:merocanteen/app/modules/common/login/login_controller.dart';
import 'package:merocanteen/app/repository/get_user_order_repository.dart';
import 'package:merocanteen/app/service/api_client.dart';

class OrderController extends GetxController {
  final loginController = Get.put(LoginController());
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  final orderRepository = UserOrederRepository();
  final Rx<ApiResponse<OrderResponse>> orderResponse =
      ApiResponse<OrderResponse>.initial().obs;
  Future<void> fetchProducts() async {
    try {
      isLoading(true);
      orderResponse.value = ApiResponse<OrderResponse>.loading();
      final orderResult = await orderRepository.getOrders(
          loginController.userDataResponse.value.response!.first.groupid);
      if (orderResult.status == ApiStatus.SUCCESS) {
        orderResponse.value =
            ApiResponse<OrderResponse>.completed(orderResult.response);

        log("this is the all product response  " +
            orderResponse.value.response!.length.toString());
      }
    } catch (e) {
      isLoading(false);

      log('Error while getting data: $e');
    } finally {
      isLoading(false);
    }
  }
}
