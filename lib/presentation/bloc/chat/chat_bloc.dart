import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_up/core/network/data_state.dart';
import 'package:meet_up/data/models/recent_chat.dart';
import 'package:meet_up/data/models/user_chat.dart';
import 'package:meet_up/domain/use_cases/chat_use_cases/get_recent_chats_use_case.dart';
import 'package:meet_up/domain/use_cases/chat_use_cases/send_message_to_user_use_case.dart';

part 'chat_state.dart';

part 'chat_events.dart';

class ChatBloc extends Bloc<ChatEvents, ChatStates> {
  final GetRecentChatsUseCase getRecentChatsUseCase;
  final SendMessageToUserUseCase sendMessageToUserUseCase;

  ChatBloc({
    required this.getRecentChatsUseCase,
    required this.sendMessageToUserUseCase,
  }) : super(ChatInitialState()) {
    on<GetRecentChatsEvent>(_getRecentChats);
    on<SendMessageToUserEvent>(_sendMessageToUser);
  }

  void _getRecentChats(
    GetRecentChatsEvent event,
    Emitter<ChatStates> emit,
  ) async {
    try {
      emit(RecentChatsLoadingState());

      final result = await getRecentChatsUseCase.call();

      if (result is DataSuccess) {
        emit(RecentChatsLoadedState(recentMessages: result.data!));
      } else {
        emit(RecentChatsFailedState(message: result.message!));
      }
    } catch (e) {
      emit(
        RecentChatsFailedState(
          message: "Server Error! Please try after some time",
        ),
      );
    }
  }

  void _sendMessageToUser(
    SendMessageToUserEvent event,
    Emitter<ChatStates> emit,
  ) async {
    emit(SendMessageToUserLoadingState());

    final response = await sendMessageToUserUseCase.call(
      userChat: event.userChat,
      userFcmToken: event.userFcmToken,
    );

    if (response is DataSuccess) {
      emit(SendMessageToUserLoadedState(isSend: true));
    } else {
      emit(SendMessageToUserFailedState(message: response.message!));
    }
  }
}
