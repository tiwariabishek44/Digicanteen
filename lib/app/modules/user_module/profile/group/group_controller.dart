import 'dart:developer';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_storage/get_storage.dart';
import 'package:merocanteen/app/models/group_models.dart';
import 'package:merocanteen/app/models/users_model.dart';
import 'package:merocanteen/app/modules/common/login/login_controller.dart';
import 'package:merocanteen/app/modules/user_module/profile/group/group.dart';
import 'package:merocanteen/app/widget/custom_snackbar.dart';

class GroupController extends GetxController {
  final logincontroller = Get.put(LoginController());
  final storage = GetStorage();
  final groupnameController = TextEditingController();

  FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final RxList<UserDataResponse> groupMembers = <UserDataResponse>[].obs;

  final RxList<UserDataResponse> students = <UserDataResponse>[].obs;
  Rx<Group?> currentGroup = Rx<Group?>(null);

  var isloading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchGroupByGroupId();
    fetchAllStudent();
  }

//--------------create a new grou-----------//
  Future<void> createNewGroup() async {
    isloading(true);

    try {
      String pinString;

      // Loop until a unique PIN is generated
      while (true) {
        // Generate a random 4-digit PIN
        Random random = Random();
        int pin = random.nextInt(10000);
        pinString = pin.toString().padLeft(4, '0');

        // Check if the PIN already exists in the collection
        DocumentSnapshot pinSnapshot =
            await _firestore.collection('AssignedPins').doc(pinString).get();

        if (!pinSnapshot.exists) {
          // If the PIN doesn't exist, break out of the loop
          break;
        }
      }

      // Upload the unique PIN to the 'AssignedPins' collection
      await _firestore.collection('AssignedPins').doc(pinString).set({
        'assigned': true,
      });

      String userId = _auth.currentUser!.uid;
      Group newGroup = Group(
        groupId: userId,
        groupCode: pinString,
        groupName: groupnameController.text.trim(),
        moderator: logincontroller.user.value!.name,
      );

      // Add the new group to the 'groups' collection
      await _firestore.collection('groups').add(newGroup.toJson());

      // Update the user's 'groupid' field in the 'students' collection
      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      final studentDocRef = firestore.collection('students').doc(userId);
      await studentDocRef.update({'groupid': userId});

      logincontroller.fetchUserData();
      fetchGroupByGroupId();
      fetchGroupMember();
      Get.back();
      isloading(false);
      print('Pin $pinString uploaded successfully!');
    } catch (e) {
      isloading(false);
      print('Error: $e');
    }
  }

  Future<void> fetchGroupByGroupId() async {
    try {
      final QuerySnapshot<Map<String, dynamic>> groupsSnapshot =
          await _firestore
              .collection('groups')
              .where('groupId', isEqualTo: storage.read("groupid"))
              .get();
      currentGroup.value = null;
      debugPrint(" the data is loaidng");

      if (groupsSnapshot.docs.isNotEmpty) {
        final groupData = groupsSnapshot.docs.first.data();
        currentGroup.value = Group.fromJson(groupData);
      } else {
        isloading(false);
        print('No group found for this group ID.');
      }
    } catch (e) {
      isloading(false);
      print("Error fetching group: $e");
    }
  }

//------------fetch the group members ----------//
  Future<void> fetchGroupMember() async {
    try {
      isloading(true);
      if (logincontroller.user != null) {
        final QuerySnapshot<Map<String, dynamic>> studentsSnapshot =
            await _firestore
                .collection('students')
                .where('groupid',
                    isEqualTo: logincontroller.user.value?.groupid)
                .get();

        if (studentsSnapshot.docs.isNotEmpty) {
          groupMembers.clear();

          final List<UserDataResponse> members =
              studentsSnapshot.docs.map((doc) {
            return UserDataResponse.fromJson(doc.data());
          }).toList();

          groupMembers.assignAll(members);
          isloading(false);
        } else {
          isloading(false);
          print('No group members found for this group.');
        }
      }
      isloading(false);
    } catch (e) {
      isloading(false);
      print("Error fetching group members: $e");
      // Handle error - show a snackbar, display an error message, etc.
    }
  }

  ///-----------to fetchall student of class----------//

  Future<void> fetchAllStudent() async {
    try {
      if (logincontroller.user != null) {
        final QuerySnapshot<Map<String, dynamic>> studentsSnapshot =
            await _firestore
                .collection('students')
                .where('classes',
                    isEqualTo: logincontroller.user.value?.classes)
                .get();

        students.clear();

        final List<UserDataResponse> members = studentsSnapshot.docs.map((doc) {
          return UserDataResponse.fromJson(doc.data());
        }).toList();

        students.assignAll(members);
      }

      isloading(false);
    } catch (e) {
      print("Error fetching group members: $e");
      // Handle error - show a snackbar, display an error message, etc.
    }
  }

//-----------add friends in group----------//
  Future<void> addFriends(String studentid) async {
    try {
      isloading(true);
      String userId = _auth.currentUser!.uid;
      final FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Get the document reference for the current user
      final DocumentSnapshot<Map<String, dynamic>> studentDocSnapshot =
          await firestore.collection('students').doc(studentid).get();
      await studentDocSnapshot.reference.update({'groupid': userId});
      fetchAllStudent();
      fetchGroupMember();

      isloading(false);
    } catch (e) {
      // Document for the user doesn't exist, handle this case
      CustomSnackbar(
        backgroundColor: const Color.fromARGB(255, 193, 159, 57),
        title: 'Catche error',
        message: 'Cannot addd to grou',
        duration: Duration(seconds: 5),
        textColor: Colors.black87,
        snackPosition: SnackPosition.BOTTOM,
      ).showSnackbar();
      print('Error adding friends: $e');
      // Add further error handling logic if needed
    }
  }

  Future<void> deleteFriendField(String userid) async {
    try {
      isloading(true);
      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      final studentDocRef = firestore.collection('students').doc(userid);
      // Update the document to delete a specific field (e.g., 'groupid')
      await studentDocRef.update({'groupid': ''});

      students.clear();
      fetchGroupMember();

      isloading(false);
      // Add logic after successful deletion if needed
    } catch (e) {
      isloading(false);
      // Handle any errors here
    }
  }
}
