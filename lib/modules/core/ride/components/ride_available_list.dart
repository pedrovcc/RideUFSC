import 'package:boilerplate_flutter/config/theme.dart';
import 'package:boilerplate_flutter/data/models/ride/ride.dart';
import 'package:boilerplate_flutter/data/models/traveler/traveler.dart';
import 'package:boilerplate_flutter/data/models/user/user_model.dart';
import 'package:boilerplate_flutter/data/repositories/account_repository.dart';
import 'package:boilerplate_flutter/modules/core/createDrive/components/create_ride_empty.dart';
import 'package:boilerplate_flutter/modules/core/createDrive/components/ride_card.dart';
import 'package:boilerplate_flutter/modules/core/ride/components/ride_available_card.dart';
import 'package:boilerplate_flutter/modules/core/ride/components/ride_available_empty.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

class RideAvailableList extends StatefulWidget {
  RideAvailableList({
    required this.rideList,
    required this.user,
    required this.onPress,
  }) : super();

  final List<Ride> rideList;
  final UserModel user;
  final Function(int) onPress;

  @override
  RideAvailableListState createState() => RideAvailableListState();
}

class RideAvailableListState extends State<RideAvailableList> {
  ScrollController? _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    initializeDateFormatting('pt_BR');
  }

  @override
  Widget build(BuildContext context) {
    return (widget.rideList.length > 0)
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
                    itemBuilder: (context, index) => RideAvailableCard(
                      ride: widget.rideList[index],
                      onPress: () {
                        widget.onPress(index);
                      },
                      user: widget.user,
                    ),
                  ),
                ),
              ],
            ),
          )
        : RideAvailableListEmpty();
  }
}
