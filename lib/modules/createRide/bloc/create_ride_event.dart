part of 'create_ride_bloc.dart';

@immutable
abstract class CreateRideEvent extends Equatable {
  const CreateRideEvent();

  @override
  List<Object> get props => [];
}

class OnFormChanged extends CreateRideEvent {
  OnFormChanged();
}

class CreateRideClicked extends CreateRideEvent {
  CreateRideClicked();
}

class OnUpdateUserSuccess extends CreateRideEvent {
  OnUpdateUserSuccess();
}

class OnUpdateUserFail extends CreateRideEvent {
  OnUpdateUserFail(this.error);

  final Exception error;

  @override
  List<Object> get props => [error];
}

class UserUpdated extends CreateRideEvent {
  UserUpdated(this.user);

  final UserModel user;

  @override
  List<Object> get props => [user];
}

class OnScreenResumed extends CreateRideEvent {
  OnScreenResumed();
}

class OnCloseErrorClicked extends CreateRideEvent {
  OnCloseErrorClicked();
}

class ToLocationChanged extends CreateRideEvent {
  ToLocationChanged(this.location);

  final String location;

  @override
  List<Object> get props => [location];
}

class FromLocationChanged extends CreateRideEvent {
  FromLocationChanged(this.location);

  final String location;

  @override
  List<Object> get props => [location];
}

class HourChanged extends CreateRideEvent {
  HourChanged(this.timeOfDay);

  final TimeOfDay timeOfDay;

  @override
  List<Object> get props => [timeOfDay];
}

class DateChanged extends CreateRideEvent {
  DateChanged(this.dateTime);

  final DateTime dateTime;

  @override
  List<Object> get props => [dateTime];
}
