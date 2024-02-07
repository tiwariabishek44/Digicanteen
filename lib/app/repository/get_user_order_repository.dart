import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:merocanteen/app/config/api_end_points.dart';
import 'package:merocanteen/app/models/order_response.dart';
import 'package:merocanteen/app/service/api_client.dart';

class GetUserOrderRepository {
  Future<ApiResponse<OrderResponse>> getUserOrder(
      String filterField, String filterValue) async {
    final response = await ApiClient().getFirebaseData<OrderResponse>(
      collection: ApiEndpoints.studentCollection,
      filters: {
        'field1_to_filter_by': 'value1_to_filter_for',
        'field2_to_filter_by': 'value2_to_filter_for',
        // Add more filters as needed
      },
      responseType: (json) => OrderResponse.fromJson(json),
    );

    return response;
  }
}
