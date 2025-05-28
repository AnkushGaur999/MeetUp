import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meet_up/core/local/local_storage_manager.dart';
import 'package:meet_up/core/network/data_state.dart';
import 'package:meet_up/data/models/buddy.dart';

class BuddyDataSource {
  final FirebaseFirestore fireStore;
  final LocalStorageManager storageManager;

  BuddyDataSource({required this.fireStore, required this.storageManager});

  Future<DataState<List<Buddy>>> getBuddies() async {
    try {
      final response = await fireStore.collection("users").get();

      final List<Buddy> buddies = [];

      for (var buddy in response.docs) {
        final buddyItem = Buddy.fromJson(buddy.data());

        print("Buddy: ${buddyItem.token}");
        if (buddyItem.token == storageManager.token) continue;

        buddies.add(buddyItem);
      }

      return DataSuccess(data: buddies);
    } on SocketException catch (_) {
      return DataError(
        message: "Connection Error! Please check you network connection.",
      );
    } catch (e) {
      print("Exception: ${e.toString()}");
      return DataError(message: "Something Went Wrong! Please try again.");
    }
  }

  Future<DataState<bool>> addBuddy({required Buddy buddy}) async {
    try {
      final isExist =
          await fireStore
              .collection("buddies")
              .doc(storageManager.token)
              .collection("my_buddies")
              .where("phone", isEqualTo: buddy.phone)
              .where("email", isEqualTo: buddy.email)
              .get();

      if (isExist.docs.isNotEmpty) {
        return DataError(message: "User Already Exist.");
      }

      await fireStore
          .collection("buddies")
          .doc(storageManager.token)
          .collection("my_buddies")
          .add(buddy.toJson());

      return DataSuccess(data: true);
    } on SocketException catch (_) {
      return DataError(
        message: "Connection Error! Please check you network connection.",
      );
    } catch (e) {
      return DataError(message: "Something Went Wrong! Please try again.");
    }
  }

  Future<DataState<List<Buddy>>> getMyBuddies() async {
    try {
      final List<Buddy> buddies = [];

      final items =
          await fireStore
              .collection("buddies")
              .doc(storageManager.token)
              .collection("my_buddies")
              .get();

      for (final item in items.docs) {
        buddies.add(Buddy.fromJson(item.data()));
      }

      return DataSuccess(data: buddies);
    } on SocketException catch (_) {
      return DataError(
        message: "Connection Error! Please check you network connection.",
      );
    } catch (e) {
      return DataError(message: "Something Went Wrong! Please try again.");
    }
  }
}
