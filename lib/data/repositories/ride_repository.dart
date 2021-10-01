import 'dart:convert';

import 'package:boilerplate_flutter/data/models/ride/ride.dart';
import 'package:boilerplate_flutter/data/models/traveler/traveler.dart';
import 'package:boilerplate_flutter/data/models/user/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RideRepository {
  RideRepository() {
    getUser().then((value) => _userSubject.add(value));
  }

  final _rideSubject = BehaviorSubject<Ride>();
  final _rideListSubject = BehaviorSubject<List<Ride>>();
  final _rideListForAllocatedSubject = BehaviorSubject<List<Ride>>();
  final _userSubject = BehaviorSubject<UserModel?>();

  Stream<Ride> get rideSubject async* {
    yield* _rideSubject.stream;
  }

  Stream<List<Ride>> get rideListSubject async* {
    yield* _rideListSubject.stream;
  }

  Stream<List<Ride>> get rideListForAllocatedSubject async* {
    yield* _rideListForAllocatedSubject.stream;
  }

  Stream<UserModel?> get userSubject async* {
    yield* _userSubject.stream;
  }

  Ride? get selectedRide {
    return _rideSubject.value;
  }

  List<Ride> get rideList {
    return _rideListSubject.value;
  }

  List<Ride> get rideListForAllocated {
    return _rideListForAllocatedSubject.value;
  }

  UserModel? get user {
    return _userSubject.value;
  }

  void selectRide(Ride ride) {
    _rideSubject.add(ride);
  }

  Future<UserModel?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJsonString = prefs.getString('user');
    if (userJsonString?.isNotEmpty == true) {
      return UserModel.fromJson(jsonDecode(userJsonString!));
    }
    return null;
  }

  Future<List<Ride>> getRideList() async {
    List<Ride> rides = [];
    List<Ride> ridesForAllocated = [];
    UserModel? user = await getUser();
    UserModel localUser;
    if (user != null) {
      localUser = user;

      try {
        await FirebaseFirestore.instance.collection("ride").get().then((QuerySnapshot querySnapshot) {
          querySnapshot.docs.forEach((ride) {
            List<dynamic> travelers = ride["travelers"];
            List<Traveler> travelersNamesStr = [];
            if (travelers.length > 0) {
              travelersNamesStr = travelers.map((e) => Traveler.fromJson(e)).toList();
            }
            if (ride["ride_uid"] == '') {
              updateRideFirebase(
                ride: Ride(
                  rideUid: ride["ride_uid"],
                  driverUid: ride["driver_uid"],
                  nameDriver: ride["name_driver"],
                  carModel: ride["car_model"],
                  quantitySeats: ride["quantity_seats"],
                  hour: ride["hour"],
                  date: ride["date"],
                  fromName: ride["from_name"],
                  fromDescription: ride["from_description"],
                  toName: ride["to_name"],
                  toDescription: ride["to_description"],
                  travelers: travelersNamesStr,
                ),
                rideUID: ride.reference.id,
              );
            }

            if (ride["driver_uid"] == localUser.uid) {
              rides.add(Ride(
                rideUid: ride["ride_uid"],
                driverUid: ride["driver_uid"],
                nameDriver: ride["name_driver"],
                carModel: ride["car_model"],
                quantitySeats: ride["quantity_seats"],
                hour: ride["hour"],
                date: ride["date"],
                fromName: ride["from_name"],
                fromDescription: ride["from_description"],
                toName: ride["to_name"],
                toDescription: ride["to_description"],
                travelers: travelersNamesStr,
              ));
            } else {
              ridesForAllocated.add(Ride(
                rideUid: ride["ride_uid"],
                driverUid: ride["driver_uid"],
                nameDriver: ride["name_driver"],
                carModel: ride["car_model"],
                quantitySeats: ride["quantity_seats"],
                hour: ride["hour"],
                date: ride["date"],
                fromName: ride["from_name"],
                fromDescription: ride["from_description"],
                toName: ride["to_name"],
                toDescription: ride["to_description"],
                travelers: travelersNamesStr,
              ));
            }
          });
        });
        _rideListSubject.add(rides);
        _rideListForAllocatedSubject.add(ridesForAllocated);
      } catch (error) {
        throw new Exception(error.toString().replaceAll('Exception:', ''));
      }
      return rides;
    }
    return rides;
  }

  Future<Exception?> updateRideFirebase({
    required Ride ride,
    required String? rideUID,
  }) async {
    UserModel? user = await getUser();

    if (user != null && user.carro != null) {
      await FirebaseFirestore.instance
          .collection("ride")
          .doc(rideUID)
          .update({
            "ride_uid": rideUID,
            "driver_uid": ride.driverUid,
            "name_driver": ride.nameDriver,
            "car_model": ride.carModel,
            "hour": ride.hour,
            "date": ride.date,
            "from_name": ride.fromName,
            "from_description": ride.fromDescription,
            "to_name": ride.toName,
            "to_description": ride.toDescription,
            "travelers": ride.travelers,
          })
          .then((value) {})
          .catchError((error) => print("Failed to update user: $error"));
    }
  }

  Future<Exception?> createRide({
    required Ride ride,
  }) async {
    UserModel? user = await getUser();

    if (user != null && user.isMotorista) {
      await FirebaseFirestore.instance
          .collection("ride")
          .doc()
          .set({
            "ride_uid": ride.rideUid,
            "driver_uid": user.uid,
            "name_driver": user.name,
            "car_model": user.carro!.modelo,
            "quantity_seats": user.carro!.assentosDisponiveis,
            "hour": ride.hour,
            "date": ride.date,
            "from_name": ride.fromName,
            "from_description": ride.fromDescription,
            "to_name": ride.toName,
            "to_description": ride.toDescription,
            "travelers": ride.travelers ?? [],
          })
          .then((value) => getRideList())
          .catchError((error) => print("Failed to update user: $error"));
    }
  }

  Future<Exception?> deleteRide({
    required Ride ride,
  }) async {
    UserModel? user = await getUser();

    if (user != null && user.isMotorista) {
      await FirebaseFirestore.instance
          .collection("ride")
          .doc(ride.rideUid)
          .delete()
          .then((value) => getRideList())
          .catchError((error) => print("Failed to update user: $error"));
    }
  }

  Future<Exception?> seatAllocationInRide({
    required Ride ride,
  }) async {
    UserModel? user = await getUser();
    List<Traveler> travelers = ride.travelers ?? [];

    if (user != null) {
      if (travelers.length < ride.quantitySeats) {
        travelers.add(Traveler(id: user.uid, name: user.name));
      }
      await FirebaseFirestore.instance
          .collection("ride")
          .doc(ride.rideUid)
          .update({
            "ride_uid": ride.rideUid,
            "driver_uid": ride.driverUid,
            "name_driver": ride.nameDriver,
            "car_model": ride.carModel,
            "hour": ride.hour,
            "date": ride.date,
            "from_name": ride.fromName,
            "from_description": ride.fromDescription,
            "to_name": ride.toName,
            "to_description": ride.toDescription,
            "travelers": travelers.map((traveler) => traveler.toJson()).toList(),
          })
          .then((value) => getRideList())
          .catchError((error) => print("Failed to update user: $error"));
    }
  }

  Future<Exception?> removeSeatAllocationInRide({
    required Ride ride,
  }) async {
    UserModel? user = await getUser();
    List<Traveler> travelers = ride.travelers ?? [];

    if (user != null) {
      travelers.removeWhere((traveler) => traveler.id == user.uid);

      await FirebaseFirestore.instance
          .collection("ride")
          .doc(ride.rideUid)
          .update({
            "ride_uid": ride.rideUid,
            "driver_uid": ride.driverUid,
            "name_driver": ride.nameDriver,
            "car_model": ride.carModel,
            "hour": ride.hour,
            "date": ride.date,
            "from_name": ride.fromName,
            "from_description": ride.fromDescription,
            "to_name": ride.toName,
            "to_description": ride.toDescription,
            "travelers": travelers.map((traveler) => traveler.toJson()).toList(),
          })
          .then((value) => getRideList())
          .catchError((error) => print("Failed to update user: $error"));
    }
  }

  void dispose() {
    _rideSubject.close();
    _rideListSubject.close();
  }
}
