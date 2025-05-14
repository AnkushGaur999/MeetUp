import 'dart:io';
import 'package:meet_up/core/network/data_state.dart';
import 'package:meet_up/data/models/my_profile.dart';
import 'package:meet_up/domain/repositories/account_repository.dart';

class GetMyProfileDetailsUseCase {
  final AccountRepository accountRepository;

  GetMyProfileDetailsUseCase({required this.accountRepository});

  Future<DataState<MyProfile>> call() async {
    return await accountRepository.getMyProfileDetails();
  }
}
