part of 'history_tab_bloc.dart';

@immutable
abstract class HistoryTabEvent {}

class LoadRides extends HistoryTabEvent {}

class OnRideSelectForCancelAllocation extends HistoryTabEvent {
  OnRideSelectForCancelAllocation({
    required this.ride,
  });

  final Ride ride;
}

class OnScreenResumed extends HistoryTabEvent {}
