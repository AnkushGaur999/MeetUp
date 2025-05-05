part of 'buddy_bloc.dart';

sealed class BuddyStates extends Equatable {}

final class BuddyInitialState extends BuddyStates {
  @override
  List<Object?> get props => [];
}

final class GetBuddiesLoadingState extends BuddyStates {
  @override
  List<Object?> get props => [];
}

final class GetBuddiesLoadedState extends BuddyStates {
  final List<Buddy> buddies;

  GetBuddiesLoadedState({required this.buddies});

  @override
  List<Object?> get props => [buddies];
}

final class GetBuddiesFailedState extends BuddyStates {
  final String message;

  GetBuddiesFailedState({required this.message});

  @override
  List<Object?> get props => [message];
}

final class MyBuddiesLoadingState extends BuddyStates {
  @override
  List<Object?> get props => [];
}

final class MyBuddiesLoadedState extends BuddyStates {
  final List<Buddy> buddies;

  MyBuddiesLoadedState({required this.buddies});

  @override
  List<Object?> get props => [buddies];
}

final class MyBuddiesFailedState extends BuddyStates {
  final String message;

  MyBuddiesFailedState({required this.message});

  @override
  List<Object?> get props => [message];
}

final class AddBuddyLoadingState extends BuddyStates {
  @override
  List<Object?> get props => [];
}

final class AddBuddyLoadedState extends BuddyStates {
  final String message;

  AddBuddyLoadedState({required this.message});

  @override
  List<Object?> get props => [message];
}

final class AddBuddyFailedState extends BuddyStates {
  final String message;

  AddBuddyFailedState({required this.message});

  @override
  List<Object?> get props => [message];
}
