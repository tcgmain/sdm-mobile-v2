// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:convert';
import 'package:sdm/models/route_organization2.dart';
import 'package:sdm/networking/api_provider.dart';
import 'dart:async';

class RouteOrganization2Repository {
  final ApiProvider _provider = ApiProvider();
  String? accessToken;
  var inputBody, requestHeaders;

  Future<List<RouteOrganization2>> getRouteOrganization2(String routeNummer, String date) async {
    requestHeaders = <String, String>{'Accept': 'application/json', 'Content-Type': 'application/json'};

    inputBody = {
    "route^nummer": routeNummer,
    "date": date
};

    final response = await _provider.post("/getrouteorganizations", jsonEncode(inputBody), requestHeaders);

    var itemArray = [];
    var resultLength = jsonDecode(jsonEncode(response)).length;
    for (var i = 0; i < resultLength; i++) {
      itemArray.add(jsonDecode(jsonEncode(response))[i]);
    }

    var list = itemArray;
    List<RouteOrganization2> routeOrganization2 = list.map((obj) => RouteOrganization2.fromJson(obj)).toList();
    return routeOrganization2;
  }
}
