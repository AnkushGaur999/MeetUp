import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_up/core/network/data_state.dart';
import 'package:meet_up/data/models/user_chat.dart';
import 'package:meet_up/domain/use_cases/chat_use_cases/get_user_messages_use_case.dart';
import 'package:meet_up/domain/use_cases/chat_use_cases/send_message_to_user_use_case.dart';

part 'chat_state.dart';

part 'chat_events.dart';

class ChatBloc extends Bloc<ChatEvents, ChatStates> {
  final GetUserMessagesUseCase getUserMessagesUseCase;
  final SendMessageToUserUseCase sendMessageToUserUseCase;

  ChatBloc({
    required this.getUserMessagesUseCase,
    required this.sendMessageToUserUseCase,
  }) : super(ChatInitialState()) {
    on<GetUserChatsEvent>(_getUserChats);
    on<SendMessageToUserEvent>(_sendMessageToUser);
  }

  void _getUserChats(GetUserChatsEvent event, Emitter<ChatStates> emit) {
    try {
      emit(UserChatsLoadingState());

      final stream = getUserMessagesUseCase.call(
        token: event.token,
        userId: event.userId,
      );

      emit(UserChatsLoadedState(messages: stream));
    } catch (e) {
      emit(
        UserChatsFailedState(
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
    );

    if (response is DataSuccess) {
      emit(SendMessageToUserLoadedState(isSend: true));
    } else {
      emit(SendMessageToUserFailedState(message: response.message!));
    }
  }
}
