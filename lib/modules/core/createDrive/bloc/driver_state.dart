part of 'driver_bloc.dart';

@immutable
abstract class DriverState extends Equatable {
  List<Object?> get props => [];
}

class RideInitial extends DriverState {}

class RideLoaded extends DriverState {
  RideLoaded({required this.rides, required this.selectedRide, this.nextRoute, required this.isMotorista});

  final List<Ride> rides;
  final Ride? selectedRide;
  final String? nextRoute;
  final bool isMotorista;

  @override
  List<Object?> get props => [rides, selectedRide, isMotorista, nextRoute];
}

class RideSelected extends DriverState {
  RideSelected({required this.ride, this.nextRoute});

  final Ride ride;
  final String? nextRoute;

  @override
  List<Object?> get props => [ride, nextRoute];
}
