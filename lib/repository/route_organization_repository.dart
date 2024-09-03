// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:convert';
import 'package:sdm/models/route_organization.dart';
import 'package:sdm/networking/api_provider.dart';
import 'dart:async';

class RouteOrganizationRepository {
  final ApiProvider _provider = ApiProvider();
  String? accessToken;
  var inputBody, requestHeaders;

  Future<List<RouteOrganization>> getRouteOrganization(String nummer) async {
    requestHeaders = <String, String>{'Accept': 'application/json', 'Content-Type': 'application/json'};

    inputBody = {"nummer": nummer};

    final response = await _provider.post("/getroute", jsonEncode(inputBody), requestHeaders);

    var itemArray = [];
    var resultLength = jsonDecode(jsonEncode(response)).length;
    for (var i = 0; i < resultLength; i++) {
      itemArray.add(jsonDecode(jsonEncode(response))[i]);
    }

    var list = itemArray;
    List<RouteOrganization> routeOrganization = list.map((obj) => RouteOrganization.fromJson(obj)).toList();
    return routeOrganization;
  }

  Future<List<RouteOrganization>> getRouteOrganizationByOrg(String organizationNummer) async {
    requestHeaders = <String, String>{'Accept': 'application/json', 'Content-Type': 'application/json'};

    inputBody = {"ysdmorg^nummer": organizationNummer};

    final response = await _provider.post("/getroutebyorg", jsonEncode(inputBody), requestHeaders);

    var itemArray = [];
    var resultLength = jsonDecode(jsonEncode(response)).length;
    for (var i = 0; i < resultLength; i++) {
      itemArray.add(jsonDecode(jsonEncode(response))[i]);
    }
print("LLLLLLLLLLLLLLLLL");
    var list = itemArray;
    List<RouteOrganization> routeOrganization = list.map((obj) => RouteOrganization.fromJson(obj)).toList();
    return routeOrganization;
  }
}
