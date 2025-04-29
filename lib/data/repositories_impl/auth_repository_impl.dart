import 'package:meet_up/core/network/data_state.dart';
import 'package:meet_up/data/models/login_response.dart';
import 'package:meet_up/data/models/sign_up_response.dart';
import 'package:meet_up/data/sources/auth_data_souce.dart';
import 'package:meet_up/domain/repositories/auth_repository.dart'
    show AuthRepository;

class AuthRepositoryImpl extends AuthRepository {
  final AuthDataSource authDataSource;

  AuthRepositoryImpl({required this.authDataSource});

  @override
  Future<DataState<LoginResponse>> login({
    required String phone,
    required String password,
    required String deviceId,
  }) {
    return authDataSource.login(
      phone: phone,
      password: password,
      deviceId: deviceId,
    );
  }

  @override
  Future<DataState<SignUpResponse>> signUp({
    required String name,
    required String email,
    required int age,
    required String phone,
    required String password,
    required String fcmToken,
    required String deviceId,
  }) {
    return authDataSource.signUp(
      name: name,
      email: email,
      age: age,
      phone: phone,
      password: password,
      fcmToken: fcmToken,
      deviceId: deviceId,
    );
  }
}
