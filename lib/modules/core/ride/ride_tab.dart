
import 'package:boilerplate_flutter/config/theme.dart';
import 'package:boilerplate_flutter/data/repositories/ride_repository.dart';
import 'package:boilerplate_flutter/modules/core/ride/bloc/ride_tab_bloc.dart';
import 'package:boilerplate_flutter/modules/core/ride/components/ride_available_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RideTab extends StatefulWidget {
  RideTab({required this.rideRepository, required this.routeObserver});

  final RideRepository rideRepository;
  final RouteObserver routeObserver;

  @override
  _CreateRideTabState createState() => _CreateRideTabState();
}

class _CreateRideTabState extends State<RideTab> with RouteAware {
  RideTabBloc? bloc;

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
        RideTabBloc orderBloc = RideTabBloc(this.widget.rideRepository);
        bloc = orderBloc;
        return orderBloc;
      },
      child: BlocConsumer<RideTabBloc, RideTabState>(listener: (BuildContext context, RideTabState state) {
        if (state is RideLoaded && state.nextRoute != null) {
          String? localNextRoute = state.nextRoute;
          if (localNextRoute != null) {
            context.read<RideTabBloc>().add(OnScreenResumed());
            Navigator.of(context, rootNavigator: true).pushNamed(localNextRoute);
          }
        }
      }, builder: (BuildContext context, RideTabState rideState) {
        return Scaffold(
          backgroundColor: RideColors.white[98],
          appBar: AppBar(
            backgroundColor: RideColors.white,
            title: Text(
              'Caronas Disponíveis',
              style: Theme.of(context).textTheme.headline4?.apply(color: RideColors.primaryColor),
            ),
          ),
          body: SafeArea(
            child: rideState is RideLoaded
                ? RideAvailableList(
                    rideList: rideState.rides,
                    user: rideState.user,
                    onPress: (index) {
                      context.read<RideTabBloc>().add(OnRideSelectForAllocation(
                            ride: rideState.rides[index],
                          ));
                    },
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
