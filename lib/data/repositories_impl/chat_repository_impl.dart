import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meet_up/core/network/data_state.dart';
import 'package:meet_up/data/models/user_chat.dart';
import 'package:meet_up/data/sources/chat_data_source.dart';
import 'package:meet_up/domain/repositories/chat_repository.dart';

class ChatRepositoryImpl extends ChatRepository {
  final ChatDataSource chatDataSource;

  ChatRepositoryImpl({required this.chatDataSource});

  @override
  Stream<QuerySnapshot<Map<String, dynamic>>> getUserAllMessages({
    required String token,
    required String userId,
  }) {
    return chatDataSource.getUserAllMessages(token: token, userId: userId);
  }

  @override
  Future<DataState<bool>> sendMessageToUser({required UserChat userChat}) async {
    return chatDataSource.sendMessageToUser(userChat: userChat);
  }
}
