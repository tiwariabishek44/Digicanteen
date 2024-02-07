import 'dart:developer';

import 'package:merocanteen/app/models/product_model.dart';
import 'package:merocanteen/app/service/api_client.dart';

class AllProductRepository {
  final ApiClient _apiClient = ApiClient();

  Future<ApiResponse<Product>> getallproducts() async {
    final response = await ApiClient().getFirebaseData<Product>(
      collection: 'products',
      responseType: (json) => Product.fromJson(json),
    );

    return response;
  }
}
