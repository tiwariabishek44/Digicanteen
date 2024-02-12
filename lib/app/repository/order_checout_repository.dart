import 'package:merocanteen/app/config/api_end_points.dart';
import 'package:merocanteen/app/service/api_client.dart';

class CheckoutRepository {
  Future<SingleApiResponse<void>> orderCheckout(String groupCode) async {
    final response = await ApiClient().update<void>(
      filters: {'groupcod': groupCode},
      updateField: {'checkout': 'true'},
      collection: ApiEndpoints.orderCollection,
      responseType:
          (snapshot) {}, // Since responseType is not used for update operation
    );

    // Check if update was successful
    if (response.status == ApiStatus.SUCCESS) {
      // Update successful
      return SingleApiResponse.completed("Update successful");
    } else {
      // Update failed, return the response
      return response;
    }
  }
}
