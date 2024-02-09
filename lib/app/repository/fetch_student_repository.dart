import 'package:merocanteen/app/config/api_end_points.dart';
import 'package:merocanteen/app/models/order_response.dart';
import 'package:merocanteen/app/models/users_model.dart';
import 'package:merocanteen/app/service/api_client.dart';

class FetchStudentDataRepository {
  Future<ApiResponse<UserDataResponse>> getUserOrder(
      String filterField, String filterValue) async {
    final response = await ApiClient().getFirebaseData<UserDataResponse>(
      collection: ApiEndpoints.studentCollection,
      filters: {
        'field1_to_filter_by': 'value1_to_filter_for',
        'field2_to_filter_by': 'value2_to_filter_for',
        // Add more filters as needed
      },
      responseType: (json) => UserDataResponse.fromJson(json),
    );

    return response;
  }
}
