part of 'auth_bloc.dart';

sealed class AuthState extends Equatable {}

final class AuthInitial extends AuthState {
  @override
  List<Object?> get props => [];
}

final class LoginLoadingState extends AuthState {
  @override
  List<Object?> get props => [];
}

final class LoginLoadedState extends AuthState {
  final LoginResponse data;

  LoginLoadedState({required this.data});

  @override
  List<Object?> get props => [data];
}

final class LoginFailedState extends AuthState {
  final String message;

  LoginFailedState({required this.message});

  @override
  List<Object?> get props => [message];
}

final class SignUpLoadingState extends AuthState {
  @override
  List<Object?> get props => [];
}

final class SignUpLoadedState extends AuthState {
  final SignUpResponse data;

  SignUpLoadedState({required this.data});

  @override
  List<Object?> get props => [data];
}

final class SignUpFailedState extends AuthState {
  final String message;

  SignUpFailedState({required this.message});

  @override
  List<Object?> get props => [message];
}
