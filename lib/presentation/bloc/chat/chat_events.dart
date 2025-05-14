part of 'chat_bloc.dart';

sealed class ChatEvents extends Equatable {}

final class GetRecentChatsEvent extends ChatEvents {
  GetRecentChatsEvent();

  @override
  List<Object?> get props => [];
}

final class SendMessageToUserEvent extends ChatEvents {
  final UserChat userChat;

  SendMessageToUserEvent({required this.userChat});

  @override
  List<Object?> get props => [userChat];
}
