part of 'login_bloc.dart';

abstract class LoginState extends Equatable {
  const LoginState();
}

class Idle extends LoginState {
  const Idle({
    required this.emailFieldState,
    required this.passwordFieldState,
    required this.isLoginButtonEnabled,
    this.nonFieldError,
    this.nextRoute,
  });

  final FieldState emailFieldState;
  final FieldState passwordFieldState;
  final bool isLoginButtonEnabled;
  final String? nonFieldError;
  final String? nextRoute;

  @override
  List<Object?> get props => [
    emailFieldState,
    passwordFieldState,
    isLoginButtonEnabled,
    nonFieldError,
    nextRoute
  ];
}

class Error extends LoginState {
  const Error({
    this.error,
  });

  final Exception? error;

  @override
  List<Object?> get props => [error];
}

class Loading extends LoginState {
  @override
  List<Object> get props => [];
}
