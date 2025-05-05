import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meet_up/domain/repositories/chat_repository.dart';

class GetUserMessagesUseCase {
  final ChatRepository repository;

  GetUserMessagesUseCase({required this.repository});

  Stream<QuerySnapshot<Map<String, dynamic>>> call({
    required String token,
    required String userId,
  }) {
    return repository.getUserAllMessages(token: token, userId: userId);
  }
}
