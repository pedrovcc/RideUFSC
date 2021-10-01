import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'carro.g.dart';

@JsonSerializable()
class Carro extends Equatable {
  const Carro({
    required this.modelo,
    required this.assentosDisponiveis,
  });

  final String modelo;
  @JsonKey(name: "assentos_disponiveis")
  final int assentosDisponiveis;

  @override
  List<Object> get props => [modelo, assentosDisponiveis];

  factory Carro.fromJson(Map<String, dynamic> json) => _$CarroFromJson(json);

  Map<String, dynamic> toJson() => _$CarroToJson(this);
}
