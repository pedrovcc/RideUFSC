import 'package:boilerplate_flutter/data/models/traveler/traveler.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ride.g.dart';

@JsonSerializable()
class Ride extends Equatable {
  const Ride({
    required this.rideUid,
    required this.driverUid,
    required this.nameDriver,
    required this.carModel,
    required this.quantitySeats,
    required this.hour,
    required this.date,
    required this.fromName,
    required this.fromDescription,
    required this.toName,
    required this.toDescription,
    required this.travelers,
  });

  @JsonKey(name: "ride_uid")
  final String rideUid;
  @JsonKey(name: "driver_uid")
  final String driverUid;
  @JsonKey(name: "name_driver")
  final String nameDriver;
  @JsonKey(name: "car_model")
  final String carModel;
  @JsonKey(name: "quantity_seats")
  final int quantitySeats;
  final String hour;
  final String date;
  @JsonKey(name: "from_name")
  final String fromName;
  @JsonKey(name: "from_description")
  final String fromDescription;
  @JsonKey(name: "to_name")
  final String toName;
  @JsonKey(name: "to_description")
  final String toDescription;
  final List<Traveler>? travelers;

  @override
  List<Object?> get props => [
        rideUid,
        driverUid,
        nameDriver,
        quantitySeats,
        carModel,
        hour,
        date,
        fromName,
        fromDescription,
        toName,
        toDescription,
        travelers
      ];

  factory Ride.fromJson(Map<String, dynamic> json) => _$RideFromJson(json);

  Map<String, dynamic> toJson() => _$RideToJson(this);
}
