import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:boilerplate_flutter/config/app_routes.dart';
import 'package:boilerplate_flutter/data/models/ride/ride.dart';
import 'package:boilerplate_flutter/data/models/user/user_model.dart';
import 'package:boilerplate_flutter/data/repositories/account_repository.dart';
import 'package:boilerplate_flutter/data/repositories/ride_repository.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'driver_event.dart';

part 'driver_state.dart';

class DriverBloc extends Bloc<DriverEvent, DriverState> {
  DriverBloc(RideRepository rideRepository, AccountRepository accountRepository)
      : _rideRepository = rideRepository,
        _accountRepository = accountRepository,
        super(RideInitial()) {
    listeners.add(_accountRepository.userModelStream.listen((user) {
      if (user != null) {
        userModel = user;
      }
    }));

    _rideRepository.getRideList();

    listeners.add(_rideRepository.rideListSubject.listen((rideList) {
      _rideList = rideList;
      add(LoadRides());
    }));
  }

  Ride? selectedRide;
  List<StreamSubscription> listeners = [];
  List<Ride> _rideList = [];
  RideRepository _rideRepository;
  AccountRepository _accountRepository;
  UserModel? userModel;

  @override
  Stream<DriverState> mapEventToState(
    DriverEvent event,
  ) async* {
    yield _mapEventToState(event);
  }

  DriverState _mapEventToState(DriverEvent event) {
    if (event is LoadRides) {
      return _mapRideLoadedToState(event);
    } else if (event is OnRideSelect) {
      return _mapRideSelectToState(event);
    } else if (event is OnCreateRideClicked) {
      return _mapCreateRideClickedToState();
    } else if (event is OnScreenResumed) {
      return _onScreenResumedToState();
    }

    return state;
  }

  DriverState _onScreenResumedToState() {
    return getRideLoadedState(null);
  }

  DriverState _mapRideLoadedToState(DriverEvent event) {
    return getRideLoadedState(null);
  }

  DriverState _mapCreateRideClickedToState() {
    return getRideLoadedState(AppRoutes.createRide);
  }

  DriverState _mapRideSelectToState(OnRideSelect event) {
    _rideRepository.selectRide(event.ride);
    return RideSelected(
      ride: event.ride,
      nextRoute: AppRoutes.rideDetails,
    );
  }

  DriverState getRideLoadedState(String? nextRoute) {
    if (userModel != null ){
      return RideLoaded(
        rides: _rideList,
        selectedRide: selectedRide,
        isMotorista: userModel!.isMotorista,
        nextRoute: nextRoute,
      );
    }
    return state;
  }

  @override
  Future<void> close() {
    listeners.forEach((listener) {
      listener.cancel();
    });
    return super.close();
  }
}
