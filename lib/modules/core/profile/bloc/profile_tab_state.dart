part of 'profile_tab_bloc.dart';

abstract class ProfileTabState extends Equatable {
  const ProfileTabState();

  @override
  List<Object?> get props => [];
}

class Loading extends ProfileTabState {
  const Loading() : super();
}

class Error extends ProfileTabState {
  const Error({
    required this.error,
  });

  final Exception error;

  @override
  List<Object> get props => [error];
}

class Idle extends ProfileTabState {
  const Idle({
    required this.menuItemDescriptors,
    this.nonFieldError,
    required this.nextRoute,
  });

  final List<MenuItemDescriptor> menuItemDescriptors;
  final String? nonFieldError;
  final String? nextRoute;

  @override
  List<Object?> get props => [menuItemDescriptors, nonFieldError, nextRoute];
}
