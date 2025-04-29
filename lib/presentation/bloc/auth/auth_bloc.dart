import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_up/core/network/data_state.dart';
import 'package:meet_up/data/models/login_response.dart';
import 'package:meet_up/data/models/sign_up_response.dart';
import 'package:meet_up/domain/use_cases/auth_use_cases/login_use_case.dart';
import 'package:meet_up/domain/use_cases/auth_use_cases/sign_up_use_case.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  final SignUpUseCase signUpUseCase;

  AuthBloc({required this.loginUseCase, required this.signUpUseCase})
    : super(AuthInitial()) {
    on<UserLoginEvent>(_login);
  }

  void _login(UserLoginEvent event, Emitter<AuthState> emit) async {
    emit(LoginLoadingState());

    String deviceId = await getDeviceId();

    final response = await loginUseCase.call(
      phone: event.phone,
      password: event.password,
      deviceId: deviceId,
    );

    if (response is DataSuccess) {
      emit(LoginLoadedState(data: response.data!));
    } else {
      emit(LoginFailedState(message: response.message!));
    }
  }

  Future<String> getDeviceId() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      return androidInfo.id;
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      return iosInfo.identifierForVendor ?? '';
    } else {
      return 'unsupported-platform';
    }
  }
}
