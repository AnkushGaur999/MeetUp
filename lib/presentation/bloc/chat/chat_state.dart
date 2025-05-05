part of 'chat_bloc.dart';

sealed class ChatStates extends Equatable {}

final class ChatInitialState extends ChatStates {
  @override
  List<Object?> get props => [];
}

final class UserChatsLoadingState extends ChatStates {
  @override
  List<Object?> get props => [];
}

final class UserChatsLoadedState extends ChatStates {
  final Stream<QuerySnapshot<Map<String, dynamic>>> messages;

  UserChatsLoadedState({required this.messages});

  @override
  List<Object?> get props => [messages];
}

final class UserChatsFailedState extends ChatStates {
  final String message;

  UserChatsFailedState({required this.message});

  @override
  List<Object?> get props => [message];
}

final class SendMessageToUserLoadingState extends ChatStates {
  @override
  List<Object?> get props => [];
}

final class SendMessageToUserLoadedState extends ChatStates {
  final bool isSend;

  SendMessageToUserLoadedState({required this.isSend});

  @override
  List<Object?> get props => [isSend];
}

final class SendMessageToUserFailedState extends ChatStates {
  final String message;

  SendMessageToUserFailedState({required this.message});

  @override
  List<Object?> get props => [message];
}
