import 'package:boilerplate_flutter/data/models/user/user_model.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'login_response.g.dart';

@JsonSerializable()
class LoginResponse extends Equatable {
  const LoginResponse({
    required this.token,
    required this.user,
  });

  final String token;
  final UserModel user;

  @override
  List<Object> get props => [token, user];

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);

  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);
}
