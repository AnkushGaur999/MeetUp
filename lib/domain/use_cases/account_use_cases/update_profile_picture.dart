import 'dart:io';

import 'package:meet_up/core/network/data_state.dart';
import 'package:meet_up/data/models/my_profile.dart';
import 'package:meet_up/domain/repositories/account_repository.dart';

class UpdateProfilePictureUseCases {
  final AccountRepository accountRepository;

  UpdateProfilePictureUseCases({required this.accountRepository});

  Future<DataState<MyProfile>> call({required File imagePath}) async {
    return await accountRepository.updateProfilePicture(imagePath: imagePath);
  }
}
