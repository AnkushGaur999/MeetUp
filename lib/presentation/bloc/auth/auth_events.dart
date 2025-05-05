part of 'auth_bloc.dart';

sealed class AuthEvents extends Equatable {}

final class UserLoginEvent extends AuthEvents {
  final String phone;
  final String password;

  UserLoginEvent({required this.phone, required this.password});

  @override
  List<Object?> get props => [phone, password];
}

final class UserSignUpEvent extends AuthEvents {
  final String name;
  final String email;
  final int age;
  final String phone;
  final String password;

  UserSignUpEvent({
    required this.name,
    required this.email,
    required this.age,
    required this.phone,
    required this.password,
  });

  @override
  List<Object?> get props => [
    name,
    email,
    age,
    phone,
    password,
  ];
}
