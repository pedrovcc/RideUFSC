part of 'register_bloc.dart';

abstract class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object> get props => [];
}

class OnFormChanged extends RegisterEvent {
  const OnFormChanged() : super();
}

class OnChangeMotorista extends RegisterEvent {
  const OnChangeMotorista() : super();
}

class CountChanged extends RegisterEvent {
  CountChanged(this.countSeat, this.isIncrease);

  final int countSeat;
  final bool isIncrease;

  @override
  List<Object> get props => [countSeat, isIncrease];
}

class OnRegisterButtonClicked extends RegisterEvent {
  OnRegisterButtonClicked();
}

class OnRegisterClicked extends RegisterEvent {
  OnRegisterClicked();
}

class OnRegisterSuccess extends RegisterEvent {
  OnRegisterSuccess();
}

class OnRegisterFail extends RegisterEvent {
  OnRegisterFail(this.error);

  final Exception error;

  @override
  List<Object> get props => [error];
}

class OnScreenResumed extends RegisterEvent {
  OnScreenResumed();
}
