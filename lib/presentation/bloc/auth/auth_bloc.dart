import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_up/core/local/local_storage_manager.dart';
import 'package:meet_up/core/network/data_state.dart';
import 'package:meet_up/data/models/login_response.dart';
import 'package:meet_up/data/models/sign_up_response.dart';
import 'package:meet_up/domain/use_cases/auth_use_cases/login_use_case.dart';
import 'package:meet_up/domain/use_cases/auth_use_cases/sign_up_use_case.dart';

part 'auth_events.dart';

part 'auth_states.dart';

class AuthBloc extends Bloc<AuthEvents, AuthStates> {
  final LoginUseCase loginUseCase;
  final SignUpUseCase signUpUseCase;
  final LocalStorageManager storageManager;

  AuthBloc({
    required this.loginUseCase,
    required this.signUpUseCase,
    required this.storageManager,
  }) : super(AuthInitial()) {
    on<UserLoginEvent>(_login);
    on<UserSignUpEvent>(_signUp);
  }

  void _login(UserLoginEvent event, Emitter<AuthStates> emit) async {
    emit(LoginLoadingState());

    String? deviceId = await getDeviceId();

    if (deviceId == null) {
      emit(LoginFailedState(message: "Internal Error! Please try again."));
      return;
    }

    final response = await loginUseCase.call(
      phone: event.phone,
      password: event.password,
      deviceId: deviceId,
    );

    if (response is DataSuccess) {
      storageManager.setToken(event.phone);

      emit(LoginLoadedState(data: response.data!));
    } else {
      emit(LoginFailedState(message: response.message!));
    }
  }

  void _signUp(UserSignUpEvent event, Emitter<AuthStates> emit) async {
    emit(SignUpLoadingState());

    String? deviceId = await getDeviceId();
    String? fcmToken = await _getFirebaseToken();

    if (fcmToken == null || deviceId == null) {
      emit(
        SignUpFailedState(
          message: "Server Error! Please try after some time..",
        ),
      );
      return;
    }

    final response = await signUpUseCase.call(
      name: event.name,
      email: event.email,
      age: event.age,
      phone: event.phone,
      password: event.password,
      fcmToken: fcmToken,
      token: event.phone,
      deviceId: deviceId,
    );

    if (response is DataSuccess) {
      storageManager.setToken(event.phone);
      emit(SignUpLoadedState(data: response.data!));
    } else {
      emit(SignUpFailedState(message: response.message!));
    }
  }

  Future<String?> getDeviceId() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      return androidInfo.id;
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      return iosInfo.identifierForVendor ?? '';
    }
    return null;
  }

  Future<String?> _getFirebaseToken() async =>
      await FirebaseMessaging.instance.getToken();
}
