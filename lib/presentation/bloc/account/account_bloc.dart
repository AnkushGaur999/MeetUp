import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_up/core/network/data_state.dart';
import 'package:meet_up/data/models/my_profile.dart';
import 'package:meet_up/domain/use_cases/account_use_cases/get_my_profile_details_use_case.dart';
import 'package:meet_up/domain/use_cases/account_use_cases/update_profile_picture.dart';

part 'account_events.dart';

part 'account_states.dart';

class AccountBloc extends Bloc<AccountEvents, AccountStates> {
  final GetMyProfileDetailsUseCase getMyProfileDetailsUseCase;
  final UpdateProfilePictureUseCases updateProfilePictureUseCases;

  AccountBloc({
    required this.getMyProfileDetailsUseCase,
    required this.updateProfilePictureUseCases,
  }) : super(AccountStateInitial()) {
    on<GetMyProfileDetailsEvent>(_getMyProfileDetails);
    on<UpdateMyProfilePictureEvent>(_updateMyProfilePicture);
  }

  void _getMyProfileDetails(
    GetMyProfileDetailsEvent event,
    Emitter<AccountStates> emit,
  ) async {
    emit(GetMyProfileDetailsLoadingState());

    final response = await getMyProfileDetailsUseCase.call();

    if (response is DataSuccess) {
      emit(GetMyProfileDetailsLoadedState(myProfile: response.data!));
    } else {
      emit(GetMyProfileDetailsFailedState(message: response.message!));
    }
  }

  void _updateMyProfilePicture(
    UpdateMyProfilePictureEvent event,
    Emitter<AccountStates> emit,
  ) async {
    emit(UpdateMyProfilePictureLoadingState());

    final response = await updateProfilePictureUseCases.call(
      imagePath: event.imagePath,
    );

    if (response is DataSuccess) {
      emit(UpdateMyProfilePictureLoadedState(myProfile: response.data!));
    } else {
      emit(UpdateMyProfilePicturesFailedState(message: response.message!));
    }
  }
}
