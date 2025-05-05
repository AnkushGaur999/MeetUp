import 'package:meet_up/core/network/data_state.dart';
import 'package:meet_up/data/models/buddy.dart';
import 'package:meet_up/data/sources/buddy_data_source.dart';
import 'package:meet_up/domain/repositories/buddy_repository.dart';

class BuddyRepositoryImpl extends BuddyRepository {
  final BuddyDataSource buddyDataSource;

  BuddyRepositoryImpl({required this.buddyDataSource});

  @override
  Future<DataState<List<Buddy>>> getBuddies() {
    return buddyDataSource.getBuddies();
  }

  @override
  Future<DataState<bool>> addBuddy({required Buddy buddy}) async{
   return buddyDataSource.addBuddy(buddy: buddy);
  }

  @override
  Future<DataState<List<Buddy>>> getMyBuddies() async{
    return await buddyDataSource.getMyBuddies();
  }
}
