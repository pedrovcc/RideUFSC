part of 'profile_tab_bloc.dart';

abstract class ProfileTabEvent extends Equatable {
  const ProfileTabEvent();

  @override
  List<Object> get props => [];
}
class OnScreenResumed extends ProfileTabEvent {
  OnScreenResumed();
}

class ItemClicked extends ProfileTabEvent {
  ItemClicked(this.actionId);

  final String actionId;

  @override
  List<Object> get props => [actionId];
}
