part of 'auth_bloc.dart';

sealed class AuthStates extends Equatable {}

final class AuthInitial extends AuthStates {
  @override
  List<Object?> get props => [];
}

final class LoginLoadingState extends AuthStates {
  @override
  List<Object?> get props => [];
}

final class LoginLoadedState extends AuthStates {
  final LoginResponse data;

  LoginLoadedState({required this.data});

  @override
  List<Object?> get props => [data];
}

final class LoginFailedState extends AuthStates {
  final String message;

  LoginFailedState({required this.message});

  @override
  List<Object?> get props => [message];
}

final class SignUpLoadingState extends AuthStates {
  @override
  List<Object?> get props => [];
}

final class SignUpLoadedState extends AuthStates {
  final SignUpResponse data;

  SignUpLoadedState({required this.data});

  @override
  List<Object?> get props => [data];
}

final class SignUpFailedState extends AuthStates {
  final String message;

  SignUpFailedState({required this.message});

  @override
  List<Object?> get props => [message];
}
