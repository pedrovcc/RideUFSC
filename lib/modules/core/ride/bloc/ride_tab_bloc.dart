import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:boilerplate_flutter/data/models/ride/ride.dart';
import 'package:boilerplate_flutter/data/models/user/user_model.dart';
import 'package:boilerplate_flutter/data/repositories/ride_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'ride_tab_event.dart';

part 'ride_tab_state.dart';

class RideTabBloc extends Bloc<RideTabEvent, RideTabState> {
  RideTabBloc(RideRepository rideRepository)
      : _rideRepository = rideRepository,
        super(RideInitial()) {

    listeners.add(_rideRepository.userSubject.listen((user) {
      UserModel? localUser = user;
      if (localUser != null) {
        _user = localUser;
      }
      add(LoadRides());
    }));

    _rideRepository.getRideList();

    listeners.add(_rideRepository.rideListForAllocatedSubject.listen((rideList) {
      _rideList = rideList;
      add(LoadRides());
    }));
  }

  List<StreamSubscription> listeners = [];
  List<Ride> _rideList = [];
  UserModel? _user;
  RideRepository _rideRepository;

  @override
  Stream<RideTabState> mapEventToState(
    RideTabEvent event,
  ) async* {
    yield _mapEventToState(event);
  }

  RideTabState _mapEventToState(RideTabEvent event) {
    if (event is LoadRides) {
      return _mapRideLoadedToState(event);
    } else if (event is OnRideSelectForAllocation) {
      return _mapRideSelectForAllocationToState(event);
    } else if (event is OnScreenResumed) {
      return _onScreenResumedToState();
    }

    return state;
  }

  RideTabState _onScreenResumedToState() {
    return getRideLoadedState(null);
  }

  RideTabState _mapRideLoadedToState(RideTabEvent event) {
    return getRideLoadedState(null);
  }

  RideTabState _mapRideSelectForAllocationToState(OnRideSelectForAllocation event) {
    _rideRepository.seatAllocationInRide(ride: event.ride);
    return _onScreenResumedToState();
  }

  RideTabState getRideLoadedState(String? nextRoute) {
    UserModel? userLocal = _user;
    if (userLocal != null){
      return RideLoaded(
        rides: _rideList,
        user: userLocal,
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
