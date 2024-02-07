import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ApiClient {
  Future<ApiResponse<T>> postFirebaseData<T>({
    required String collection,
    required Map<String, dynamic> requestBody,
    required T Function(dynamic json) responseType,
  }) async {
    try {
      log("Inside the postFirebaseData method"); // Log the message

      // Convert the request body to JSON
      String jsonBody = jsonEncode(requestBody);

      // Make the POST request to Firebase
      DocumentReference docRef = await FirebaseFirestore.instance
          .collection(collection)
          .add(jsonDecode(jsonBody));

      // If the request is successful, construct the response with the document ID
      final data = responseType != null
          ? responseType({'id': docRef.id, ...requestBody})
          : {'id': docRef.id, ...requestBody} as T;
      return ApiResponse.completed([data]);
    } catch (e, stackTrace) {
      log("Error occurred: $e\n$stackTrace",
          error: e); // Log the error along with the stack trace
      return ApiResponse.error("Failed to post data to Firebase");
    }
  }

//------------API TO GET THE DATA FROM THE FIREBASE------------
  Future<ApiResponse<T>> getFirebaseData<T>({
    required String collection,
    required T Function(Map<String, dynamic>) responseType,
    Map<String, dynamic>? filters,
  }) async {
    try {
      log("Inside the getFirebaseData method");

      Query collectionRef = FirebaseFirestore.instance.collection(collection);

      // Apply filters if provided
      if (filters != null && filters.isNotEmpty) {
        filters.forEach((field, value) {
          collectionRef = collectionRef.where(field, isEqualTo: value);
        });
      }

      final QuerySnapshot snapshot = await collectionRef.get();
      final List<Map<String, dynamic>> dataList = snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();

      final List<T> dataListTyped =
          dataList.map((data) => responseType(data)).toList();

      return ApiResponse.completed(dataListTyped);
    } catch (e, stackTrace) {
      log("Error occurred: $e\n$stackTrace", error: e);
      return ApiResponse.error("Failed to fetch data from Firebase");
    }
  }
}

class ApiResponse<T> {
  ApiStatus status;
  List<T>? response;
  String? message;

  ApiResponse.initial([this.message])
      : status = ApiStatus.INITIAL,
        response = null;

  ApiResponse.loading([this.message])
      : status = ApiStatus.LOADING,
        response = null;
  ApiResponse.completed(this.response)
      : status = ApiStatus.SUCCESS,
        message = null;
  ApiResponse.error([this.message])
      : status = ApiStatus.ERROR,
        response = null;

  @override
  String toString() {
    return "Status : $status \nData : $response \nMessage : $message";
  }
}

enum ApiStatus { INITIAL, LOADING, SUCCESS, ERROR }
