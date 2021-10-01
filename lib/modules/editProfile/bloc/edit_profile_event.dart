part of 'edit_profile_bloc.dart';

abstract class EditProfileEvent extends Equatable {
  const EditProfileEvent();

  @override
  List<Object> get props => [];
}

class OnFormChanged extends EditProfileEvent {
  OnFormChanged();
}

class UpdateUserClicked extends EditProfileEvent {
  UpdateUserClicked();
}

class OnUpdateUserSuccess extends EditProfileEvent {
  OnUpdateUserSuccess();
}

class OnUpdateUserFail extends EditProfileEvent {
  OnUpdateUserFail(this.error);

  final Exception error;

  @override
  List<Object> get props => [error];
}

class UserUpdated extends EditProfileEvent {
  UserUpdated(this.user);

  final UserModel user;

  @override
  List<Object> get props => [user];
}

class OnScreenResumed extends EditProfileEvent {
  OnScreenResumed();
}

class OnCloseErrorClicked extends EditProfileEvent {
  OnCloseErrorClicked();
}

class OnChangeMotorista extends EditProfileEvent {
  const OnChangeMotorista() : super();
}

class CountChanged extends EditProfileEvent {
  CountChanged(this.countSeat, this.isIncrease);

  final int countSeat;
  final bool isIncrease;

  @override
  List<Object> get props => [countSeat, isIncrease];
}