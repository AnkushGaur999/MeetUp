
import 'package:meet_up/core/network/data_state.dart';
import 'package:meet_up/data/models/buddy.dart';

abstract class BuddyRepository{

  Future<DataState<List<Buddy>>> getBuddies();

  Future<DataState<bool>> addBuddy({required Buddy buddy});

  Future<DataState<List<Buddy>>> getMyBuddies();

}