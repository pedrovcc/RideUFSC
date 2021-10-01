part of 'core_bloc.dart';

abstract class CoreEvent extends Equatable {
  const CoreEvent();

  @override
  List<Object> get props => [];
}

class OnTabChanged extends CoreEvent {
  const OnTabChanged(this.tabIndex) : super();

  final int tabIndex;

  @override
  List<Object> get props => [tabIndex];
}

class ScreenResumed extends CoreEvent {
  ScreenResumed();
}

class Logout extends CoreEvent {
  Logout();
}

class UserUpdated extends CoreEvent {
  UserUpdated(this.user);

  final UserModel user;

  @override
  List<Object> get props => [user];
}

class TokenUpdated extends CoreEvent {
  TokenUpdated(this.token);

  final String token;

  @override
  List<Object> get props => [token];
}
