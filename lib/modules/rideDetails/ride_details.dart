import 'package:boilerplate_flutter/config/styles/default_button_style.dart';
import 'package:boilerplate_flutter/config/theme.dart';
import 'package:boilerplate_flutter/data/models/ride/ride.dart';
import 'package:boilerplate_flutter/data/models/traveler/traveler.dart';
import 'package:boilerplate_flutter/data/repositories/ride_repository.dart';
import 'package:boilerplate_flutter/modules/rideDetails/bloc/ride_details_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RideDetailsScreen extends StatefulWidget {
  const RideDetailsScreen({
    required RideRepository rideRepository,
    required Ride ride,
    required this.routeObserver,
  })  : _ride = ride,
        _rideRepository = rideRepository;

  final RideRepository _rideRepository;
  final RouteObserver routeObserver;
  final Ride _ride;

  @override
  RideDetailsScreenState createState() => RideDetailsScreenState();
}

class RideDetailsScreenState extends State<RideDetailsScreen> with RouteAware {
  RideDetailsBloc? bloc;

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
  Widget build(BuildContext context) {
    return BlocProvider<RideDetailsBloc>(
      create: (BuildContext context) {
        RideDetailsBloc tempBloc = RideDetailsBloc(widget._rideRepository, widget._ride);
        bloc = tempBloc;
        return tempBloc;
      },
      child: BlocConsumer<RideDetailsBloc, RideDetailsState>(
        listener: (context, state) {
          if (state is IdleRideDetails && state.nextRoute != null) {
            Navigator.of(context, rootNavigator: true).pop();
          }
        },
        builder: (BuildContext context, RideDetailsState state) {
          return SafeArea(
            top: false,
            bottom: false,
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.white,
                shadowColor: Colors.transparent,
                leading: BackButton(
                  color: Colors.black,
                ),
                title: Text(
                  'Detalhes da viagem',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              body: _getBody(context, state),
              bottomNavigationBar: _getSaveButton(context, state),
            ),
          );
        },
      ),
    );
  }

  Widget _getBody(BuildContext context, RideDetailsState state) {
    List<Traveler>? travelers = widget._ride.travelers;
    if (state is IdleRideDetails) {
      return SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 40,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget._ride.date,
                  )
                ],
              ),
              SizedBox(
                height: 40,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 20, left: 20, bottom: 20),
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.account_circle,
                                size: 24,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                widget._ride.nameDriver,
                                style: TextStyle(
                                  color: RideColors.white[12],
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.directions_car,
                                size: 24,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                widget._ride.carModel,
                                style: TextStyle(
                                  color: RideColors.white[12],
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 24,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            widget._ride.hour,
                            style: TextStyle(
                              color: RideColors.white[12],
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Divider(
                  thickness: 3,
                  indent: 40,
                  endIndent: 40,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Text(
                        'ORIGEM:',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget._ride.fromName,
                          style: TextStyle(
                            color: RideColors.white[12],
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          widget._ride.fromDescription,
                          style: TextStyle(
                            color: RideColors.white[12],
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Text(
                          'DESTINO:',
                          style: TextStyle(
                            color: RideColors.primaryColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget._ride.toName,
                            style: TextStyle(
                              color: RideColors.primaryColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            widget._ride.toDescription,
                            style: TextStyle(
                              color: RideColors.primaryColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Divider(
                  thickness: 3,
                  indent: 40,
                  endIndent: 40,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [Icon(Icons.airline_seat_recline_normal)],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Passageiros:',
                            style: TextStyle(
                              color: RideColors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          if (travelers != null && travelers.isNotEmpty)
                            ...travelers.map(
                              (rider) => Text(
                                rider.name,
                                style: TextStyle(
                                  color: RideColors.primaryColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    } else if (state is ErrorDeleteRideState) {
      return SingleChildScrollView(
        child: Column(
          children: [
            Text(state.error.toString()),
            ElevatedButton(
              onPressed: () {
                context.read<RideDetailsBloc>().add(OnScreenResumed());
              },
              style: getDefaultButtonStyle(),
              child: Text(
                'Ok',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
              ),
            )
          ],
        ),
      );
    } else {
      return SizedBox.expand(
        child: Container(
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }
  }

  Widget? _getSaveButton(BuildContext context, RideDetailsState state) {
    if (state is IdleRideDetails) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
        child: Container(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
              style: getDefaultButtonStyle(),
              child: Text(
                'Excluir viagem',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              onPressed: () {
                bloc?.add(DeleteRideClicked(state.ride));
              }),
        ),
      );
    }
    return null;
  }
}
