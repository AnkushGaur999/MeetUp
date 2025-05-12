import 'package:meet_up/core/network/data_state.dart';
import 'package:meet_up/data/models/recent_chat.dart';
import 'package:meet_up/data/models/user_chat.dart';

abstract class ChatRepository {
  Future<DataState<List<RecentChat>>> getRecentChats();

  Future<DataState<bool>> sendMessageToUser({required UserChat userChat,required String userFcmToken,});
}
