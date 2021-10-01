import 'package:boilerplate_flutter/config/theme.dart';
import 'package:boilerplate_flutter/data/models/ride/ride.dart';
import 'package:boilerplate_flutter/modules/core/createDrive/components/create_ride_empty.dart';
import 'package:boilerplate_flutter/modules/core/createDrive/components/ride_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'is_not_motorista.dart';

class RideList extends StatefulWidget {
  RideList({
    required this.rideList,
    required this.selectedRide,
    required this.onPress,
    required this.onPressCreateRide,
    required this.isMotorista,
  }) : super();

  final List<Ride> rideList;
  final Ride? selectedRide;
  final Function(int) onPress;
  final Function() onPressCreateRide;
  final bool isMotorista;

  @override
  RideListState createState() => RideListState();
}

class RideListState extends State<RideList> {
  ScrollController? _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    initializeDateFormatting('pt_BR');
  }

  @override
  Widget build(BuildContext context) {
    return widget.isMotorista
        ? (widget.rideList.length > 0)
            ? SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: ListView.builder(
                        shrinkWrap: true,
                        controller: _scrollController,
                        itemCount: widget.rideList.length,
                        itemBuilder: (context, index) => RideCard(
                          ride: widget.rideList[index],
                          onPress: () {
                            widget.onPress(index);
                          },
                        ),
                      ),
                    ),
                    Container(
                      decoration: new BoxDecoration(
                          color: RideColors.primaryColor, borderRadius: BorderRadius.all(Radius.circular(4))),
                      child: TextButton(
                        child: Icon(
                          Icons.add,
                          size: 40,
                          color: RideColors.white,
                        ),
                        onPressed: () {
                          widget.onPressCreateRide();
                        },
                      ),
                    )
                  ],
                ),
              )
            : CreateRideListEmpty(
                onPressCreateRide: widget.onPressCreateRide,
              )
        : IsNotMotorista();
  }
}
