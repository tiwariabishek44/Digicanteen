import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:merocanteen/app/modules/user_module/profile/group/group_controller.dart';
import 'package:merocanteen/app/widget/loading_screen.dart';

class FriendList extends StatelessWidget {
  final groupcontroller = Get.put(GroupController());
  void showAlreadyInGroupDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Sorry"),
          content: Text("He is already a member of a group."),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Friend List'),
      ),
      body: Obx(() {
        if (groupcontroller.students.value!.isEmpty) {
          groupcontroller.fetchAllStudent();
          return LoadingScreen();
        } else {
          return ListView.builder(
            itemCount: groupcontroller.students.value!.length,
            itemBuilder: (context, index) {
              return ListTile(
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
                      child: CircleAvatar(
                        radius: 23,
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                          radius: 22,
                          child: Icon(
                            Icons.person,
                            color: Colors.white,
                          ),
                          backgroundColor:
                              const Color.fromARGB(255, 224, 218, 218),
                        ),
                      ),
                    ),
                    Obx(() {
                      if (groupcontroller
                          .students.value[index].groupid.isNotEmpty) {
                        return Positioned(
                          bottom: 0,
                          right: 0,
                          child: CircleAvatar(
                            radius: 7.5,
                            backgroundColor: Color.fromARGB(
                                255, 72, 2, 129), // Adjust color as needed
                            child: Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 9,
                            ),
                          ),
                        );
                      } else {
                        return Positioned(
                          bottom: 0,
                          right: 0,
                          child: CircleAvatar(
                            radius: 7,
                            backgroundColor:
                                Colors.transparent, // Adjust color as needed
                          ),
                        );
                      }
                    })
                  ],
                ),
                title: Text('${groupcontroller.students.value![index].name}'),
                onTap: () {
                  groupcontroller.students.value[index].groupid.isNotEmpty
                      ? showAlreadyInGroupDialog(context)
                      : groupcontroller.addFriends(
                          groupcontroller.students.value![index].userid);
                },
                trailing: groupcontroller.students.value![index].groupid == null
                    ? Icon(Icons.add)
                    : Text("."),
              );
            },
          );
        }
      }),
    );
  }
}
