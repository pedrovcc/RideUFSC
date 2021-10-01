import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:boilerplate_flutter/data/models/ride/ride.dart';
import 'package:boilerplate_flutter/data/models/user/user_model.dart';
import 'package:boilerplate_flutter/data/repositories/ride_repository.dart';
import 'package:meta/meta.dart';

part 'history_tab_event.dart';
part 'history_tab_state.dart';

class HistoryTabBloc extends Bloc<HistoryTabEvent, HistoryTabState> {
  HistoryTabBloc(RideRepository rideRepository)
      : _rideRepository = rideRepository,
        super(RideInitial()) {
    _rideRepository.getRideList();
    listeners.add(_rideRepository.rideListForAllocatedSubject.listen((rideList) {
      _rideList = rideList;
      add(LoadRides());
    }));

    listeners.add(_rideRepository.userSubject.listen((user) {
      UserModel? localUser = user;
      if (localUser != null) {
        _user = localUser;
      }
      add(LoadRides());
    }));
  }

  List<StreamSubscription> listeners = [];
  List<Ride> _rideList = [];
  UserModel? _user;
  RideRepository _rideRepository;

  @override
  Stream<HistoryTabState> mapEventToState(
    HistoryTabEvent event,
      ) async* {
    yield _mapEventToState(event);
  }

  HistoryTabState _mapEventToState(HistoryTabEvent event) {
    if (event is LoadRides) {
      return _mapRideLoadedToState(event);
    } else if (event is OnRideSelectForCancelAllocation) {
      return _mapRideSelectForCancelAllocationToState(event);
    } else if (event is OnScreenResumed) {
      return _onScreenResumedToState();
    }

    return state;
  }

  HistoryTabState _onScreenResumedToState() {
    return getRideLoadedState(null);
  }

  HistoryTabState _mapRideLoadedToState(HistoryTabEvent event) {
    return getRideLoadedState(null);
  }

  HistoryTabState _mapRideSelectForCancelAllocationToState(OnRideSelectForCancelAllocation event) {
    _rideRepository.removeSeatAllocationInRide(ride: event.ride);
    return _onScreenResumedToState();
  }

  HistoryTabState getRideLoadedState(String? nextRoute) {
    return RideLoaded(
      rides: _rideList,
      user: _user!,
      nextRoute: nextRoute,
    );
  }

  @override
  Future<void> close() {
    listeners.forEach((listener) {
      listener.cancel();
    });
    return super.close();
  }
}
