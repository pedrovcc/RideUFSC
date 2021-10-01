import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:boilerplate_flutter/config/app_routes.dart';
import 'package:boilerplate_flutter/data/models/Locais/locais.dart';
import 'package:boilerplate_flutter/data/models/field_state.dart';
import 'package:boilerplate_flutter/data/models/ride/ride.dart';
import 'package:boilerplate_flutter/data/models/user/user_model.dart';
import 'package:boilerplate_flutter/data/repositories/account_repository.dart';
import 'package:boilerplate_flutter/data/repositories/ride_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';

part 'ride_details_event.dart';

part 'ride_details_state.dart';

class RideDetailsBloc extends Bloc<RideDetailsEvent, RideDetailsState> {
  RideDetailsBloc(RideRepository rideRepository, Ride ride)
      : _rideRepository = rideRepository,
        _ride = ride,
        super(Loading()) {
    add(OnScreenResumed());
  }

  @override
  Stream<RideDetailsState> mapEventToState(RideDetailsEvent event) async* {
    yield _mapEventToState(event);
  }

  final RideRepository _rideRepository;
  final Ride _ride;
  List<StreamSubscription> listeners = [];

  RideDetailsState _mapEventToState(RideDetailsEvent event) {
    if (event is OnScreenResumed) {
      return _mapFormChangeEventToState();
    } else if (event is DeleteRideClicked) {
      return _mapOnDeletedRideButtonClickedToState(event);
    } else if (event is OnUpdateUserSuccess) {
      return _mapOnUpdateUserSuccessToState(event);
    } else if (event is OnUpdateUserFail) {
      return _mapOnUpdateUserFailedToState(event);
    } else if (event is OnCloseErrorClicked) {
      return _mapOnCloseErrorClicked();
    }
    return state;
  }

  RideDetailsState _mapFormChangeEventToState() {
    RideDetailsState currentState = state;
    if (currentState is IdleRideDetails || currentState is Loading || currentState is Error) {
      return _getIdleState(null);
    }
    return currentState;
  }

  RideDetailsState _mapOnCloseErrorClicked() {
    return _getIdleState(null);
  }

  RideDetailsState _getIdleState(String? nextRoute) {
    return IdleRideDetails(ride: _ride, nextRoute: nextRoute);
  }

  RideDetailsState _mapOnDeletedRideButtonClickedToState(DeleteRideClicked event) {
    _rideRepository.deleteRide(ride: event.ride).then((error) {
      if (error != null) {
        add(OnUpdateUserFail(error));
      } else {
        add(OnUpdateUserSuccess());
      }
    });
    return Loading();
  }

  RideDetailsState _mapOnUpdateUserSuccessToState(RideDetailsEvent event) {
    return _getIdleState(AppRoutes.createRide);
  }

  RideDetailsState _mapOnUpdateUserFailedToState(OnUpdateUserFail event) {
    return ErrorDeleteRideState(error: event.error);
  }

  @override
  Future<void> close() {
    listeners.forEach((element) {
      element.cancel();
    });
    return super.close();
  }
}
