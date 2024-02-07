import 'dart:developer';

import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_storage/get_storage.dart';
import 'package:merocanteen/app/models/product_model.dart';
import 'package:merocanteen/app/modules/user_module/profile/group/group_controller.dart';
import 'package:merocanteen/app/repository/product_respository.dart';
import 'package:merocanteen/app/service/api_client.dart';

class HomepageContoller extends GetxController {
  final groupcontroler = Get.put(GroupController());
  final CollectionReference _productsCollection =
      FirebaseFirestore.instance.collection('products');
  var isLoading = false.obs;
  final RxList<Product> products = <Product>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  final AllProductRepository allProductRepository = AllProductRepository();
  final Rx<ApiResponse<Product>> allProductResponse =
      ApiResponse<Product>.initial().obs;
  Future<void> fetchProducts() async {
    try {
      isLoading(true);
      allProductResponse.value = ApiResponse<Product>.loading();
      final allProductResult = await allProductRepository.getallproducts();
      if (allProductResult.status == ApiStatus.SUCCESS) {
        log("this is the success");
        allProductResponse.value =
            ApiResponse<Product>.completed(allProductResult.response);

        log(allProductResponse.value.response!.length.toString());
      }
    } catch (e) {
      isLoading(false);

      log('Error while getting data: $e');
    } finally {
      isLoading(false);
    }
  }
}


//   Future<void> fetchProducts() async {
//     try {
//       isloading(true);
//       final QuerySnapshot<Object?> snapshot = await _productsCollection.get();
//       if (snapshot.docs.isNotEmpty) {
//         products.assignAll(
//           snapshot.docs
//               .map((doc) => Product(
//                     productId: doc.id, // Using Firestore auto-generated ID

//                     name: doc['name'],
//                     image: doc['image'],
//                     price: doc['price'].toDouble(),
//                   ))
//               .toList(),
//         );
//         isloading(false);
//       }
//     } catch (e) {
//       isloading(false);
//       print('Error fetching products: $e');
//     }
//   }

//   Future<void> uploadProduct() async {
//     try {
//       await _productsCollection.add({
//         'name': 'Chowmin',
//         'image':
//             "https://christieathome.com/wp-content/uploads/2022/04/Chicken-Chow-Mein-13.jpg",
//         'price': 50,
//       });
//     } catch (e) {
//       print('Error uploading product: $e');
//     }
//   }
// }
