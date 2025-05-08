part of 'chat_bloc.dart';

sealed class ChatStates extends Equatable {}

final class ChatInitialState extends ChatStates {
  @override
  List<Object?> get props => [];
}

final class RecentChatsLoadingState extends ChatStates {
  @override
  List<Object?> get props => [];
}

final class RecentChatsLoadedState extends ChatStates {
  final List<RecentChat> recentMessages;

  RecentChatsLoadedState({required this.recentMessages});

  @override
  List<Object?> get props => [recentMessages];
}

final class RecentChatsFailedState extends ChatStates {
  final String message;

  RecentChatsFailedState({required this.message});

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
