import 'dart:developer';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:merocanteen/app/models/order_response.dart';
import 'package:merocanteen/app/models/users_model.dart';
import 'package:merocanteen/app/modules/common/login/login_controller.dart';
import 'package:merocanteen/app/repository/get_friend_list_repository.dart';
import 'package:merocanteen/app/repository/get_user_order_repository.dart';
import 'package:merocanteen/app/service/api_client.dart';

class FriendListController extends GetxController {
  final loginController = Get.put(LoginController());
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchFrields();
  }

  final friendRepository = GetFriendRepository();
  final Rx<ApiResponse<UserDataResponse>> userDataResponse =
      ApiResponse<UserDataResponse>.initial().obs;
  Future<void> fetchFrields() async {
    try {
      isLoading(true);
      userDataResponse.value = ApiResponse<UserDataResponse>.loading();
      final friendsResults = await friendRepository.getallfriends(
          loginController.userDataResponse.value.response!.first.classes);
      if (friendsResults.status == ApiStatus.SUCCESS) {
        userDataResponse.value =
            ApiResponse<UserDataResponse>.completed(friendsResults.response);

        log("this is the all product response  " +
            userDataResponse.value.response!.length.toString());
      }
    } catch (e) {
      isLoading(false);

      log('Error while getting data: $e');
    } finally {
      isLoading(false);
    }
  }
}
