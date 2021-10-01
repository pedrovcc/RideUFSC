part of 'edit_profile_bloc.dart';

abstract class EditProfileState extends Equatable {
  const EditProfileState();

  @override
  List<Object?> get props => [];
}

class Loading extends EditProfileState {
  const Loading() : super();
}

class ErrorEditUserState extends EditProfileState {
  const ErrorEditUserState({
    required this.error,
  });

  final Exception error;

  @override
  List<Object?> get props => [error];
}

class IdleEditProfile extends EditProfileState {
  const IdleEditProfile({
    required this.nameFieldState,
    required this.carModelFieldState,
    required this.isUpdateUserButtonEnabled,
    required this.isMotorista,
    required this.countSeats,
    this.nonFieldError,
    this.nextRoute,
  });

  final FieldState nameFieldState;
  final FieldState carModelFieldState;
  final bool isUpdateUserButtonEnabled;
  final bool isMotorista;
  final int countSeats;
  final String? nonFieldError;
  final String? nextRoute;

  @override
  List<Object?> get props => [
        nameFieldState,
        carModelFieldState,
        isUpdateUserButtonEnabled,
        isMotorista,
        countSeats,
        nonFieldError,
        nextRoute,
      ];
}
