import 'package:meet_up/core/network/data_state.dart';
import 'package:meet_up/data/models/recent_chat.dart';
import 'package:meet_up/data/models/user_chat.dart';
import 'package:meet_up/data/sources/chat_data_source.dart';
import 'package:meet_up/domain/repositories/chat_repository.dart';

class ChatRepositoryImpl extends ChatRepository {
  final ChatDataSource chatDataSource;

  ChatRepositoryImpl({required this.chatDataSource});

  @override
  Future<DataState<List<RecentChat>>> getRecentChats() {
    return chatDataSource.getRecentChats();
  }

  @override
  Future<DataState<bool>> sendMessageToUser({
    required UserChat userChat,
  }) async {
    return chatDataSource.sendMessageToUser(userChat: userChat);
  }
}
