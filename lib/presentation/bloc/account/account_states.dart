part of 'account_bloc.dart';

sealed class AccountStates extends Equatable {}

final class AccountStateInitial extends AccountStates {
  @override
  List<Object?> get props => [];
}

final class GetMyProfileDetailsLoadingState extends AccountStates {
  @override
  List<Object?> get props => [];
}

final class GetMyProfileDetailsLoadedState extends AccountStates {
  final MyProfile myProfile;

  GetMyProfileDetailsLoadedState({required this.myProfile});

  @override
  List<Object?> get props => [myProfile];
}

final class GetMyProfileDetailsFailedState extends AccountStates {
  final String message;

  GetMyProfileDetailsFailedState({required this.message});

  @override
  List<Object?> get props => [message];
}

final class UpdateMyProfilePictureLoadingState extends AccountStates {
  @override
  List<Object?> get props => [];
}

final class UpdateMyProfilePictureLoadedState extends AccountStates {
  final MyProfile myProfile;

  UpdateMyProfilePictureLoadedState({required this.myProfile});

  @override
  List<Object?> get props => [myProfile];
}

final class UpdateMyProfilePicturesFailedState extends AccountStates {
  final String message;

  UpdateMyProfilePicturesFailedState({required this.message});

  @override
  List<Object?> get props => [message];
}
