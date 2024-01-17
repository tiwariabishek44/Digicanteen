import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:get_storage/get_storage.dart';
import 'package:merocanteen/app/models/cart_models.dart';
import 'package:merocanteen/app/modules/common/login/login_controller.dart';

class CartController extends GetxController {
  var isloading = false.obs;
  final logincontroller = Get.put(LoginController());
  final storage = GetStorage();
  final RxList<Items> orders = <Items>[].obs;
  final RxList<Items> ordersHistory = <Items>[].obs;

  var totalamoutn = 0.obs;
  var quantity = 1.obs;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
    // Fetch cart items when the controller initializes
    log("this is inside the init");
    fetchHistory();
    fetchOrdersByGroupID();
    calculateTotalPrice();
  }

  //-----to calculate total price of the cart items------//
  void calculateTotalPrice() {
    double totalPrice = 0;

    for (var item in orders) {
      totalPrice += (item.quantity * item.price).toInt();
      // Assuming 'price' and 'quantity' are fields in your Items model
    }

    totalamoutn.value = totalPrice.toInt();
  }

  // Method to delete an item from the cart by its CID and groupID
  Future<void> deleteItemFromOrder() async {
    try {
      isloading(true);
      final user = logincontroller.user.value;

      final CollectionReference orders = _firestore.collection('orders');

      QuerySnapshot querySnapshot = await orders
          .where('cid', isEqualTo: user!.userid)
          .where('groupid', isEqualTo: storage.read("groupid"))
          .get();

      // Assuming there's only one matching document, delete it
      if (querySnapshot.docs.isNotEmpty) {
        await orders.doc(querySnapshot.docs.first.id).delete();
      }

      // Fetch updated cart items after deletion
      await fetchOrdersByGroupID();

      isloading(false);
    } catch (e) {
      isloading(false);

      // Handle errors if any
      print('Error deleting item from orders: $e');
      Get.snackbar(
        'Error',
        'Failed to delete item from orders. Please try again later.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> fetchOrdersByGroupID() async {
    try {
      isloading(true);
      log("-----thid fetch order by gorup id is run");
      final QuerySnapshot<Map<String, dynamic>> studentsSnapshot =
          await _firestore
              .collection('orders')
              .where('groupid', isEqualTo: storage.read("groupid"))
              .where('checkout', isEqualTo: "false")
              .get();
      log('after the querry snapshot.');

      orders.clear();

      final List<Items> order = studentsSnapshot.docs.map((doc) {
        return Items.fromMap(doc.data());
      }).toList();

      orders.assignAll(order);
      isloading(false);
      log("-----order is fetched order lenght ${orders.length}");
    } catch (e) {
      isloading(false);
      print("Error fetching group members: $e");
      // Handle error - show a snackbar, display an error message, etc.
    }
  }

//------------fetch the history orders---------///

  Future<void> fetchHistory() async {
    try {
      isloading(true);
      log("-----thid fetch order by gorup id is run");
      final QuerySnapshot<Map<String, dynamic>> studentsSnapshot =
          await _firestore
              .collection('orders')
              .where('groupid', isEqualTo: storage.read("groupid"))
              .where('checkout', isEqualTo: "true")
              .get();
      log('after the querry snapshot.');

      ordersHistory.clear();

      final List<Items> order = studentsSnapshot.docs.map((doc) {
        return Items.fromMap(doc.data());
      }).toList();

      ordersHistory.assignAll(order);
      isloading(false);
      log("-----order is fetched order lenght ${orders.length}");
    } catch (e) {
      isloading(false);
      print("Error fetching group members: $e");
      // Handle error - show a snackbar, display an error message, etc.
    }
  }

//----to add the items in the cart or create new if new user---//

  Future<void> addItemToOrder(Items item) async {
    try {
      CollectionReference orders = _firestore.collection('orders');

      await orders.add(
          item.toMap()); // Assuming toMap() converts your Items class to a Map

      // You can also perform additional actions after adding the item, if needed

      fetchOrdersByGroupID();
      quantity.value = 1;
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
//-----to fetch all the order items by pin by vender-------//

  // Method to delete an item from the cart by its CID and groupID
}
