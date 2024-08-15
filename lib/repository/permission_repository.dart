import 'dart:convert';
import 'dart:async';

import 'package:sdm/models/permission.dart';
import 'package:sdm/networking/api_provider.dart';

class PermissionRepository {
  final ApiProvider _provider = ApiProvider();
  String? accessToken;
  dynamic inputBody, requestHeaders;

  Future<List<Permission>> getPermission(such, userId) async {
    requestHeaders = <String, String>{
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    inputBody = {"such": such, "ydefz^id": userId};

    final response = await _provider.post("/checkpermission", jsonEncode(inputBody), requestHeaders);

    var itemArray = [];
    var resultLength = jsonDecode(jsonEncode(response)).length;
    for (var i = 0; i < resultLength; i++) {
      itemArray.add(jsonDecode(jsonEncode(response))[i]);
    }

    var list = itemArray;
    List<Permission> org = list.map((obj) => Permission.fromJson(obj)).toList();
    return org;
  }
}
