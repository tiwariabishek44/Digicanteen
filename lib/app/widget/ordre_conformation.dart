import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:merocanteen/app/config/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:merocanteen/app/modules/user_module/orders/orders_controller.dart';
import 'package:merocanteen/app/modules/user_module/group/group_controller.dart';
import 'package:merocanteen/app/widget/loading_screen.dart';
import 'package:nepali_utils/nepali_utils.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class OrderConfirmationDialog extends StatefulWidget {
  final VoidCallback onConfirm;
  final String pname;
  final String image;
  final String price;
  final String date;

  OrderConfirmationDialog(
      {required this.onConfirm,
      required this.date,
      required this.price,
      required this.pname,
      required this.image,
      Key? key})
      : super(key: key);

  @override
  State<OrderConfirmationDialog> createState() =>
      _OrderConfirmationDialogState();
}

class _OrderConfirmationDialogState extends State<OrderConfirmationDialog> {
  final groupcontroller = Get.put(GroupController());
  final cartcontroller = Get.put(OrderController());
  List<String> timeSlots = [
    '8:30',
    '9:30',
    '11:30',
    '12:30',
    '1:30',
  ];

  bool isMealTimeSelectionVisible = true; // Add this variable

  @override
  void initState() {
    super.initState();
    // checkTimeAndSetVisibility();
  }

  // void checkTimeAndSetVisibility() {
  //   DateTime currentDate = DateTime.now();
  //   int currentHour = currentDate.hour;

  //   if ((currentHour >= 16 && currentHour <= 24) ||
  //       (currentHour >= 1 && currentHour < 8)) {
  //     // After 4 pm but not after 8 am of the next day
  //     setState(() {
  //       isMealTimeSelectionVisible = true;
  //     });
  //   }
  // }

  int selectedIndex = -1;
  void showNoSelectionMessage() {
    Get.snackbar(
      'No Time Slot Selected',
      'Please select a time slot',
      backgroundColor: Colors.red, // Set your desired background color here
      colorText: Colors.white, // Set the text color
    );
  }

  @override
  Widget build(BuildContext context) {
    DateTime currentDate = DateTime.now();
    NepaliDateTime nepaliDateTime = NepaliDateTime.fromDateTime(currentDate);
    String formattedDate = DateFormat.yMd().add_jm().format(nepaliDateTime);

    int currentHour = currentDate.hour;

    String dateMessage;
    return Dialog(
      backgroundColor: Colors.transparent,
      alignment: Alignment.bottomCenter,
      insetPadding: EdgeInsets.zero,
      child: Container(
        height: isMealTimeSelectionVisible
            ? MediaQuery.of(context).size.height * 0.67
            : MediaQuery.of(context).size.height * 0.37,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 2,
                child: Obx(() {
                  if (groupcontroller.currentGroup.value == null) {
                    return LoadingScreen();
                  } else {
                    return Column(
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Group Code : ',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 101, 100, 100),
                                    fontSize: 22.0,
                                    fontWeight: FontWeight.bold)),
                            Text(groupcontroller.currentGroup.value!.groupCode,
                                style: TextStyle(
                                    color:
                                        const Color.fromARGB(255, 255, 90, 7),
                                    fontSize: 27.0,
                                    fontWeight: FontWeight.bold))
                          ],
                        ),
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
                flex: 2,
                child: Container(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20)),
                          height: 19.h,
                          width: 36.w,
                          child: CachedNetworkImage(
                            imageUrl: widget.image ?? '',
                            fit: BoxFit.cover,
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error_outline, size: 40),
                          ),
                        ),
                      ),
                      SizedBox(width: 16.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 8,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.pname,
                                  overflow: TextOverflow.clip,
                                  style: TextStyle(fontSize: 17),
                                ),
                                Text(
                                  "Quantity:1-/plate",
                                  style: TextStyle(fontSize: 17),
                                ),
                                Text(
                                  "Price: Rs." + widget.price,
                                  style: TextStyle(fontSize: 17),
                                ),
                                Text(
                                  "For: " + widget.date,
                                  style: TextStyle(fontSize: 17),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              isMealTimeSelectionVisible
                  ? Expanded(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              // child: Text(
                              // "Select Meal Time:- ${cartcontroller.mealTime.value}",
                              // style: TextStyle(fontSize: 20),
                              // ),
                            ),
                            Container(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GridView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 3,
                                          crossAxisSpacing: 8.0,
                                          mainAxisSpacing: 8.0,
                                          childAspectRatio: 3),
                                  itemCount: timeSlots.length,
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () {
                                        // setState(() {
                                        //   selectedIndex = index;
                                        //   cartcontroller.mealTime.value =
                                        //       timeSlots[selectedIndex];
                                        // });
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: AppColors.secondaryColor),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: selectedIndex == index
                                              ? Color.fromARGB(
                                                  255, 187, 188, 189)
                                              : const Color.fromARGB(
                                                  255, 247, 245, 245),
                                        ),
                                        child: Center(
                                          child: Text(
                                            timeSlots[index],
                                            style: TextStyle(
                                                fontSize: 18.0,
                                                color: Color.fromARGB(
                                                    255, 84, 82, 82)),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Container(
                      child: Text("Order Time is schedule from 4 pm to 8 am"),
                    ),
              isMealTimeSelectionVisible
                  ? Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15.0, vertical: 7),
                        child: true
                            ? Container(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Get.back();
                                      },
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.4,
                                        decoration: BoxDecoration(
                                          color: const Color.fromARGB(
                                              255, 238, 235, 235),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Center(
                                            child: Text(
                                          'Cancel',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        if (selectedIndex == -1) {
                                          showNoSelectionMessage();
                                        } else {
                                          widget.onConfirm();
                                        }
                                      },
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.4,
                                        decoration: BoxDecoration(
                                          color: AppColors.secondaryColor,
                                          borderRadius:
                                              BorderRadius.circular(10),
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
                                  ],
                                ),
                              )
                            : Container(),
                      ),
                    )
                  : SizedBox(
                      height: 1,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
