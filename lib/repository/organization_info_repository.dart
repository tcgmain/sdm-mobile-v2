import 'dart:convert';
import 'dart:async';

import 'package:sdm/models/organization.dart';
import 'package:sdm/networking/api_provider.dart';

class OrganizationInfoRepository {
  final ApiProvider _provider = ApiProvider();
  String? accessToken;
  dynamic inputBody, requestHeaders;

  Future<List<Organization>> getOrganizationInfo(nummer) async {
    requestHeaders = <String, String>{
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    inputBody = {
      "nummer": nummer,
    };

    final response = await _provider.post("/getorganizationinfo", jsonEncode(inputBody), requestHeaders);

    var itemArray = [];
    var resultLength = jsonDecode(jsonEncode(response)).length;
    for (var i = 0; i < resultLength; i++) {
      itemArray.add(jsonDecode(jsonEncode(response))[i]);
    }

    var list = itemArray;
    List<Organization> org = list.map((obj) => Organization.fromJson(obj)).toList();
    return org;
  }
}
