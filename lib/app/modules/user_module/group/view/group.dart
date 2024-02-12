import 'dart:ffi';

import 'package:get_storage/get_storage.dart';
import 'package:merocanteen/app/config/colors.dart';
import 'package:merocanteen/app/config/style.dart';
import 'package:merocanteen/app/modules/common/login/login_controller.dart';
import 'package:merocanteen/app/modules/user_module/friend_list/view/friend_list_view.dart';
import 'package:merocanteen/app/modules/user_module/group/group_controller.dart';
import 'package:flutter/material.dart';
import 'package:merocanteen/app/modules/user_module/group/view/group_Creation_view.dart';
import 'package:get/get.dart';
import 'package:merocanteen/app/widget/custom_app_bar.dart';
import 'package:merocanteen/app/widget/custom_loging_widget.dart';
import 'package:merocanteen/app/widget/loading_screen.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class GroupPage extends StatelessWidget {
  final logincontroller = Get.put(LoginController());
  final groupcontroller = Get.put(GroupController());
  final storage = GetStorage();

  void _showGroupNameDialog(BuildContext context, String name, String userid) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          elevation: 0,
          backgroundColor: AppColors.backgroundColor,
          title: Text(
            'Remove  $name',
            style: AppStyles.listTileTitle,
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Close the dialog

                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            GestureDetector(
              onTap: () {
                groupcontroller.deleteMember(context, userid);
                Navigator.of(context).pop();
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                padding: EdgeInsets.all(12.0),
                child: const Text(
                  "Remove",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: CustomAppBar(title: "Group"),
      body: Obx(() {
        if (logincontroller.userDataResponse.value.response!.first.groupid ==
            '') {
          return GroupCreation();
        } else {
          return SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 3.5.w, horizontal: 3.5.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${groupcontroller.groupResponse.value.response!.first.groupName} || ${groupcontroller.groupResponse.value.response!.first.groupCode}",
                        style: AppStyles.topicsHeading,
                      ),
                      groupcontroller.groupResponse.value.response!.first
                                  .moderator ==
                              logincontroller
                                  .userDataResponse.value.response!.first.name
                          ? Padding(
                              padding: EdgeInsets.only(right: 20.0),
                              child: GestureDetector(
                                  onTap: () {
                                    Get.to(() => FriendList(
                                          groupId: groupcontroller.groupResponse
                                              .value.response!.first.groupId,
                                        ));
                                  },
                                  child: Icon(Icons.add)),
                            )
                          : Container()
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 58.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: const Color.fromARGB(255, 161, 156, 156),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Text(
                        "All orders placed by group members are grouped together.",
                        maxLines: 2,
                        style: AppStyles.listTileTitle,
                      ),
                    ),
                  ),
                ),
                Obx(() {
                  if (groupcontroller.isloading.value) {
                    return LoadingWidget();
                  } else {
                    return ListView.builder(
                      itemCount: groupcontroller
                          .groupMemberResponse.value.response!.length,
                      shrinkWrap: true,
                      physics: ScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          title: Text(
                            '  ${groupcontroller.groupMemberResponse.value.response![index].name}',
                            style: AppStyles.listTilesubTitle,
                          ),
                          leading: Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 2,
                                      blurRadius: 5,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: const CircleAvatar(
                                  radius: 23,
                                  backgroundColor: Colors.white,
                                  child: CircleAvatar(
                                    radius: 22,
                                    backgroundColor:
                                        Color.fromARGB(255, 224, 218, 218),
                                    child: Icon(
                                      Icons.person,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              Obx(() {
                                if (groupcontroller.groupResponse.value
                                        .response!.first.moderator ==
                                    groupcontroller.groupMemberResponse.value
                                        .response![index].name) {
                                  return Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: CircleAvatar(
                                      radius: 7.5,
                                      backgroundColor: Color.fromARGB(255, 72,
                                          2, 129), // Adjust color as needed
                                      child: Icon(
                                        Icons.shield_outlined,
                                        color: Colors.white,
                                        size: 15,
                                      ),
                                    ),
                                  );
                                } else {
                                  return Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: CircleAvatar(
                                      radius: 7,
                                      backgroundColor: Colors
                                          .transparent, // Adjust color as needed
                                    ),
                                  );
                                }
                              })
                            ],
                          ),
                          onTap: () {
                            groupcontroller.groupResponse.value.response!.first
                                        .moderator ==
                                    logincontroller.userDataResponse.value
                                        .response!.first.name
                                ? groupcontroller.groupResponse.value.response!
                                            .first.moderator ==
                                        groupcontroller.groupMemberResponse
                                            .value.response![index].name
                                    ? null
                                    : _showGroupNameDialog(
                                        context,
                                        "${groupcontroller.groupMemberResponse.value.response![index].name}",
                                        "${groupcontroller.groupMemberResponse.value.response![index].userid}")
                                : null;

                            // Action when the item is tapped
                          },
                        );
                      },
                    );
                  }
                })
              ],
            ),
          );
        }
      }),
    );
  }
}
