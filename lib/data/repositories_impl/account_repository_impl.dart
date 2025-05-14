import 'dart:io';
import 'package:meet_up/core/network/data_state.dart';
import 'package:meet_up/data/models/my_profile.dart';
import 'package:meet_up/data/sources/account_data_source.dart';
import 'package:meet_up/domain/repositories/account_repository.dart';

class AccountRepositoryImpl extends AccountRepository {
  final AccountDataSource accountDataSource;

  AccountRepositoryImpl({required this.accountDataSource});

  @override
  Future<DataState<MyProfile>> getMyProfileDetails() async {
    return await accountDataSource.getMyProfile();
  }

  @override
  Future<DataState<MyProfile>> updateProfilePicture({
    required File imagePath,
  }) async {
    return await accountDataSource.updateProfileImage(imagePath: imagePath);
  }
}
