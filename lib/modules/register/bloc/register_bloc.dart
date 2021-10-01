import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:boilerplate_flutter/config/app_routes.dart';
import 'package:boilerplate_flutter/data/models/carro/carro.dart';
import 'package:boilerplate_flutter/data/models/field_state.dart';
import 'package:boilerplate_flutter/data/models/user/user_model.dart';
import 'package:boilerplate_flutter/data/repositories/account_repository.dart';
import 'package:boilerplate_flutter/util/validator/validator.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'register_event.dart';

part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterBloc(this.accountRepository) : super(Loading()) {
    add(OnFormChanged());
  }

  UserModel? userModel;
  final AccountRepository accountRepository;

  final TextEditingController _emailEditingController = TextEditingController();
  final TextEditingController _nameEditingController = TextEditingController();
  final TextEditingController _carModelEditingController =
      TextEditingController();
  final TextEditingController _passwordEditingController =
      TextEditingController();

  bool _isMotorista = false;
  int _countSeats = 1;

  @override
  Stream<RegisterState> mapEventToState(
    RegisterEvent event,
  ) async* {
    yield _mapEventToState(event);
  }

  RegisterState _mapEventToState(RegisterEvent event) {
    if (event is OnFormChanged) {
      return _mapOnFormChangedToState(event);
    } else if (event is OnRegisterButtonClicked) {
      return _mapOnRegisterButtonClickedToState(event);
    } else if (event is OnRegisterSuccess) {
      return _mapOnRegisterSuccessToState(event);
    } else if (event is OnRegisterFail) {
      return _mapOnRegisterFailedToState(event);
    } else if (event is OnRegisterClicked) {
      return _mapOnRegisterClickedState();
    } else if (event is OnChangeMotorista) {
      return _mapOnChangeMotoristaToState(event);
    } else if (event is CountChanged) {
      return _mapCountChangedToState(event);
    }
    return state;
  }

  RegisterState _mapOnFormChangedToState(RegisterEvent event) {
    RegisterState currentState = state;
    if (currentState is IdleRegister ||
        currentState is Loading ||
        currentState is Error) {
      return _getIdleState(null);
    }
    return currentState;
  }

  RegisterState _mapCountChangedToState(CountChanged event) {
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

  RegisterState _mapOnChangeMotoristaToState(OnChangeMotorista event) {
    _isMotorista == false ? _isMotorista = true : _isMotorista = false;

    RegisterState currentState = state;
    if (currentState is IdleRegister ||
        currentState is Loading ||
        currentState is Error) {
      return _getIdleState(null);
    }
    return currentState;
  }

  RegisterState _mapOnRegisterButtonClickedToState(RegisterEvent event) {
    accountRepository
        .register(
            email: _emailEditingController.text.trim(),
            password: _passwordEditingController.text.trim(),
            name: _nameEditingController.text.trim(),
            isMotorista: _isMotorista,
            carro: Carro(
                modelo: _carModelEditingController.text.trim(),
                assentosDisponiveis: _countSeats))
        .then((error) {
      if (error != null) {
        add(OnRegisterFail(error));
      } else {
        add(OnRegisterSuccess());
      }
    });
    return Loading();
  }

  RegisterState _mapOnRegisterSuccessToState(RegisterEvent event) {
    return _getIdleState(AppRoutes.core);
  }

  RegisterState _mapOnRegisterFailedToState(OnRegisterFail event) {
    return Error(error: event.error);
  }

  RegisterState _mapOnRegisterClickedState() {
    return _getIdleState(AppRoutes.register);
  }

  RegisterState _getIdleState(String? nextRoute) {
    bool isValidEmail = _emailEditingController.text.isValidEmailUFSC();
    bool isValidPassword =
        Validator.isValidPassword(_passwordEditingController.text);

    String? emailError = _emailEditingController.text.isEmpty
        ? null
        : (isValidEmail ? null : "Email inválido idUFSC");

    String? passwordError = _passwordEditingController.text.isEmpty
        ? null
        : (isValidPassword
            ? null
            : "As senhas devem ter pelo menos 8 caracteres");

    String? nameError = _nameEditingController.text.isEmpty
        ? null
        : (_nameEditingController.text.length < 2
            ? "Seu nome tem que possuir mais de 2 caracteres"
            : null);
    bool isName = !(_nameEditingController.text.length < 2);

    String? carModelError = _carModelEditingController.text.isEmpty
        ? null
        : (_carModelEditingController.text.length < 2
            ? "Informe o modelo do carro"
            : null);
    bool isCarModel = !(_carModelEditingController.text.length < 2);

    FieldState emailFieldState =
        FieldState(controller: _emailEditingController, error: emailError);
    FieldState passwordFieldState = FieldState(
        controller: _passwordEditingController, error: passwordError);
    FieldState nameFieldState =
        FieldState(controller: _nameEditingController, error: nameError);
    FieldState carModelFieldState = FieldState(
        controller: _carModelEditingController, error: carModelError);

    bool isButtonEnabled = isRegisterButtonEnabled(
        isValidPassword: isValidPassword,
        isValidEmail: isValidEmail,
        isName: isName,
        isCarModel: isCarModel,
        isMotorista: _isMotorista);

    return IdleRegister(
        emailFieldState: emailFieldState,
        passwordFieldState: passwordFieldState,
        nameFieldState: nameFieldState,
        carModelFieldState: carModelFieldState,
        isRegisterButtonEnabled: isButtonEnabled,
        isMotorista: _isMotorista,
        countSeats: _countSeats,
        nextRoute: nextRoute);
  }

  bool isRegisterButtonEnabled({
    required bool isValidPassword,
    required bool isValidEmail,
    required bool isName,
    required bool isCarModel,
    required bool isMotorista,
  }) {
    if (isMotorista) {
      return isValidPassword && isValidEmail && isName && isCarModel;
    }
    return isValidPassword && isValidEmail && isName;
  }

  @override
  Future<void> close() {
    return super.close();
  }
}
