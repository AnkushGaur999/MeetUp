import 'package:meet_up/core/network/data_state.dart';
import 'package:meet_up/data/models/buddy.dart';
import 'package:meet_up/domain/repositories/buddy_repository.dart';

class AddBuddyUseCase {
  final BuddyRepository repository;

  AddBuddyUseCase({required this.repository});

  Future<DataState<bool>> call({required Buddy buddy}) async {
    return await repository.addBuddy(buddy: buddy);
  }
}
