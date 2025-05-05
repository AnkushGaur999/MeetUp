import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meet_up/core/network/data_state.dart';
import 'package:meet_up/data/models/user_chat.dart';

abstract class ChatRepository {
  Stream<QuerySnapshot<Map<String, dynamic>>> getUserAllMessages({
    required String token,
    required String userId,
  });

  Future<DataState<bool>> sendMessageToUser({required UserChat userChat});
}
