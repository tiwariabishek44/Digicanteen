import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:merocanteen/app/config/colors.dart';
import 'package:merocanteen/app/models/cart_models.dart';
import 'package:merocanteen/app/models/product_model.dart';
import 'package:merocanteen/app/modules/common/login/login_controller.dart';
import 'package:merocanteen/app/modules/user_module/cart/cart_controller.dart';
import 'package:merocanteen/app/modules/user_module/home/product_detai_page.dart';
import 'package:merocanteen/app/modules/user_module/profile/group/group_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:merocanteen/app/widget/custom_snackbar.dart';
import 'package:merocanteen/app/widget/loading_screen.dart';
import 'package:merocanteen/app/widget/logout_conformation_dialog.dart';
import 'package:merocanteen/app/widget/ordre_conformation.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:intl/intl.dart';

// Define the reusable product grid widget
class ProductGrid extends StatefulWidget {
  final List<Product> productList; // Receive the product list as a parameter

  ProductGrid({Key? key, required this.productList}) : super(key: key);

  @override
  State<ProductGrid> createState() => _ProductGridState();
}

class _ProductGridState extends State<ProductGrid> {
  late List<int> quantities; // State to maintain quantities of each product
  final logincontroller = Get.put(LoginController());
  final groupcontroller = Get.put(GroupController());
  CartController cartController = Get.find<CartController>();

  @override
  void initState() {
    super.initState();
    quantities = List.generate(widget.productList.length, (index) => 1);
  }

