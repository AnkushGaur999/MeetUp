import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meet_up/core/local/local_storage_manager.dart';
import 'package:meet_up/core/network/data_state.dart';
import 'package:meet_up/core/services/notification_service.dart';
import 'package:meet_up/data/models/recent_chat.dart';
import 'package:meet_up/data/models/user_chat.dart';

class ChatDataSource {
  final FirebaseFirestore fireStore;
  final LocalStorageManager storageManager;

  ChatDataSource({required this.fireStore, required this.storageManager});

  Future<DataState<List<RecentChat>>> getRecentChats() async {
    try {
      final List<RecentChat> recentChats = [];

      final response =
          await fireStore
              .collection('chats/${storageManager.token}/recent_chats/')
              .orderBy('sent', descending: true)
              .get();

      for (final item in response.docs) {
        recentChats.add(RecentChat.fromJson(item.data()));
      }

      return DataSuccess(data: recentChats);
    } on SocketException catch (_) {
      return DataError(message: "Please Check Your Internet Connection!");
    } catch (e) {
      return DataError(message: "Server Error! try after some time");
    }
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

      final fromUser =
          await fireStore
              .collection("users")
              .where("token", isEqualTo: storageManager.token)
              .get();

      /// Set recent message table data of sender end.

      final Map<String, dynamic> userLastMsg = {
        "id": storageManager.token,
        "fromId": storageManager.token,
        "lastMessage": userChat.message,
        "read": false,
        "sent": userChat.sent,
        "toId": userChat.toId,
        "type": userChat.type,
        "imageUrl": fromUser.docs.first.data()["imageUrl"] as String?,
        "name": fromUser.docs.first.data()["name"] as String?,
      };

      await fireStore
          .collection('chats/${userChat.toId}/recent_chats/')
          .doc(storageManager.token)
          .set(userLastMsg);

      /// Set recent message table data of receiver end.

      final Map<String, dynamic> selfLastMsg = {
        "id": userChat.toId,
        "fromId": storageManager.token,
        "lastMessage": userChat.message,
        "read": false,
        "sent": userChat.sent,
        "toId": userChat.toId,
        "type": userChat.type,
        "imageUrl": userChat.imageUrl,
        "name": userChat.name,
      };

      await fireStore
          .collection('chats/${storageManager.token}/recent_chats/')
          .doc(userChat.toId)
          .set(selfLastMsg);

      final toUser =
          await fireStore
              .collection("users")
              .where("token", isEqualTo: userChat.toId)
              .get();

      final userToken = toUser.docs.first.data()["fcmToken"] as String?;

      if (userToken != null && userToken.isNotEmpty) {
        NotificationService.sendPushNotification(
          userToken,
          userChat.message!,
          userChat.name!,
        );
      }
      return DataSuccess(data: true);
    } on SocketException catch (_) {
      return DataError(message: "Please Check Your Internet Connection!");
    } catch (e) {
      return DataError(message: "Server Error! try after some time");
    }
  }
}
