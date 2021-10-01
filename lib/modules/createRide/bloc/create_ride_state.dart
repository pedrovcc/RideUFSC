part of 'create_ride_bloc.dart';

@immutable
abstract class CreateRideState extends Equatable {
  const CreateRideState();

  @override
  List<Object?> get props => [];
}

class Loading extends CreateRideState {
  const Loading() : super();
}

class ErrorEditUserState extends CreateRideState {
  const ErrorEditUserState({
    required this.error,
  });

  final Exception error;

  @override
  List<Object?> get props => [error];
}

class IdleCreateRide extends CreateRideState {
  const IdleCreateRide({
    required this.partidaRefFieldState,
    required this.destinoRefFieldState,
    required this.isUpdateUserButtonEnabled,
    required this.toLocation,
    required this.fromLocation,
    required this.itemsLocation,
    required this.date,
    required this.hour,
    this.nonFieldError,
    this.nextRoute,
  });

  final FieldState partidaRefFieldState;
  final FieldState destinoRefFieldState;
  final String fromLocation;
  final String toLocation;
  final String date;
  final String hour;
  final List<String> itemsLocation;
  final bool isUpdateUserButtonEnabled;
  final String? nonFieldError;
  final String? nextRoute;

  @override
  List<Object?> get props => [
        partidaRefFieldState,
        destinoRefFieldState,
        isUpdateUserButtonEnabled,
        fromLocation,
        toLocation,
        date,
        hour,
        itemsLocation,
        nonFieldError,
        nextRoute,
      ];
}
