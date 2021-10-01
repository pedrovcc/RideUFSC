part of 'ride_tab_bloc.dart';

@immutable
abstract class RideTabEvent {}

class LoadRides extends RideTabEvent {}

class OnRideSelectForAllocation extends RideTabEvent {
  OnRideSelectForAllocation({
    required this.ride,
  });

  final Ride ride;
}

class OnScreenResumed extends RideTabEvent {}