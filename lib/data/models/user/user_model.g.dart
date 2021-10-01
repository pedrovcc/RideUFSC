// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) {
  return UserModel(
    uid: json['uid'] as String,
    idUFSC: json['id_ufsc'] as String,
    name: json['name'] as String,
    isMotorista: json['is_motorista'] as bool,
    carro: json['carro'] == null
        ? null
        : Carro.fromJson(json['carro'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'uid': instance.uid,
      'id_ufsc': instance.idUFSC,
      'name': instance.name,
      'is_motorista': instance.isMotorista,
      'carro': instance.carro,
    };
