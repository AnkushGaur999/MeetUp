part of 'chat_bloc.dart';

sealed class ChatEvents extends Equatable {}

final class GetUserChatsEvent extends ChatEvents {
  final String token;
  final String userId;

  GetUserChatsEvent({required this.token, required this.userId});

  @override
  List<Object?> get props => [token, userId];
}

final class SendMessageToUserEvent extends ChatEvents {
  final UserChat userChat;

  SendMessageToUserEvent({required this.userChat});

  @override
  List<Object?> get props => [userChat];
}
