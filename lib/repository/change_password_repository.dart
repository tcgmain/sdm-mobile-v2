import 'dart:convert';
import 'package:sdm/models/change_password.dart';
import 'package:sdm/networking/api_provider.dart';
import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

class ChangePasswordRepository {
  final ApiProvider _provider = ApiProvider();
  String? accessToken;
  dynamic inputBody, requestHeaders;

  Future<ChangePassword> changeNewPassword(String newpassword, loginId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString('userId') ?? 'Guest';

    requestHeaders = <String, String>{
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    inputBody = {
      "id": userId, 
      "ysdmpwd": newpassword
    };

    final response = await _provider.post("/changepassword", jsonEncode(inputBody), requestHeaders);
    return ChangePassword.fromJson(response);
  }
}
