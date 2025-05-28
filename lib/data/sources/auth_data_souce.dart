import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:meet_up/core/network/data_state.dart';
import 'package:meet_up/data/models/login_response.dart';
import 'package:meet_up/data/models/sign_up_response.dart';

class AuthDataSource {
  final FirebaseFirestore fireStore;

  AuthDataSource({required this.fireStore});

  Future<DataState<LoginResponse>> login({
    required String phone,
    required String password,
    required String deviceId,
  }) async {
    try {
      final response =
          await fireStore
              .collection("users")
              .where('phone', isEqualTo: phone)
              .where("password", isEqualTo: password)
              .get();

      if (response.docs.isNotEmpty) {
        final String? token = await FirebaseMessaging.instance.getToken();

        await fireStore.collection("users").doc(response.docs.first.id).update({
          "fcmToken": token,
          "deviceId": deviceId,
        });

        final result = {
          "success": true,
          "message": "Login Successfully",
          "data": response.docs.first.data(),
        };

        return DataSuccess(data: LoginResponse.fromJson(result));
      } else {
        return DataError(message: "Sorry! No user found.");
      }
    } on SocketException catch (_) {
      return DataError(
        message: "Connection Error! Please check you network connection.",
      );
    } on FirebaseException catch (e) {
      return DataError(message: e.message!);
    } catch (e) {
      return DataError(message: "Something Went Wrong! Please try again.");
    }
  }

  Future<DataState<SignUpResponse>> signUp({
    required String name,
    required String email,
    required int age,
    required String phone,
    required String password,
    required String token,
    required String fcmToken,
    required String deviceId,
  }) async {
    try {
      final data = {
        "name": name,
        "email": email,
        "age": age,
        "phone": phone,
        "password": password,
        "token": token,
        "about": "Hey, I am using MeetUp",
        "fcmToken": fcmToken,
        "deviceId": deviceId,
        "imageUrl": "https://cdn-icons-png.flaticon.com/512/219/219970.png"
      };

      final isUserExist =
          await fireStore
              .collection("users")
              .where('phone', isEqualTo: phone)
              .where("password", isEqualTo: password)
              .get();

      if (isUserExist.docs.isNotEmpty) {
        return DataError(
          message:
              "Email or Number Already registered! Please login with new Email or Number",
        );
      }

      await fireStore.collection("users").add(data);

      final response =
          await fireStore
              .collection("users")
              .where('phone', isEqualTo: phone)
              .where("password", isEqualTo: password)
              .get();

      if (response.docs.isNotEmpty) {
        await fireStore.collection("users").doc(response.docs.first.id).update({
          "fcmToken": fcmToken,
          "deviceId": deviceId,
        });

        final result = {
          "success": true,
          "message": "Sign Up Successfully",
          "data": response.docs.first.data(),
        };

        return DataSuccess(data: SignUpResponse.fromJson(result));
      } else {
        return DataSuccess(
          data: SignUpResponse(
            success: false,
            message: "Server Error! Please try after some time.",
          ),
        );
      }
    } on SocketException catch (_) {
      return DataError(
        message: "Connection Error! Please check you network connection.",
      );
    } catch (e) {
      return DataError(message: "Something Went Wrong! Please try again.");
    }
  }
}
