// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ride.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Ride _$RideFromJson(Map<String, dynamic> json) {
  return Ride(
    rideUid: json['ride_uid'] as String,
    driverUid: json['driver_uid'] as String,
    nameDriver: json['name_driver'] as String,
    carModel: json['car_model'] as String,
    quantitySeats: json['quantity_seats'] as int,
    hour: json['hour'] as String,
    date: json['date'] as String,
    fromName: json['from_name'] as String,
    fromDescription: json['from_description'] as String,
    toName: json['to_name'] as String,
    toDescription: json['to_description'] as String,
    travelers: (json['travelers'] as List<dynamic>?)
        ?.map((e) => Traveler.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$RideToJson(Ride instance) => <String, dynamic>{
      'ride_uid': instance.rideUid,
      'driver_uid': instance.driverUid,
      'name_driver': instance.nameDriver,
      'car_model': instance.carModel,
      'quantity_seats': instance.quantitySeats,
      'hour': instance.hour,
      'date': instance.date,
      'from_name': instance.fromName,
      'from_description': instance.fromDescription,
      'to_name': instance.toName,
      'to_description': instance.toDescription,
      'travelers': instance.travelers,
    };
