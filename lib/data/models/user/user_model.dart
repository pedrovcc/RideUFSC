import 'package:boilerplate_flutter/data/models/carro/carro.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel extends Equatable {
  const UserModel({
    required this.uid,
    required this.idUFSC,
    required this.name,
    required this.isMotorista,
    required this.carro,
  });

  final String uid;
  @JsonKey(name: "id_ufsc")
  final String idUFSC;
  final String name;
  @JsonKey(name: "is_motorista") final bool isMotorista;
  final Carro? carro;

  @override
  List<Object?> get props => [uid, idUFSC, name, isMotorista, carro];

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  String firstCharToUpper(String name) {
    return name[0].toUpperCase() + name.substring(1);
  }
}
