import 'dart:convert';
import 'package:sdm/networking/api_provider.dart';
import 'package:sdm/models/town.dart';
import 'dart:async';

class TownRepository {
  final ApiProvider _provider = ApiProvider();
  String? accessToken;
  dynamic inputBody, requestHeaders;

  Future<List<Town>> getTown(String territory) async {
    requestHeaders = <String, String>{'Content-Type': 'application/json', 'Accept': 'application/json'};

    inputBody = {
      "nummer": territory
    };

    final response = await _provider.post("/gettown", jsonEncode(inputBody), requestHeaders);

    var itemArray = [];
    var resultLength = jsonDecode(jsonEncode(response)).length;
    for (var i = 0; i < resultLength; i++) {
      itemArray.add(jsonDecode(jsonEncode(response))[i]);
    }

    var list = itemArray;
    List<Town> town = list.map((obj) => Town.fromJson(obj)).toList();
    return town;
  }
}
