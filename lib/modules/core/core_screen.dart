import 'package:boilerplate_flutter/config/app_routes.dart';
import 'package:boilerplate_flutter/data/repositories/account_repository.dart';
import 'package:boilerplate_flutter/data/repositories/ride_repository.dart';
import 'package:boilerplate_flutter/modules/core/createDrive/driver_tab.dart';
import 'package:boilerplate_flutter/modules/core/history/history_tab.dart';
import 'package:boilerplate_flutter/modules/core/profile/profile_tab.dart';
import 'package:boilerplate_flutter/modules/core/ride/ride_tab.dart';
import 'package:boilerplate_flutter/util/components/navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/core_bloc.dart';

class CoreScreen extends StatefulWidget {
  const CoreScreen({
    required RouteObserver routeObserver,
    required AccountRepository accountRepository,
    required RideRepository rideRepository,
  })  : _routeObserver = routeObserver,
        _accountRepository = accountRepository,
        _rideRepository = rideRepository;

  final RouteObserver _routeObserver;
  final AccountRepository _accountRepository;
  final RideRepository _rideRepository;

  @override
  _CoreScreenState createState() => _CoreScreenState();
}

class _CoreScreenState extends State<CoreScreen> with RouteAware {
  CoreBloc? bloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    ModalRoute? route = ModalRoute.of(context);
    if (route != null) {
      widget._routeObserver.subscribe(this, route);
    }
  }

  @override
  void dispose() {
    widget._routeObserver.unsubscribe(this);
    bloc = null;
    super.dispose();
  }

  @override
  void didPopNext() {
    bloc?.add(ScreenResumed());
    super.didPopNext();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CoreBloc>(
      create: (BuildContext context) {
        CoreBloc tempBloc = CoreBloc(widget._accountRepository, widget._rideRepository);
        bloc = tempBloc;
        return tempBloc;
      },
      child: BlocConsumer<CoreBloc, CoreState>(
        listener: (BuildContext context, CoreState state) {
          String? localNextRoute = state.nextRoute;

          if (localNextRoute != null) {
            if (localNextRoute == AppRoutes.appRestart) {
              Navigator.of(context, rootNavigator: true).pushNamedAndRemoveUntil(localNextRoute, (route) {
                return false;
              });
            } else {
              Navigator.of(context, rootNavigator: true).pushNamed(localNextRoute);
            }
          }
        },
        builder: (BuildContext context, CoreState state) {
          return Container(
            color: Colors.white,
            child: SafeArea(
              top: false,
              child: Scaffold(
                body: _getBody(context, state),
                bottomNavigationBar: NavigationBar(
                  isDriver: state.user?.isMotorista ?? false,
                  currentIndex: state.index,
                  onTap: (index) {
                    context.read<CoreBloc>().add(OnTabChanged(index));
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _getBody(BuildContext context, CoreState state) {
    if (state is Home) {
      print(state.user);
      return RideTab(
        rideRepository: widget._rideRepository,
        routeObserver: widget._routeObserver,
      );
    } else if (state is Driver) {
      print(state.user);
      return DriverTab(
        rideRepository: widget._rideRepository,
        accountRepository: widget._accountRepository,
        routeObserver: widget._routeObserver,
        user: state.user,
      );
    } else if (state is History) {
      print(state.user);
      return HistoryTab(
        rideRepository: widget._rideRepository,
        routeObserver: widget._routeObserver,
      );
    } else if (state is Profile) {
      print(state.user);
      return ProfileTab(
        accountRepository: widget._accountRepository,
        routeObserver: widget._routeObserver,
      );
    } else {
      return Container(
        height: 0,
      );
    }
  }
}
