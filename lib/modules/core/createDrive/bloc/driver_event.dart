part of 'driver_bloc.dart';

@immutable
abstract class DriverEvent {}

class LoadRides extends DriverEvent {}

class OnRideSelect extends DriverEvent {
  OnRideSelect({
    required this.ride,
  });

  final Ride ride;
}

class OnCreateRideClicked extends DriverEvent {
  OnCreateRideClicked();
}

class OnScreenResumed extends DriverEvent {}
