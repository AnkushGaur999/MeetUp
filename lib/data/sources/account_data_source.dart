import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:meet_up/core/local/local_storage_manager.dart';
import 'package:meet_up/core/network/data_state.dart';
import 'package:meet_up/data/models/my_profile.dart';

class AccountDataSource {
  final FirebaseFirestore firebaseFirestore;
  final FirebaseStorage firebaseStorage;
  final LocalStorageManager storageManager;

  AccountDataSource({
    required this.firebaseFirestore,
    required this.firebaseStorage,
    required this.storageManager,
  });

  Future<DataState<MyProfile>> getMyProfile() async {
    try {
      final response =
          await firebaseFirestore
              .collection("users")
              .where("token", isEqualTo: storageManager.token)
              .get();

      if (response.docs.isEmpty) {
        return DataError(message: "No user found!");
      }

      return DataSuccess(data: MyProfile.fromJson(response.docs.first.data()));
    } on SocketException catch (_) {
      return DataError(message: "Please check your internet connection");
    } catch (e) {
      return DataError(message: "Server Error! Please try again");
    }
  }

  Future<DataState<MyProfile>> updateProfileImage({
    required File imagePath,
  }) async {
    try {
      final ext = imagePath.path.split('.').last;

      final ref = firebaseStorage.ref().child(
        "image/profile_pictures/${storageManager.token}/profileImage.$ext",
      );

      //uploading image
      await ref.putFile(imagePath, SettableMetadata(contentType: 'image/$ext'));

      //updating image in fireStore database
      final String imageUrl = await ref.getDownloadURL();

      final users =
          await firebaseFirestore
              .collection("users")
              .where("token", isEqualTo: storageManager.token)
              .get();

      await firebaseFirestore
          .collection("users")
          .doc(users.docs.first.id)
          .update(<String, dynamic>{"imageUrl": imageUrl});

      return DataSuccess(data: MyProfile.fromJson(users.docs.first.data()));
    } on SocketException catch (_) {
      return DataError(message: "Please check your internet connection");
    } catch (e) {
      return DataError(message: "Server Error! Please try again");
    }
  }
}
