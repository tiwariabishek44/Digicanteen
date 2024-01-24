import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:merocanteen/app/config/font_style.dart';
import 'package:merocanteen/app/models/cart_models.dart';
import 'package:merocanteen/app/models/product_model.dart';
import 'package:merocanteen/app/modules/common/login/login_controller.dart';
import 'package:merocanteen/app/modules/user_module/cart/cart_controller.dart';
import 'package:merocanteen/app/modules/user_module/profile/group/group_controller.dart';
import 'package:merocanteen/app/widget/custom_appbar.dart';
import 'package:merocanteen/app/widget/custom_popup.dart';
import 'package:merocanteen/app/widget/logout_conformation_dialog.dart';
import 'package:merocanteen/app/widget/ordre_conformation.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ProductDetailPage extends StatelessWidget {
  final Product product;

  ProductDetailPage({
    super.key,
    required this.product,
  });
  final logincontroller = Get.put(LoginController());
  final groupcontroller = Get.put(GroupController());
  final cartController = Get.find<CartController>();

  @override
  Widget build(BuildContext context) {
    DateTime currentDate = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(currentDate);

    return SafeArea(
      child: Scaffold(
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 1,
                            height: MediaQuery.of(context).size.height * 0.3,
                            child: CachedNetworkImage(
                              imageUrl: product.image ??
                                  '', // Use a default empty string if URL is null
                              fit: BoxFit.fitWidth,
                              errorWidget: (context, url, error) => Icon(
                                  Icons.error_outline,
                                  size: 40), // Placeholder icon for error
                            ),
                          ),
                          Positioned(
                            top: 0,
                            left: 0,
                            right: 0,
                            child: CustomAppBar(back: true),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.name, // Replace with actual product name
                              style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: FontStyles.poppins),
                            ),
                            SizedBox(height: 10),
                            Text(
                              "Rs.${product.price}",
                              style: TextStyle(
                                  color: Colors.red.shade200,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 20),

                            SizedBox(height: 10),
                            // Use Cards to display additional info
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  flex: 6,
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Qnty:",
                                          style: TextStyle(fontSize: 20),
                                        ),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        Row(
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5.0),
                                                color: Colors.grey[200],
                                              ),
                                              child: SizedBox(
                                                width: 35.0,
                                                height: 35.0,
                                                child: IconButton(
                                                  icon: Icon(Icons.add),
                                                  onPressed: () {},
                                                  iconSize:
                                                      20.0, // Adjust the icon size as needed
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 8.0),
                                            Text(
                                              '${'2'}',
                                              style: TextStyle(fontSize: 16.0),
                                            ),
                                            SizedBox(width: 8.0),
                                            Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5.0),
                                                color: Colors.grey[200],
                                              ),
                                              child: SizedBox(
                                                width: 35.0,
                                                height: 35.0,
                                                child: IconButton(
                                                  icon: Icon(Icons.remove),
                                                  onPressed: () {},
                                                  iconSize:
                                                      20.0, // Adjust the icon size as needed
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Spacer(),
                                Expanded(
                                  flex: 4,
                                  child: InkWell(
                                    onTap: () {
                                      final user = logincontroller.user.value;
                                      final group =
                                          groupcontroller.currentGroup.value;
                                      user!.groupid.isNotEmpty
                                          ? showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return OrderConfirmationDialog(
                                                  date: formattedDate,
                                                  image: product.image,
                                                  pname: product.name,
                                                  price: product.price
                                                      .toInt()
                                                      .toString(),
                                                  onConfirm: () {
                                                    // Items newItem = Items(
                                                    //     classs: user!.classes,
                                                    //     date: formattedDate,
                                                    //     checkout: 'false',
                                                    //     customer: user!.name,
                                                    //     groupcod:
                                                    //         group!.groupCode,
                                                    //     groupid: user.groupid,
                                                    //     cid: user.userid,
                                                    //     productName:
                                                    //         product.name,
                                                    //     price: product.price,
                                                    //     quantity: 1,
                                                    //     productImage:
                                                    //         product.image);
                                                    // cartController
                                                    //     .addItemToOrder(
                                                    //         newItem);

                                                    // Get.back();
                                                    // showDialog(
                                                    //   context: context,
                                                    //   builder: (BuildContext
                                                    //       context) {
                                                    //     return CustomPopup();
                                                    //   },
                                                    // );
                                                  },
                                                );
                                              },
                                            )
                                          : showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return LogoutConfirmationDialog(
                                                  isbutton: false,
                                                  heading:
                                                      'You are not in any group',
                                                  subheading:
                                                      "Make a group or join a group",
                                                  firstbutton: "Ok",
                                                  secondbutton: 'Cancle',
                                                  onConfirm: () {},
                                                );
                                              },
                                            );

                                      // Handle add to cart functionality
                                    },
                                    child: Container(
                                      height: 5.h,
                                      decoration: BoxDecoration(
                                          color: Colors.red
                                              .shade200, // 4/10 of the screen width
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      width: MediaQuery.of(context).size.width *
                                          0.25,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.shopping_cart),
                                          SizedBox(
                                              width:
                                                  8), // Add some space between icon and text
                                          Text('Add  '),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )

                            // Add more Cards for other details
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(IconData icon, String label, String value) {
    return Card(
      elevation: 3,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(icon),
        title: Text(
          label,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(value),
      ),
    );
  }
}
