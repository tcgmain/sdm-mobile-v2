import 'dart:convert';
import 'package:sdm/models/territory.dart';
import 'package:sdm/networking/api_provider.dart';
import 'dart:async';

class TerritoryRepository {
  final ApiProvider _provider = ApiProvider();
  String? accessToken;
  dynamic inputBody, requestHeaders;

  Future<List<Territory>> getTerritory(String userNummer) async {
    requestHeaders = <String, String>{'Content-Type': 'application/json', 'Accept': 'application/json'};

    inputBody = {
      "nummer": userNummer,
      "ysupv^nummer": userNummer,
      "ysupv^ysupv^nummer": userNummer,
      "ysupv^ysupv^ysupv^nummer": userNummer,
      "ysupv^ysupv^ysupv^ysupv^nummer": userNummer,
      "ysupv^ysupv^ysupv^ysupv^ysupv^nummer": userNummer
    };

    final response = await _provider.post("/gettrritorybyemployee", jsonEncode(inputBody), requestHeaders);

    var itemArray = [];
    var resultLength = jsonDecode(jsonEncode(response)).length;
    for (var i = 0; i < resultLength; i++) {
      itemArray.add(jsonDecode(jsonEncode(response))[i]);
    }

    var list = itemArray;
    List<Territory> territory = list.map((obj) => Territory.fromJson(obj)).toList();
    return territory;
  }
}
