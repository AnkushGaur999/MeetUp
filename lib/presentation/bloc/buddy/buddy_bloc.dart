import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_up/core/network/data_state.dart';
import 'package:meet_up/data/models/buddy.dart';
import 'package:meet_up/domain/use_cases/buddy_use_cases/addd_buddy_use_case.dart';
import 'package:meet_up/domain/use_cases/buddy_use_cases/get_all_buddies_use_cases.dart';
import 'package:meet_up/domain/use_cases/buddy_use_cases/get_my_buddies_use_cases.dart';

part 'buddy_events.dart';

part 'buddy_states.dart';

class BuddyBloc extends Bloc<BuddyEvents, BuddyStates> {
  final GetAllBuddiesUseCases getAllBuddiesUseCases;
  final AddBuddyUseCase addBuddyUseCase;
  final GetMyBuddiesUseCases getMyBuddiesUseCases;

  BuddyBloc({
    required this.getAllBuddiesUseCases,
    required this.addBuddyUseCase,
    required this.getMyBuddiesUseCases,
  }) : super(BuddyInitialState()) {
    on<GetAllBuddiesEvent>(_getAllBuddies);
    on<AddBuddyEvent>(_addBuddy);
    on<GetMyBuddiesEvent>(_getMyBuddies);
  }

  void _getAllBuddies(
    GetAllBuddiesEvent event,
    Emitter<BuddyStates> emit,
  ) async {
    emit(GetBuddiesLoadingState());

    final response = await getAllBuddiesUseCases.call();

    if (response is DataSuccess) {
      emit(GetBuddiesLoadedState(buddies: response.data!));
    } else {
      emit(GetBuddiesFailedState(message: response.message!));
    }
  }

  void _addBuddy(AddBuddyEvent event, Emitter<BuddyStates> emit) async {
    emit(AddBuddyLoadingState());

    final response = await addBuddyUseCase.call(buddy: event.buddy);

    if (response is DataSuccess) {
      emit(AddBuddyLoadedState(message: "Buddy Added Successfully."));
    } else {
      emit(AddBuddyFailedState(message: response.message!));
    }
  }

  void _getMyBuddies(GetMyBuddiesEvent event, Emitter<BuddyStates> emit) async {
    emit(MyBuddiesLoadingState());

    final response = await getMyBuddiesUseCases.call();

    if (response is DataSuccess) {
      emit(MyBuddiesLoadedState(buddies: response.data!));
    } else {
      emit(MyBuddiesFailedState(message: response.message!));
    }
  }
}
