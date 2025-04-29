import 'package:meet_up/core/network/data_state.dart';
import 'package:meet_up/data/models/login_response.dart';
import 'package:meet_up/data/models/sign_up_response.dart';

abstract class AuthRepository {
  Future<DataState<LoginResponse>> login({
    required String phone,
    required String password,
    required String deviceId,
  });

  Future<DataState<SignUpResponse>> signUp({
    required String name,
    required String email,
    required int age,
    required String phone,
    required String password,
    required String fcmToken,
    required String deviceId,
  });
}
