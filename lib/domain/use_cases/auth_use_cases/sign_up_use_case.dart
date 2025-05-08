import 'package:meet_up/core/network/data_state.dart';
import 'package:meet_up/data/models/sign_up_response.dart';
import 'package:meet_up/domain/repositories/auth_repository.dart';

class SignUpUseCase {
  final AuthRepository repository;

  SignUpUseCase({required this.repository});

  Future<DataState<SignUpResponse>> call({
    required String name,
    required String email,
    required int age,
    required String phone,
    required String password,
    required String token,
    required String fcmToken,
    required String deviceId,
  }) {
    return repository.signUp(
      name: name,
      email: email,
      age: age,
      phone: phone,
      password: password,
      token: token,
      fcmToken: fcmToken,
      deviceId: deviceId,
    );
  }
}
