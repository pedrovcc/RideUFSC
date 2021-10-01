import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:boilerplate_flutter/config/app_routes.dart';
import 'package:boilerplate_flutter/data/models/field_state.dart';
import 'package:boilerplate_flutter/data/models/user/user_model.dart';
import 'package:boilerplate_flutter/data/repositories/account_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'edit_profile_event.dart';

part 'edit_profile_state.dart';

class EditProfileBloc extends Bloc<EditProfileEvent, EditProfileState> {
  EditProfileBloc(
    AccountRepository accountRepository,
  )   : _accountRepository = accountRepository,
        super(Loading()) {
    listeners.add(_accountRepository.userModelStream.listen((user) {
      if (user != null) {
        add(UserUpdated(user));
      }
    }));
    add(OnFormChanged());
  }

  @override
  Stream<EditProfileState> mapEventToState(EditProfileEvent event) async* {
    yield _mapEventToState(event);
  }

  final AccountRepository _accountRepository;
  List<StreamSubscription> listeners = [];

  final TextEditingController _nameEditingController = TextEditingController();
  final TextEditingController _carModelEditingController =
      TextEditingController();

  bool _isMotorista = false;
  int _countSeats = 1;

  EditProfileState _mapEventToState(EditProfileEvent event) {
    if (event is OnFormChanged) {
      return _mapFormChangeEventToState();
    } else if (event is UpdateUserClicked) {
      return _mapOnUpdateUserButtonClickedToState(event);
    } else if (event is OnUpdateUserSuccess) {
      return _mapOnUpdateUserSuccessToState(event);
    } else if (event is OnUpdateUserFail) {
      return _mapOnUpdateUserFailedToState(event);
    } else if (event is UserUpdated) {
      return _mapUserUpdatedToState(event);
    } else if (event is OnCloseErrorClicked) {
      return _mapOnCloseErrorClicked();
    } else if (event is OnChangeMotorista) {
      return _mapOnChangeMotoristaToState(event);
    } else if (event is CountChanged) {
      return _mapCountChangedToState(event);
    }
    return state;
  }

  EditProfileState _mapUserUpdatedToState(UserUpdated event) {
    _nameEditingController.text = event.user.name;
    _isMotorista = event.user.isMotorista;
    _carModelEditingController.text = event.user.carro?.modelo ?? "";
    _countSeats = event.user.carro?.assentosDisponiveis ?? 1;

    return _mapFormChangeEventToState();
  }

  EditProfileState _mapOnChangeMotoristaToState(OnChangeMotorista event) {
    _isMotorista == false ? _isMotorista = true : _isMotorista = false;

    EditProfileState currentState = state;
    if (currentState is IdleEditProfile ||
        currentState is Loading ||
        currentState is Error) {
      return _getIdleState(null);
    }
    return currentState;
  }

  EditProfileState _mapFormChangeEventToState() {
    EditProfileState currentState = state;
    if (currentState is IdleEditProfile ||
        currentState is Loading ||
        currentState is Error) {
      return _getIdleState(null);
    }
    return currentState;
  }

  EditProfileState _mapOnCloseErrorClicked() {
    return _getIdleState(null);
  }

  EditProfileState _getIdleState(String? nextRoute) {
    String? carModelError = _carModelEditingController.text.isEmpty
        ? null
        : (_carModelEditingController.text.length < 2
            ? "Informe o modelo do carro"
            : null);
    bool isCarModel = !(_carModelEditingController.text.length < 2);

    String? nameError = _nameEditingController.text.isEmpty
        ? null
        : (_nameEditingController.text.length < 2
            ? "Seu nome tem que possuir mais de 2 caracteres"
            : null);
    bool isName = !(_nameEditingController.text.length < 2);

    FieldState nameFieldState =
        FieldState(controller: _nameEditingController, error: nameError);
    FieldState carModelFieldState = FieldState(
        controller: _carModelEditingController, error: carModelError);

    bool isButtonEnabled = isRegisterButtonEnabled(
        isName: isName, isCarModel: isCarModel, isMotorista: _isMotorista);

    return IdleEditProfile(
      nameFieldState: nameFieldState,
      carModelFieldState: carModelFieldState,
      isUpdateUserButtonEnabled: isButtonEnabled,
      nextRoute: nextRoute,
      countSeats: _countSeats,
      isMotorista: _isMotorista,
    );
  }

  EditProfileState _mapOnUpdateUserButtonClickedToState(
      EditProfileEvent event) {
    _accountRepository
        .updateFirebaseUser(
      name: _nameEditingController.text.trim(),
      carModel: _carModelEditingController.text.trim(),
      countSeats: _countSeats,
      isMotorista: _isMotorista,
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

  EditProfileState _mapCountChangedToState(CountChanged event) {
    if (event.isIncrease) {
      if (event.countSeat < 4) {
        _countSeats = event.countSeat + 1;
      }
    } else {
      if (event.countSeat > 1) {
        _countSeats = event.countSeat - 1;
      }
    }
    return _getIdleState(null);
  }

  EditProfileState _mapOnUpdateUserSuccessToState(EditProfileEvent event) {
    return _getIdleState(AppRoutes.core);
  }

  EditProfileState _mapOnUpdateUserFailedToState(OnUpdateUserFail event) {
    return ErrorEditUserState(error: event.error);
  }

  bool isRegisterButtonEnabled({
    required bool isName,
    required bool isCarModel,
    required bool isMotorista,
  }) {
    if (isMotorista) {
      return isName && isCarModel;
    }
    return isName;
  }

  @override
  Future<void> close() {
    listeners.forEach((element) {
      element.cancel();
    });
    return super.close();
  }
}
