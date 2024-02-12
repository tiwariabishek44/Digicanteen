import 'package:merocanteen/app/config/api_end_points.dart';
import 'package:merocanteen/app/models/order_response.dart';
import 'package:merocanteen/app/service/api_client.dart';

class OrderRequirementRepository {
  Future<ApiResponse<OrderResponse>> getOrderRequirement(
      String mealtime, String date) async {
    final response = await ApiClient().getFirebaseData<OrderResponse>(
      collection: ApiEndpoints.orderCollection,
      filters: mealtime == 'All'
          ? {
              "date": date,
              // Add more filters as needed
            }
          : {
              "date": date,
              "mealtime": mealtime,

              // Add more filters as needed
            },
      responseType: (json) => OrderResponse.fromJson(json),
    );

    return response;
  }
}
