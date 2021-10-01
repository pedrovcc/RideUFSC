import 'dart:convert';
import 'dart:io';

import 'package:boilerplate_flutter/data/api/api_constants.dart';
import 'package:boilerplate_flutter/data/api/responses/login/login_response.dart';
import 'package:http/http.dart' as http;

class UserApi {
  static Future<LoginResponse?> login(String email, String password) async {
    Uri url = Uri.parse(ApiConstants.login());
    final http.Response response =
        await http.post(url, body: {'email': email, 'password': password});
    final data = jsonDecode(response.body);
    if (response.statusCode == HttpStatus.ok) {
      final loginResponse = LoginResponse.fromJson(data);
      return loginResponse;
    } else {
      String? error = (data as Map).getErrorString();
      String genericError =
          'Error on request - ${response.statusCode} ${response.reasonPhrase}';
      throw new Exception(error != null ? error : genericError);
    }
  }
}

extension UserError on Map {
  String? getErrorString() {
    String? output;
    ApiConstants.errorIds.forEach((element) {
      if (this.keys.contains(element)) {
        dynamic value = this[element];
        if (value is List) {
          output = value.first;
        } else {
          output = value;
        }
      }
    });
    return output;
  }
}
