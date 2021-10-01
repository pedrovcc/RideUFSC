part of 'ride_details_bloc.dart';

@immutable
abstract class RideDetailsEvent extends Equatable {
  const RideDetailsEvent();

  @override
  List<Object> get props => [];
}

class OnFormChanged extends RideDetailsEvent {
  OnFormChanged();
}

class DeleteRideClicked extends RideDetailsEvent {
  DeleteRideClicked(this.ride);

  final Ride ride;

  @override
  List<Object> get props => [ride];
}

class OnUpdateUserSuccess extends RideDetailsEvent {
  OnUpdateUserSuccess();
}

class OnUpdateUserFail extends RideDetailsEvent {
  OnUpdateUserFail(this.error);

  final Exception error;

  @override
  List<Object> get props => [error];
}

class UserUpdated extends RideDetailsEvent {
  UserUpdated(this.user);

  final UserModel user;

  @override
  List<Object> get props => [user];
}

class OnScreenResumed extends RideDetailsEvent {
  OnScreenResumed();
}

class OnCloseErrorClicked extends RideDetailsEvent {
  OnCloseErrorClicked();
}
