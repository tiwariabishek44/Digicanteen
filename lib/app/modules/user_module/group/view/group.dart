import 'dart:ffi';

import 'package:get_storage/get_storage.dart';
import 'package:merocanteen/app/config/colors.dart';
import 'package:merocanteen/app/modules/common/login/login_controller.dart';
import 'package:merocanteen/app/modules/user_module/friend_list/friend_list_view.dart';
import 'package:merocanteen/app/modules/user_module/group/group_controller.dart';
import 'package:flutter/material.dart';
import 'package:merocanteen/app/modules/user_module/group/no_group_data.dart';
import 'package:get/get.dart';
import 'package:merocanteen/app/widget/loading_screen.dart';

class GroupPage extends StatelessWidget {
  final logincontroller = Get.put(LoginController());
  final groupcontroller = Get.put(GroupController());
  final storage = GetStorage();

  void _showGroupNameDialog(BuildContext context, String name, String userid) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Remove  $name',
            style: TextStyle(fontSize: 17),
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
                groupcontroller.deleteFriendField(userid);
                groupcontroller.fetchAllStudent();
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
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Group"),
        elevation: 1,
      ),
      body: Obx(() {
        if (logincontroller
            .userDataResponse.value.response!.first.groupid.isEmpty) {
          return CommunityCreation();
        } else {
          return SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${groupcontroller.groupResponse.value.response!.first.groupName} || ${groupcontroller.groupResponse.value.response!.first.groupCode}",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w700),
                      ),
                      groupcontroller.groupResponse.value.response!.first
                                  .moderator ==
                              logincontroller
                                  .userDataResponse.value.response!.first.name
                          ? Padding(
                              padding: EdgeInsets.only(right: 20.0),
                              child: GestureDetector(
                                  onTap: () {
                                    GroupController().fetchAllStudent();
                                    Get.to(() => FriendList());
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
                    child: const Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        "All orders placed by group members are grouped together.",
                        maxLines: 2,
                        style: TextStyle(
                          color: Color.fromARGB(255, 161, 156, 156),
                          fontSize: 15.0,
                        ),
                      ),
                    ),
                  ),
                ),
                // Obx(() {
                //   if (groupcontroller.groupMembers.value == '') {
                //     return Container(
                //       color: AppColors.primaryColor,
                //     );
                //   } else {
                //     return ListView.builder(
                //       itemCount: groupcontroller.groupMembers.value.length,
                //       shrinkWrap: true,
                //       physics: ScrollPhysics(),
                //       itemBuilder: (BuildContext context, int index) {
                //         return ListTile(
                //           title: Text(
                //               '  ${groupcontroller.groupMembers.value[index].name}'),
                //           leading: Stack(
                //             children: [
                //               Container(
                //                 decoration: BoxDecoration(
                //                   shape: BoxShape.circle,
                //                   color: Colors.white,
                //                   boxShadow: [
                //                     BoxShadow(
                //                       color: Colors.grey.withOpacity(0.5),
                //                       spreadRadius: 2,
                //                       blurRadius: 5,
                //                       offset: Offset(0, 3),
                //                     ),
                //                   ],
                //                 ),
                //                 child: const CircleAvatar(
                //                   radius: 23,
                //                   backgroundColor: Colors.white,
                //                   child: CircleAvatar(
                //                     radius: 22,
                //                     backgroundColor:
                //                         Color.fromARGB(255, 224, 218, 218),
                //                     child: Icon(
                //                       Icons.person,
                //                       color: Colors.white,
                //                     ),
                //                   ),
                //                 ),
                //               ),
                //               Obx(() {
                //                 if (groupcontroller
                //                         .currentGroup.value!.moderator ==
                //                     groupcontroller
                //                         .groupMembers.value![index].name) {
                //                   return Positioned(
                //                     bottom: 0,
                //                     right: 0,
                //                     child: CircleAvatar(
                //                       radius: 7.5,
                //                       backgroundColor: Color.fromARGB(255, 72,
                //                           2, 129), // Adjust color as needed
                //                       child: Icon(
                //                         Icons.shield_outlined,
                //                         color: Colors.white,
                //                         size: 15,
                //                       ),
                //                     ),
                //                   );
                //                 } else {
                //                   return Positioned(
                //                     bottom: 0,
                //                     right: 0,
                //                     child: CircleAvatar(
                //                       radius: 7,
                //                       backgroundColor: Colors
                //                           .transparent, // Adjust color as needed
                //                     ),
                //                   );
                //                 }
                //               })
                //             ],
                //           ),
                //           onTap: () {
                //             groupcontroller.currentGroup.value!.moderator ==
                //                     logincontroller.user.value!.name
                //                 ? groupcontroller
                //                             .groupMembers.value[index].userid ==
                //                         logincontroller.user.value!.userid
                //                     ? null
                //                     : _showGroupNameDialog(
                //                         context,
                //                         "${groupcontroller.groupMembers.value![index].name}",
                //                         "${groupcontroller.groupMembers.value![index].userid}")
                //                 : null;

                //             // Action when the item is tapped
                //           },
                //         );
                //       },
                //     );
                //   }
                // })
              ],
            ),
          );
        }
      }),
    );
  }
}
