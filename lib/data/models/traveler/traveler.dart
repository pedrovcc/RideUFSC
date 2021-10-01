import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'traveler.g.dart';

@JsonSerializable()
class Traveler extends Equatable {
  const Traveler({
    required this.id,
    required this.name,
  });

  final String  id;
  final String name;

  @override
  List<Object> get props => [id, name];

  factory Traveler.fromJson(Map<String, dynamic> json) => _$TravelerFromJson(json);

  Map<String, dynamic> toJson() => _$TravelerToJson(this);
}
