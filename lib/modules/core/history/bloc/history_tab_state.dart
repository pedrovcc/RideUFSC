part of 'history_tab_bloc.dart';

@immutable
abstract class HistoryTabState {List<Object?> get props => [];
}

class RideInitial extends HistoryTabState {}

class RideLoaded extends HistoryTabState {
  RideLoaded({required this.rides, required this.user, this.nextRoute});

  final List<Ride> rides;
  final UserModel user;
  final String? nextRoute;

  @override
  List<Object?> get props => [rides, user, nextRoute];
}
