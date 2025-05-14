part of 'account_bloc.dart';

sealed class AccountEvents extends Equatable {}

final class GetMyProfileDetailsEvent extends AccountEvents {
  @override
  List<Object?> get props => [];
}

final class UpdateMyProfilePictureEvent extends AccountEvents {
  final File imagePath;

  UpdateMyProfilePictureEvent({required this.imagePath});

  @override
  List<Object?> get props => [imagePath];
}
