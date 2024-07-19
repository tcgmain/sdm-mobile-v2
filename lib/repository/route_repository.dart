// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:convert';
import 'package:sdm/models/route.dart';
import 'package:sdm/networking/api_provider.dart';
import 'dart:async';

class RouteRepository {
  final ApiProvider _provider = ApiProvider();
  String? accessToken;
  var inputBody, requestHeaders;

  Future<List<Routes>> getRoute(String username, String date) async {
    requestHeaders = <String, String>{'Accept': 'application/json', 'Content-Type': 'application/json'};
    inputBody = {"ysdmem^nummer": username, "ypldate": date};

    final response = await _provider.post("/getrouteassignment", jsonEncode(inputBody), requestHeaders);

    var itemArray = [];
    var resultLength = jsonDecode(jsonEncode(response)).length;
    for (var i = 0; i < resultLength; i++) {
      itemArray.add(jsonDecode(jsonEncode(response))[i]);
    }

    var list = itemArray;
    List<Routes> route = list.map((obj) => Routes.fromJson(obj)).toList();
    return route;
  }
}
