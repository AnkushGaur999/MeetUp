import 'package:meet_up/core/network/data_state.dart';
import 'package:meet_up/data/models/user_chat.dart';
import 'package:meet_up/domain/repositories/chat_repository.dart';

class SendMessageToUserUseCase {
  final ChatRepository repository;

  SendMessageToUserUseCase({required this.repository});

  Future<DataState<bool>> call({required UserChat userChat}) async {
    return await repository.sendMessageToUser(userChat: userChat);
  }
}
