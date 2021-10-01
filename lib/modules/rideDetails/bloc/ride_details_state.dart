part of 'ride_details_bloc.dart';

@immutable
abstract class RideDetailsState extends Equatable {
  const RideDetailsState();

  @override
  List<Object?> get props => [];
}

class Loading extends RideDetailsState {
  const Loading() : super();
}

class ErrorDeleteRideState extends RideDetailsState {
  const ErrorDeleteRideState({
    required this.error,
  });

  final Exception error;

  @override
  List<Object?> get props => [error];
}

class IdleRideDetails extends RideDetailsState {
  const IdleRideDetails({
    required this.ride,
    this.nonFieldError,
    this.nextRoute,
  });

  final Ride ride;
  final String? nonFieldError;
  final String? nextRoute;

  @override
  List<Object?> get props => [
        ride,
        nonFieldError,
        nextRoute,
      ];
}
