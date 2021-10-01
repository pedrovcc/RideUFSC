// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'carro.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Carro _$CarroFromJson(Map<String, dynamic> json) {
  return Carro(
    modelo: json['modelo'] as String,
    assentosDisponiveis: json['assentos_disponiveis'] as int,
  );
}

Map<String, dynamic> _$CarroToJson(Carro instance) => <String, dynamic>{
      'modelo': instance.modelo,
      'assentos_disponiveis': instance.assentosDisponiveis,
    };
