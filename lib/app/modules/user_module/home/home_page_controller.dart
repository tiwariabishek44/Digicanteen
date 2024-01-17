import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:merocanteen/app/models/product_model.dart';
import 'package:merocanteen/app/modules/user_module/profile/group/group_controller.dart';

class HomepageContoller extends GetxController {
  final groupcontroler = Get.put(GroupController());
  final CollectionReference _productsCollection =
      FirebaseFirestore.instance.collection('products');
  var isloading = false.obs;
  final RxList<Product> products = <Product>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
    groupcontroler.fetchGroupMember();
    groupcontroler.fetchGroupsByGroupId();
  }

  Future<void> fetchProducts() async {
    try {
      isloading(true);
      final QuerySnapshot<Object?> snapshot = await _productsCollection.get();
      if (snapshot.docs.isNotEmpty) {
        products.assignAll(
          snapshot.docs
              .map((doc) => Product(
                    productId: doc.id, // Using Firestore auto-generated ID

                    name: doc['name'],
                    image: doc['image'],
                    price: doc['price'].toDouble(),
                  ))
              .toList(),
        );
        isloading(false);
      }
    } catch (e) {
      isloading(false);
      print('Error fetching products: $e');
    }
  }

  Future<void> uploadProduct() async {
    try {
      await _productsCollection.add({
        'name': 'Chowmin',
        'image':
            "https://christieathome.com/wp-content/uploads/2022/04/Chicken-Chow-Mein-13.jpg",
        'price': 50,
      });
    } catch (e) {
      print('Error uploading product: $e');
    }
  }
}
