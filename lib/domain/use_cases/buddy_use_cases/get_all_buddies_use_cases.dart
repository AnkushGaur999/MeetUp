import 'package:meet_up/core/network/data_state.dart';
import 'package:meet_up/data/models/buddy.dart';
import 'package:meet_up/domain/repositories/buddy_repository.dart';

class GetAllBuddiesUseCases {
  final BuddyRepository repository;

  GetAllBuddiesUseCases({required this.repository});

  Future<DataState<List<Buddy>>> call() async {
    return repository.getBuddies();
  }
}
