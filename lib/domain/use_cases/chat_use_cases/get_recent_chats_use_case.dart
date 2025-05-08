import 'package:meet_up/core/network/data_state.dart';
import 'package:meet_up/data/models/recent_chat.dart';
import 'package:meet_up/domain/repositories/chat_repository.dart';

class GetRecentChatsUseCase {
  final ChatRepository repository;

  GetRecentChatsUseCase({required this.repository});

  Future<DataState<List<RecentChat>>> call() {
    return repository.getRecentChats();
  }
}
