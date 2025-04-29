part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {}

final class UserLoginEvent extends AuthEvent {
  final String phone;
  final String password;

  UserLoginEvent({required this.phone, required this.password});

  @override
  List<Object?> get props => [phone, password];
}

final class UserSignUpEvent extends AuthEvent {
  final String name;
  final String email;
  final int age;
  final String phone;
  final String password;
  final String fcmToken;
  final String deviceId;

  UserSignUpEvent({
    required this.name,
    required this.email,
    required this.age,
    required this.phone,
    required this.password,
    required this.fcmToken,
    required this.deviceId,
  });

  @override
  List<Object?> get props => [
    name,
    email,
    age,
    phone,
    password,
    fcmToken,
    deviceId,
  ];
}
