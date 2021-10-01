part of 'core_bloc.dart';

abstract class CoreState extends Equatable {
  const CoreState(this.user, this.index, this.nextRoute);

  final UserModel? user;
  final index;
  final String? nextRoute;

  @override
  List<Object?> get props => [user, index, nextRoute];
}

class Home extends CoreState {
  Home(UserModel? user, String? nextRoute) : super(user, 0, nextRoute);
}

class Driver extends CoreState {
  const Driver(UserModel? user, String? nextRoute) : super(user, 1, nextRoute);
}

class History extends CoreState {
  const History(UserModel? user, String? nextRoute) : super(user, 2, nextRoute);
}

class Profile extends CoreState {
  const Profile(UserModel? user, String? nextRoute) : super(user, 3, nextRoute);
}

class InitialState extends CoreState {
  InitialState() : super(null, 0, null);
}
