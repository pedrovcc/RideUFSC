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

part 'create_ride_event.dart';

part 'create_ride_state.dart';

class CreateRideBloc extends Bloc<CreateRideEvent, CreateRideState> {
  CreateRideBloc(
    RideRepository rideRepository,
  )   : _rideRepository = rideRepository,
        super(Loading()) {
    add(OnFormChanged());
  }

  @override
  Stream<CreateRideState> mapEventToState(CreateRideEvent event) async* {
    yield _mapEventToState(event);
  }

  final RideRepository _rideRepository;
  List<StreamSubscription> listeners = [];

  final TextEditingController _partidaEditingController = TextEditingController();
  final TextEditingController _destinoEditingController = TextEditingController();
  String _toLocation = Local.values.first.displayTitle;
  String _fromLocation = Local.values.first.displayTitle;
  String _hours = "";
  bool _hoursLocal = false;
  String _date = "";

  List<String> _itemsLocation = [];

  CreateRideState _mapEventToState(CreateRideEvent event) {
    if (event is OnFormChanged) {
      return _mapFormChangeEventToState();
    } else if (event is CreateRideClicked) {
      return _mapOnCreateRideButtonClickedToState();
    } else if (event is OnUpdateUserSuccess) {
      return _mapOnUpdateUserSuccessToState(event);
    } else if (event is OnUpdateUserFail) {
      return _mapOnUpdateUserFailedToState(event);
    } else if (event is OnCloseErrorClicked) {
      return _mapOnCloseErrorClicked();
    } else if (event is ToLocationChanged) {
      return _mapToLocationChangedToState(event);
    } else if (event is FromLocationChanged) {
      return _mapFromLocationChangedToState(event);
    } else if (event is HourChanged) {
      return _mapTimeChangedToState(event);
    } else if (event is DateChanged) {
      return _mapDateChangedToState(event);
    }
    return state;
  }

  CreateRideState _mapFormChangeEventToState() {
    CreateRideState currentState = state;
    if (currentState is IdleCreateRide || currentState is Loading || currentState is Error) {
      return _getIdleState(null);
    }
    return currentState;
  }

  CreateRideState _mapOnCloseErrorClicked() {
    return _getIdleState(null);
  }

  CreateRideState _getIdleState(String? nextRoute) {
    if (_itemsLocation.isEmpty) {
      Local.values.forEach((local) {
        _itemsLocation.add(local.displayTitle);
      });
    }

    String? partidaError = _partidaEditingController.text.isEmpty
        ? null
        : (_partidaEditingController.text.length < 2 ? "Informe uma referência com mais de 2 caracteres" : null);
    bool isPartidaRef = !(_partidaEditingController.text.length < 2);

    String? destinoError = _destinoEditingController.text.isEmpty
        ? null
        : (_destinoEditingController.text.length < 2 ? "Informe uma referência com mais de 2 caracteres" : null);
    bool isDestinoRef = !(_destinoEditingController.text.length < 2);

    FieldState partidaRefFieldState = FieldState(controller: _partidaEditingController, error: partidaError);
    FieldState destinoRefFieldState = FieldState(controller: _destinoEditingController, error: destinoError);

    bool hasDate = _date.isNotEmpty;
    bool hasTime = _hours.isNotEmpty && _hoursLocal;
    bool hasReferenceEquals = !_fromLocation.contains(_toLocation);

    bool isButtonEnabled = isRegisterButtonEnabled(
      hasReferenceEquals: hasReferenceEquals,
      isPartidaRef: isPartidaRef,
      isDestinoRef: isDestinoRef,
      hasDate: hasDate,
      hasTime: hasTime,
    );

    return IdleCreateRide(
      partidaRefFieldState: partidaRefFieldState,
      destinoRefFieldState: destinoRefFieldState,
      toLocation: _toLocation,
      fromLocation: _fromLocation,
      itemsLocation: _itemsLocation,
      date: _date,
      hour: _hours,
      isUpdateUserButtonEnabled: isButtonEnabled,
      nextRoute: nextRoute,
    );
  }

  CreateRideState _mapOnCreateRideButtonClickedToState() {
    _rideRepository
        .createRide(
      ride: Ride(
        rideUid: "",
        driverUid: "",
        nameDriver: "",
        carModel: "",
        quantitySeats: 0,
        hour: _hours,
        date: _date,
        fromName: _fromLocation,
        fromDescription: _partidaEditingController.text.trim(),
        toName: _toLocation,
        toDescription: _destinoEditingController.text.trim(),
        travelers: null,
      ),
    )
        .then((error) {
      if (error != null) {
        add(OnUpdateUserFail(error));
      } else {
        add(OnUpdateUserSuccess());
      }
    });
    return Loading();
  }

  CreateRideState _mapToLocationChangedToState(ToLocationChanged event) {
    _toLocation = event.location;
    return _getIdleState(null);
  }

  CreateRideState _mapFromLocationChangedToState(FromLocationChanged event) {
    _fromLocation = event.location;
    return _getIdleState(null);
  }

  CreateRideState _mapTimeChangedToState(HourChanged event) {
    String hour = event.timeOfDay.hour.toString();
    String min = event.timeOfDay.minute.toString();
    _hours = "$hour:${min == '0' ? '00' : min}";

    _hoursLocal = compareToHour(TimeOfDay.now(), event.timeOfDay);

    return _getIdleState(null);
  }

  CreateRideState _mapDateChangedToState(DateChanged event) {
    DateFormat formatter = new DateFormat('dd-MM-yyyy');
    _date = formatter.format(event.dateTime);
    return _getIdleState(null);
  }

  CreateRideState _mapOnUpdateUserSuccessToState(CreateRideEvent event) {
    return _getIdleState(AppRoutes.core);
  }

  CreateRideState _mapOnUpdateUserFailedToState(OnUpdateUserFail event) {
    return ErrorEditUserState(error: event.error);
  }

  bool isRegisterButtonEnabled({
    required bool hasReferenceEquals,
    required bool isPartidaRef,
    required bool isDestinoRef,
    required bool hasDate,
    required bool hasTime,
  }) {
    return hasReferenceEquals && isPartidaRef && isDestinoRef && hasDate && hasTime;
  }

  bool compareToHour(TimeOfDay other, TimeOfDay formTime) {
    if (formTime.hour < other.hour) return false;

    if (formTime.minute < other.minute) return false;

    return true;
  }

  @override
  Future<void> close() {
    listeners.forEach((element) {
      element.cancel();
    });
    return super.close();
  }
}
