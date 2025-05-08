import 'package:meet_up/core/network/data_state.dart';
import 'package:meet_up/data/models/buddy.dart';
import 'package:meet_up/domain/repositories/buddy_repository.dart';

class GetMyBuddiesUseCases {
  final BuddyRepository repository;

  GetMyBuddiesUseCases({required this.repository});

  Future<DataState<List<Buddy>>> call() async {
    return await repository.getMyBuddies();
  }
}
