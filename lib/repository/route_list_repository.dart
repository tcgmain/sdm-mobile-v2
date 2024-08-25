// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:convert';
import 'package:sdm/models/route_list.dart';
import 'package:sdm/networking/api_provider.dart';
import 'dart:async';

class RouteListRepository {
  final ApiProvider _provider = ApiProvider();
  String? accessToken;
  var inputBody, requestHeaders;

  Future<List<RouteList>> getRouteList(String nummer) async {
    requestHeaders = <String, String>{'Accept': 'application/json', 'Content-Type': 'application/json'};

    inputBody = {"nummer": nummer};

    final response = await _provider.post("/getroutelist", jsonEncode(inputBody), requestHeaders);
    var itemArray = [];
    var resultLength = jsonDecode(jsonEncode(response)).length;
    for (var i = 0; i < resultLength; i++) {
      itemArray.add(jsonDecode(jsonEncode(response))[i]);
    }

    var list = itemArray;
    List<RouteList> routeList = list.map((obj) => RouteList.fromJson(obj)).toList();
    return routeList;
  }
}
