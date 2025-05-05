import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meet_up/core/local/local_storage_manager.dart';
import 'package:meet_up/core/network/data_state.dart';
import 'package:meet_up/data/models/user_chat.dart';

class ChatDataSource {
  final FirebaseFirestore fireStore;
  final LocalStorageManager storageManager;

  ChatDataSource({required this.fireStore, required this.storageManager});

  Stream<QuerySnapshot<Map<String, dynamic>>> getUserAllMessages({
    required String token,
    required String userId,
  }) {
    return fireStore
        .collection('chats/$token/$userId/')
        .orderBy('sent', descending: true)
        .snapshots();
  }

  Future<DataState<bool>> sendMessageToUser({
    required UserChat userChat,
  }) async {
    try {
      await fireStore
          .collection("chats")
          .doc(storageManager.token)
          .collection(userChat.toId!)
          .add(userChat.toJson());

      await fireStore
          .collection("chats")
          .doc(userChat.toId)
          .collection(storageManager.token)
          .add(userChat.toJson());

      return DataSuccess(data: true);
    } on SocketException catch (_) {
      return DataError(message: "Server Error!");
    }
  }
}
