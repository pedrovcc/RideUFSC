part of 'ride_tab_bloc.dart';

@immutable
abstract class RideTabState extends Equatable {
  List<Object?> get props => [];
}

class RideInitial extends RideTabState {}

class RideLoaded extends RideTabState {
  RideLoaded({required this.rides, required this.user, this.nextRoute});

  final List<Ride> rides;
  final UserModel user;
  final String? nextRoute;

  @override
  List<Object?> get props => [rides, user, nextRoute];
}
