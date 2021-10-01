import 'package:boilerplate_flutter/config/theme.dart';
import 'package:boilerplate_flutter/data/repositories/ride_repository.dart';
import 'package:boilerplate_flutter/modules/core/history/bloc/history_tab_bloc.dart';
import 'package:boilerplate_flutter/modules/core/history/components/history_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HistoryTab extends StatefulWidget {
  HistoryTab({required this.rideRepository, required this.routeObserver});

  final RideRepository rideRepository;
  final RouteObserver routeObserver;

  @override
  _CreateHistoryTabState createState() => _CreateHistoryTabState();
}

class _CreateHistoryTabState extends State<HistoryTab> with RouteAware {
  HistoryTabBloc? bloc;

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
        HistoryTabBloc orderBloc = HistoryTabBloc(this.widget.rideRepository);
        bloc = orderBloc;
        return orderBloc;
      },
      child: BlocConsumer<HistoryTabBloc, HistoryTabState>(listener: (BuildContext context, HistoryTabState state) {
        if (state is RideLoaded && state.nextRoute != null) {
          String? localNextRoute = state.nextRoute;
          if (localNextRoute != null) {
            context.read<HistoryTabBloc>().add(OnScreenResumed());
            Navigator.of(context, rootNavigator: true).pushNamed(localNextRoute);
          }
        }
      }, builder: (BuildContext context, HistoryTabState rideState) {
        return Scaffold(
          backgroundColor: RideColors.white[98],
          appBar: AppBar(
            backgroundColor: RideColors.white,
            title: Text(
              'Histórico',
              style: Theme.of(context).textTheme.headline4?.apply(color: RideColors.primaryColor),
            ),
          ),
          body: SafeArea(
            child: rideState is RideLoaded
                ? HistoryList(
                    rideList: rideState.rides,
                    user: rideState.user,
                    onPress: (index) {
                      context.read<HistoryTabBloc>().add(
                            OnRideSelectForCancelAllocation(
                              ride: rideState.rides[index],
                            ),
                          );
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
