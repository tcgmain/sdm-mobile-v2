import 'dart:convert';
import 'package:sdm/models/change_password.dart';
import 'package:sdm/networking/api_provider.dart';
import 'dart:async';

class ChangePasswordRepository {
  final ApiProvider _provider = ApiProvider();
  String? accessToken;
  dynamic inputBody, requestHeaders;

  Future<ChangePassword> changeNewPassword(String newpassword, userId) async {
    
    requestHeaders = <String, String>{
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    inputBody = {"id": userId, "ysdmpwd": newpassword};

    final response = await _provider.post("/changepassword", jsonEncode(inputBody), requestHeaders);
    return ChangePassword.fromJson(response);
  }
}
