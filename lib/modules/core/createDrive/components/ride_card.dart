import 'package:boilerplate_flutter/config/theme.dart';
import 'package:boilerplate_flutter/data/models/ride/ride.dart';
import 'package:flutter/material.dart';

class RideCard extends StatelessWidget {
  const RideCard({required this.onPress, required this.ride}) : super();

  final Ride ride;
  final Function() onPress;

  @override
  Widget build(BuildContext context) {
    Widget content = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Container(
            child: Column(
              children: [
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            ride.nameDriver,
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
                            Icons.adjust,
                            size: 24,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            ride.fromName,
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
                SizedBox(
                  height: 12,
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
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
                            ride.carModel,
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
                            Icons.add_location,
                            size: 24,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            ride.toName,
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
              ],
            ),
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Icon(
          Icons.more_vert,
          size: 24,
        )
      ],
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: InkWell(
        onTap: () {
          onPress();
        },
        child: Card(
          elevation: 4,
          color: RideColors.primaryColor[50],
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                child: content,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
