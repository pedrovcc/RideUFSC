part of 'register_bloc.dart';

abstract class RegisterState extends Equatable {
  const RegisterState();
}

class IdleRegister extends RegisterState {
  const IdleRegister({
    required this.emailFieldState,
    required this.passwordFieldState,
    required this.nameFieldState,
    required this.carModelFieldState,
    required this.isRegisterButtonEnabled,
    required this.isMotorista,
    required this.countSeats,
    this.nonFieldError,
    this.nextRoute,
  });

  final FieldState emailFieldState;
  final FieldState passwordFieldState;
  final FieldState nameFieldState;
  final FieldState carModelFieldState;
  final bool isRegisterButtonEnabled;
  final bool isMotorista;
  final int countSeats;
  final String? nonFieldError;
  final String? nextRoute;

  @override
  List<Object?> get props => [
        emailFieldState,
        passwordFieldState,
        nameFieldState,
        carModelFieldState,
        isRegisterButtonEnabled,
        isMotorista,
        countSeats,
        nonFieldError,
        nextRoute
      ];
}

class Error extends RegisterState {
  const Error({
    this.error,
  });

  final Exception? error;

  @override
  List<Object?> get props => [error];
}

class Loading extends RegisterState {
  @override
  List<Object> get props => [];
}