  void incrementQuantity(int index) {
    if (quantities[index] < 2) {
      setState(() {
        quantities[index]++;
      });
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Limit Exceeded'),
            content: Text('Your limit is 2 plate.'),
          );
        },
      );
    }
  }

  void decrementQuantity(int index) {
    if (quantities[index] > 1) {
      setState(() {
        quantities[index]--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    DateTime currentDate = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(currentDate);
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // number of items in each row
          mainAxisSpacing: 10.0, // spacing between rows
          crossAxisSpacing: 10.0, // spacing between columns
          childAspectRatio: 0.67),
      padding: EdgeInsets.all(8.0), // padding around the grid
      itemCount: widget.productList.length, // total number of items
      itemBuilder: (context, index) {
        return Container(
          decoration: const BoxDecoration(
              color: Color.fromARGB(255, 235, 230, 230),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20))),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(
              flex: 6,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20)),
                child: CachedNetworkImage(
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      SpinKitFadingCircle(
                    color: secondaryColor,
                  ),
                  imageUrl: widget.productList[index].image ?? '',
                  fit: BoxFit.fill,
                  width: double.infinity,
                  errorWidget: (context, url, error) =>
                      Icon(Icons.error_outline, size: 40),
                ),
              ),
            ),
            Expanded(
                flex: 4,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("${widget.productList[index].name}",
                            style: TextStyle(fontSize: 17)),
                        Text(
                            "Rs ${widget.productList[index].price.toInt()}/plate",
                            style: TextStyle(fontSize: 13)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Obx(() {
                              if (groupcontroller.currentGroup.value == null) {
                                groupcontroller.fetchGroupsByGroupId();
                                return LoadingScreen();
                              } else {
                                return GestureDetector(
                                  onTap: () {
                                    final user = logincontroller.user.value;
                                    // ignore: invalid_use_of_protected_member
                                    final group =
                                        groupcontroller.currentGroup.value;
                                    user!.groupid.isNotEmpty
                                        ? showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return OrderConfirmationDialog(
                                                date: formattedDate,
                                                price: widget
                                                    .productList[index].price
                                                    .toInt()
                                                    .toString(),
                                                image: widget
                                                    .productList[index].image,
                                                onConfirm: () {
                                                  Items newItem = Items(
                                                      classs: user!.classes,
                                                      date: formattedDate,
                                                      checkout: 'false',
                                                      customer: user.name,
                                                      groupcod:
                                                          group!.groupCode,
                                                      groupid: user.groupid,
                                                      cid: user.userid,
                                                      productName: widget
                                                          .productList[index]
                                                          .name,
                                                      price: widget
                                                          .productList[index]
                                                          .price,
                                                      quantity:
                                                          quantities[index],
                                                      productImage: widget
                                                          .productList[index]
                                                          .image);
                                                  cartController
                                                      .addItemToOrder(newItem);

                                                  Get.back();

                                                  setState(() {
                                                    quantities[index] = 1;
                                                  });

                                                  CustomSnackbar(
                                                    backgroundColor:
                                                        Color.fromARGB(
                                                            255, 227, 226, 220),
                                                    title: 'Success',
                                                    message:
                                                        'Your order has been placed!',
                                                    duration:
                                                        Duration(seconds: 4),
                                                    textColor: Colors.black87,
                                                    snackPosition:
                                                        SnackPosition.BOTTOM,
                                                  ).showSnackbar();
                                                },
                                                quantiti: '1',
                                                pname: widget
                                                    .productList[index].name,
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
                                    decoration: BoxDecoration(
                                        color: Colors.red
                                            .shade200, // 4/10 of the screen width
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: const Padding(
                                      padding: EdgeInsets.all(5.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
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
                                );
                              }
                            })
                          ],
                        ),
                      ]),
                ))
          ]),
        );
      },
    );

    // return GridView.builder(
    //   shrinkWrap: false,
    //   physics: ScrollPhysics(),
    //   padding: const EdgeInsets.all(8.0),
    //   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
    //     crossAxisCount:
    //         1, // Change this to 1 to display a single item in the grid
    //     crossAxisSpacing: 2.0,
    //     mainAxisSpacing: 12.0,
    //     childAspectRatio: 1,
    //   ),
    //   itemCount: widget.productList.length,
    //   itemBuilder: (BuildContext context, int index) {
    //     return GestureDetector(
    //       child: Container(
    //         decoration: BoxDecoration(
    //             color: const Color.fromARGB(255, 235, 230, 230),
    //             borderRadius: BorderRadius.only(
    //                 topLeft: Radius.circular(20),
    //                 topRight: Radius.circular(20),
    //                 bottomRight: Radius.circular(20),
    //                 bottomLeft: Radius.circular(20))),
    //         child: Column(
    //           crossAxisAlignment: CrossAxisAlignment.stretch,
    //           children: <Widget>[
    //             Expanded(
    //               flex: 7,
    //               child: ClipRRect(
    //                 borderRadius: BorderRadius.only(
    //                     topLeft: Radius.circular(20),
    //                     topRight: Radius.circular(20)),
    //                 child: CachedNetworkImage(
    //                   progressIndicatorBuilder:
    //                       (context, url, downloadProgress) =>
    //                           SpinKitFadingCircle(
    //                     color: secondaryColor,
    //                   ),
    //                   imageUrl: widget.productList[index].image ?? '',
    //                   fit: BoxFit.fill,
    //                   errorWidget: (context, url, error) =>
    //                       Icon(Icons.error_outline, size: 40),
    //                 ),
    //               ),
    //             ),
    //             Expanded(
    //                 flex: 3,
    //                 child: Container(
    //                     decoration: BoxDecoration(
    //                       color: const Color.fromARGB(255, 235, 230, 230),
    //                       borderRadius: BorderRadius.only(
    //                           bottomLeft: Radius.circular(20),
    //                           bottomRight: Radius.circular(20)),
    //                     ),
    //                     child: Padding(
    //                       padding: const EdgeInsets.only(left: 8.0, right: 8),
    //                       child: Column(
    //                         children: [
    //                           Expanded(
    //                             flex: 4,
    //                             child: Padding(
    //                               padding: const EdgeInsets.symmetric(
    //                                   horizontal: 10.0),
    //                               child: Row(
    //                                 mainAxisAlignment:
    //                                     MainAxisAlignment.spaceBetween,
    //                                 children: [
    //                                   Text("${widget.productList[index].name}",
    //                                       style: TextStyle(fontSize: 20)),
    //                                   Text(
    //                                       "Rs ${widget.productList[index].price.toInt()}/plate",
    //                                       style: TextStyle(fontSize: 15)),
    //                                 ],
    //                               ),
    //                             ),
    //                           ),
    //                           Expanded(
    //                             flex: 6,
    //                             child: Row(
    //                               crossAxisAlignment: CrossAxisAlignment.start,
    //                               mainAxisAlignment:
    //                                   MainAxisAlignment.spaceBetween,
    //                               children: [
    //                                 Expanded(
    //                                   flex: 6,
    //                                   child: Padding(
    //                                     padding: const EdgeInsets.all(10.0),
    //                                     child: Row(
    //                                       mainAxisAlignment:
    //                                           MainAxisAlignment.center,
    //                                       children: [
    //                                         Text(
    //                                           "Qnty:",
    //                                           style: TextStyle(fontSize: 20),
    //                                         ),
    //                                         SizedBox(
    //                                           width: 20,
    //                                         ),
    //                                         Row(
    //                                           children: [
    //                                             Container(
    //                                               decoration: BoxDecoration(
    //                                                 borderRadius:
    //                                                     BorderRadius.circular(
    //                                                         5.0),
    //                                                 color: Colors.grey[200],
    //                                               ),
    //                                               child: SizedBox(
    //                                                 width: 35.0,
    //                                                 height: 35.0,
    //                                                 child: IconButton(
    //                                                   icon: Icon(Icons.add),
    //                                                   onPressed: () {
    //                                                     incrementQuantity(
    //                                                         index);
    //                                                   },
    //                                                   iconSize:
    //                                                       20.0, // Adjust the icon size as needed
    //                                                 ),
    //                                               ),
    //                                             ),
    //                                             SizedBox(width: 8.0),
    //                                             Text(
    //                                               '${quantities[index]}',
    //                                               style:
    //                                                   TextStyle(fontSize: 16.0),
    //                                             ),
    //                                             SizedBox(width: 8.0),
    //                                             Container(
    //                                               decoration: BoxDecoration(
    //                                                 borderRadius:
    //                                                     BorderRadius.circular(
    //                                                         5.0),
    //                                                 color: Colors.grey[200],
    //                                               ),
    //                                               child: SizedBox(
    //                                                 width: 35.0,
    //                                                 height: 35.0,
    //                                                 child: IconButton(
    //                                                   icon: Icon(Icons.remove),
    //                                                   onPressed: () {
    //                                                     decrementQuantity(
    //                                                         index);
    //                                                   },
    //                                                   iconSize:
    //                                                       20.0, // Adjust the icon size as needed
    //                                                 ),
    //                                               ),
    //                                             ),
    //                                           ],
    //                                         )
    //                                       ],
    //                                     ),
    //                                   ),
    //                                 ),
    //                                 Spacer(),
    //                                 Expanded(
    //                                   flex: 4,
    //                                   child: InkWell(
    //                                     onTap: () {
    //                                       final user =
    //                                           logincontroller.user.value;
    //                                       final group =
    //                                           groupcontroller.groups.value;
    //                                       user!.groupid.isNotEmpty
    //                                           ? showDialog(
    //                                               context: context,
    //                                               builder:
    //                                                   (BuildContext context) {
    //                                                 return OrderConfirmationDialog(
    //                                                   onConfirm: () {
    //                                                     Items newItem = Items(
    //                                                         date: formattedDate,
    //                                                         checkout: 'false',
    //                                                         customer:
    //                                                             user!.name,
    //                                                         groupcod: group![0]
    //                                                             .groupCode,
    //                                                         groupid:
    //                                                             user.groupid,
    //                                                         cid: user.userid,
    //                                                         productName: widget
    //                                                             .productList[
    //                                                                 index]
    //                                                             .name,
    //                                                         price: widget
    //                                                             .productList[
    //                                                                 index]
    //                                                             .price,
    //                                                         quantity:
    //                                                             quantities[
    //                                                                 index],
    //                                                         productImage: widget
    //                                                             .productList[
    //                                                                 index]
    //                                                             .image);
    //                                                     cartController
    //                                                         .addItemToOrder(
    //                                                             newItem);

    //                                                     Get.back();

    //                                                     setState(() {
    //                                                       quantities[index] = 1;
    //                                                     });

    //                                                     CustomSnackbar(
    //                                                       backgroundColor:
    //                                                           Color.fromARGB(
    //                                                               255,
    //                                                               227,
    //                                                               226,
    //                                                               220),
    //                                                       title: 'Success',
    //                                                       message:
    //                                                           'Your order has been placed!',
    //                                                       duration: Duration(
    //                                                           seconds: 4),
    //                                                       textColor:
    //                                                           Colors.black87,
    //                                                       snackPosition:
    //                                                           SnackPosition
    //                                                               .BOTTOM,
    //                                                     ).showSnackbar();
    //                                                   },
    //                                                 );
    //                                               },
    //                                             )
    //                                           : showDialog(
    //                                               context: context,
    //                                               builder:
    //                                                   (BuildContext context) {
    //                                                 return LogoutConfirmationDialog(
    //                                                   isbutton: false,
    //                                                   heading:
    //                                                       'You are not in any group',
    //                                                   subheading:
    //                                                       "Make a group or join a group",
    //                                                   firstbutton: "Ok",
    //                                                   secondbutton: 'Cancle',
    //                                                   onConfirm: () {},
    //                                                 );
    //                                               },
    //                                             );

    //                                       // Handle add to cart functionality
    //                                     },
    //                                     child: Container(
    //                                       height: 5.h,
    //                                       decoration: BoxDecoration(
    //                                           color: Colors.red
    //                                               .shade200, // 4/10 of the screen width
    //                                           borderRadius:
    //                                               BorderRadius.circular(10)),
    //                                       width: MediaQuery.of(context)
    //                                               .size
    //                                               .width *
    //                                           0.25,
    //                                       child: Row(
    //                                         mainAxisAlignment:
    //                                             MainAxisAlignment.center,
    //                                         children: [
    //                                           Icon(Icons.shopping_cart),
    //                                           SizedBox(
    //                                               width:
    //                                                   8), // Add some space between icon and text
    //                                           Text('Add  '),
    //                                         ],
    //                                       ),
    //                                     ),
    //                                   ),
    //                                 ),
    //                               ],
    //                             ),
    //                           ),
    //                         ],
    //                       ),
    //                     )))
    //           ],
    //         ),
    //       ),
    //     );
    //   },
    // );
  }
}
