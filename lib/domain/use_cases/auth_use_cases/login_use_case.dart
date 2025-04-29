import 'package:meet_up/core/network/data_state.dart';
import 'package:meet_up/data/models/login_response.dart';
import 'package:meet_up/domain/repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase({required this.repository});

  Future<DataState<LoginResponse>> call({
    required String phone,
    required String password,
    required String deviceId,
  }) {
    return repository.login(
      phone: phone,
      password: password,
      deviceId: deviceId,
    );
  }
}
