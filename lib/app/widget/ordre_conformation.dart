import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:merocanteen/app/config/colors.dart';
import 'package:merocanteen/app/config/font_style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:merocanteen/app/modules/user_module/profile/group/group_controller.dart';
import 'package:merocanteen/app/widget/loading_screen.dart';

class OrderConfirmationDialog extends StatelessWidget {
  final VoidCallback onConfirm;
  final String quantiti;
  final String pname;
  final String image;
  final String price;
  final String date;

  OrderConfirmationDialog(
      {required this.onConfirm,
      required this.date,
      required this.price,
      required this.quantiti,
      required this.pname,
      required this.image,
      Key? key})
      : super(key: key);
  final groupcontroller = Get.put(GroupController());

  @override
  Widget build(BuildContext context) {
    return Dialog(
      alignment: Alignment.bottomCenter,
      insetPadding: EdgeInsets.zero,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.45,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 3,
              child: Obx(() {
                if (groupcontroller.currentGroup.value == null) {
                  groupcontroller.fetchGroupsByGroupId();
                  return LoadingScreen();
                } else {
                  return Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                          'Group Code ${groupcontroller.currentGroup.value!.groupCode}  ',
                          style: TextStyle(
                              fontSize: 27.0,
                              fontFamily: FontStyles.poppinBold,
                              fontWeight: FontWeight.bold)),
                      Center(
                        child: Column(
                          children: [
                            Text(
                              'Your order is under group ${groupcontroller.currentGroup.value!.groupName}',
                              style: TextStyle(
                                  fontSize: 17,
                                  color: Color.fromARGB(255, 119, 116, 116)),
                              maxLines: 2,
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }
              }),
            ),
            Expanded(
                flex: 3,
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3.0),
                    child: Row(children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: CachedNetworkImage(
                          progressIndicatorBuilder:
                              (context, url, downloadProgress) =>
                                  SpinKitFadingCircle(
                            color: secondaryColor,
                          ),
                          imageUrl: image ?? '',
                          fit: BoxFit.fill,
                          width: MediaQuery.of(context).size.width * 0.45,
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error_outline, size: 40),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              pname,
                              overflow: TextOverflow.clip,
                              style: TextStyle(fontSize: 17),
                            ),
                            Text(
                              "Quantity: " + quantiti + " /plate",
                              style: TextStyle(fontSize: 17),
                            ),
                            Text(
                              "Price: Rs." + price,
                              style: TextStyle(fontSize: 17),
                            ),
                            Text(
                              "For: " + date,
                              style: TextStyle(fontSize: 17),
                            )
                          ],
                        ),
                      )
                    ]),
                  ),
                )),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                child: true
                    ? Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            GestureDetector(
                              onTap: onConfirm,
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.45,
                                decoration: BoxDecoration(
                                  color: secondaryColor,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(
                                    child: Text(
                                  'Confirm',
                                  style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                )),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Get.back();
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.45,
                                decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(255, 238, 235, 235),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(
                                    child: Text(
                                  'Cancle',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )),
                              ),
                            )
                          ],
                        ),
                      )
                    : Container(),
              ),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
