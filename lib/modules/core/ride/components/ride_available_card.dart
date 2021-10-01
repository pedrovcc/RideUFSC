import 'package:boilerplate_flutter/config/theme.dart';
import 'package:boilerplate_flutter/data/models/ride/ride.dart';
import 'package:boilerplate_flutter/data/models/traveler/traveler.dart';
import 'package:boilerplate_flutter/data/models/user/user_model.dart';
import 'package:flutter/material.dart';

class RideAvailableCard extends StatelessWidget {
  const RideAvailableCard({required this.onPress, required this.ride, required this.user}) : super();

  final Ride ride;
  final UserModel user;

  final Function() onPress;

  @override
  Widget build(BuildContext context) {
    bool isAllocated = getRideAllocated(ride, user.uid);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                ride.date,
                style: TextStyle(
                  color: RideColors.white[12],
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              )
            ],
          ),
          Card(
            elevation: 4,
            color: RideColors.primaryColor[50],
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  child: Row(
                    children: [
                      Text(
                        "Carona",
                        style: TextStyle(
                          color: RideColors.white[12],
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
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
                              ride.hour,
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
                  padding: const EdgeInsets.only(left: 50),
                  child: Row(
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
                              ride.fromName,
                              style: TextStyle(
                                color: RideColors.white[12],
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              ride.fromDescription,
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
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20, left: 50),
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
                              ride.toName,
                              style: TextStyle(
                                color: RideColors.primaryColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              ride.toDescription,
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
                  padding: const EdgeInsets.only(top: 20, bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      if (ride.quantitySeats == 0 && isAllocated == false)
                        Row(
                          children: [
                            Container(
                              height: 40,
                              decoration: new BoxDecoration(
                                color: RideColors.white[64],
                                borderRadius: BorderRadius.all(Radius.circular(4)),
                              ),
                              child: TextButton(
                                onPressed: () {},
                                child: Text(
                                  "Sem assentos disponíveis",
                                  style: TextStyle(
                                    color: RideColors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      if (ride.quantitySeats > 0)
                        Row(
                          children: [
                            Text(
                              getQuantitySeat(ride.quantitySeats, ride.travelers, isAllocated).toString(),
                              style: TextStyle(
                                color: RideColors.black,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                            Icon(Icons.airline_seat_recline_normal),
                            Text(
                              "Assentos",
                              style: TextStyle(
                                color: RideColors.black,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            )
                          ],
                        ),
                      if (ride.quantitySeats > 0)
                        Row(
                          children: [
                            Container(
                              height: 40,
                              width: 120,
                              decoration: new BoxDecoration(
                                color: isAllocated ? RideColors.green : RideColors.primaryColor,
                                borderRadius: BorderRadius.all(Radius.circular(4)),
                              ),
                              child: TextButton(
                                onPressed: () {
                                  if (!isAllocated) {
                                    onPress();
                                    isAllocated = true;
                                  }
                                },
                                child: Text(
                                  isAllocated ? "Alocada" : "Alocar carona",
                                  style: TextStyle(
                                    color: RideColors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  int getQuantitySeat(int seat, List<Traveler>? travelers, bool isAllocated) {
    int quantitySeat = 0;
    if (isAllocated) {
      quantitySeat = seat - 1;
    }
    if (travelers != null && travelers.isNotEmpty) {
      quantitySeat = seat - travelers.length;
    } else {
      if (isAllocated) {
        quantitySeat = seat - 1;
      } else {
        quantitySeat = seat;
      }
    }
    return quantitySeat;
  }

  bool getRideAllocated(Ride ride, String userUid) {
    bool isAllocated = false;

    ride.travelers?.forEach((traveler) {
      if (traveler.id == userUid) {
        isAllocated = true;
      }
    });

    return isAllocated;
  }
}
