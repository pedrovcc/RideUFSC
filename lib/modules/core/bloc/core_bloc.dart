import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:boilerplate_flutter/data/models/user/user_model.dart';
import 'package:boilerplate_flutter/data/repositories/account_repository.dart';
import 'package:boilerplate_flutter/data/repositories/ride_repository.dart';
import 'package:equatable/equatable.dart';

part 'core_event.dart';
part 'core_state.dart';

class CoreBloc extends Bloc<CoreEvent, CoreState> {
  CoreBloc(AccountRepository accountRepository, RideRepository rideRepository)
      : _accountRepository = accountRepository,
        _rideRepository = rideRepository,
        super(InitialState()) {
    _rideRepository.getRideList();
    listeners.add(_accountRepository.userModelStream.listen((user) {
      if (user != null) {
        userModel = user;
        add(UserUpdated(user));
      }
    }));

    add(OnTabChanged(0));
  }

  List<StreamSubscription> listeners = [];
  final AccountRepository _accountRepository;
  final RideRepository _rideRepository;
  UserModel? userModel;
  int tabIndex = 0;

  @override
  Stream<CoreState> mapEventToState(
    CoreEvent event,
  ) async* {
    yield _mapEventToState(event);
  }

  CoreState _mapEventToState(CoreEvent event) {
    if (event is OnTabChanged) {
      return _mapOnChangedTabEvent(event);
    } else if (event is ScreenResumed) {
      return _mapScreenResumedEventToState();
    } else if (event is UserUpdated) {
      return _getTabState(null);
    }
    return state;
  }

  CoreState _mapOnChangedTabEvent(OnTabChanged event) {
    tabIndex = event.tabIndex;
    return _getTabState(null);
  }

  CoreState _mapScreenResumedEventToState() {
    CoreState currentState = state;
    if (currentState is Home) {
      return Home(userModel, null);
    } else if (currentState is Profile) {
      return Profile(userModel, null);
    } else if (currentState is History) {
      return History(userModel, null);
    } else if (currentState is Driver) {
      return Driver(userModel, null);
    }
    return currentState;
  }

  CoreState _getTabState(String? nextRoute) {
    switch (tabIndex) {
      case 1:
        return Driver(userModel, nextRoute);
      case 2:
        return History(userModel, nextRoute);
      case 3:
        return Profile(userModel, nextRoute);
      default:
        return Home(userModel, nextRoute);
    }
  }

  @override
  Future<void> close() {
    listeners.forEach((element) {
      element.cancel();
    });
    return super.close();
  }
}
