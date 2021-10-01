import 'package:boilerplate_flutter/config/app_routes.dart';
import 'package:boilerplate_flutter/config/theme.dart';
import 'package:boilerplate_flutter/data/models/user/user_model.dart';
import 'package:boilerplate_flutter/data/repositories/account_repository.dart';
import 'package:boilerplate_flutter/data/repositories/ride_repository.dart';
import 'package:boilerplate_flutter/modules/core/createDrive/bloc/driver_bloc.dart';
import 'package:boilerplate_flutter/modules/core/createDrive/components/ride_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DriverTab extends StatefulWidget {
  DriverTab(
      {required this.rideRepository, required this.accountRepository, required this.routeObserver, required this.user});

  final RideRepository rideRepository;
  final AccountRepository accountRepository;
  final RouteObserver routeObserver;
  final UserModel? user;

  @override
  _CreateRideTabState createState() => _CreateRideTabState();
}

class _CreateRideTabState extends State<DriverTab> with RouteAware {
  DriverBloc? bloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    ModalRoute? route = ModalRoute.of(context);
    if (route != null) {
      widget.routeObserver.subscribe(this, route);
    }
  }

  @override
  void dispose() {
    widget.routeObserver.unsubscribe(this);
    bloc = null;
    super.dispose();
  }

  @override
  void didPopNext() {
    bloc?.add(OnScreenResumed());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) {
        DriverBloc orderBloc = DriverBloc(this.widget.rideRepository, this.widget.accountRepository);
        bloc = orderBloc;
        return orderBloc;
      },
      child: BlocConsumer<DriverBloc, DriverState>(listener: (BuildContext context, DriverState state) {
        if (state is RideSelected && state.nextRoute != null) {
          String? localNextRoute = state.nextRoute;
          if (localNextRoute != null) {
            if (localNextRoute != AppRoutes.rideDetails) {
              context.read<DriverBloc>().add(OnScreenResumed());
              Navigator.of(context, rootNavigator: true).pushNamed(localNextRoute);
            } else {
              if (state is RideSelected) {
                context.read<DriverBloc>().add(OnScreenResumed());
                Navigator.of(context, rootNavigator: true).pushNamed(localNextRoute, arguments: state.ride);
              }
            }
          }
        } else if (state is RideLoaded && state.nextRoute != null) {
          String? localNextRoute = state.nextRoute;
          if (localNextRoute != null) {
            context.read<DriverBloc>().add(OnScreenResumed());
            Navigator.of(context, rootNavigator: true).pushNamed(localNextRoute);
          }
        }
      }, builder: (BuildContext context, DriverState rideState) {
        return Scaffold(
          backgroundColor: RideColors.white[98],
          appBar: AppBar(
            backgroundColor: RideColors.white,
            title: Text(
              'Minhas Viagens',
              style: Theme.of(context).textTheme.headline4?.apply(color: RideColors.primaryColor),
            ),
          ),
          body: SafeArea(
            child: rideState is RideLoaded
                ? RideList(
                    rideList: rideState.rides,
                    selectedRide: rideState.selectedRide,
                    onPress: (index) {
                      context.read<DriverBloc>().add(OnRideSelect(
                            ride: rideState.rides[index],
                          ));
                    },
                    onPressCreateRide: () {
                      context.read<DriverBloc>().add(OnCreateRideClicked());
                    },
                    isMotorista: rideState.isMotorista,
                  )
                : SizedBox.expand(
                    child: Container(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  ),
          ),
        );
      }),
    );
  }
}
