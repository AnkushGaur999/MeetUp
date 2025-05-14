
import 'dart:io';

import 'package:meet_up/core/network/data_state.dart';
import 'package:meet_up/data/models/my_profile.dart';

abstract class AccountRepository{

  Future<DataState<MyProfile>> getMyProfileDetails();

  Future<DataState<MyProfile>> updateProfilePicture({required File imagePath});

}