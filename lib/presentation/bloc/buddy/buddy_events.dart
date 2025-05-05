part of 'buddy_bloc.dart';

sealed class BuddyEvents extends Equatable {}

final class GetAllBuddiesEvent extends BuddyEvents {
  @override
  List<Object?> get props => [];
}

final class AddBuddyEvent extends BuddyEvents {
  final Buddy buddy;

  AddBuddyEvent({required this.buddy});

  @override
  List<Object?> get props => [buddy];
}

final class GetMyBuddiesEvent extends BuddyEvents {
  @override
  List<Object?> get props => [];
}
